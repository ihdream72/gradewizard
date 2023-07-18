
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/logger.dart';
import '../../../core/values/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../model/subtitles_model.dart';
import '../view_model/chunk_view_model.dart';
import '../view_model/sentence_view_model.dart';
import '../view_model/word_view_model.dart';

/// scroll 제어를 위한 Type 들
enum ScrollType { autoNextSentence, afterScroll, justGo }
/// View 테마
enum ViewMode { dark, light }
/// 테마를 위한 Color Element
enum ColorElement {
  background,         /// 전체 화면에 대한 배경색
  textPlayingEnable,  /// 재생중 자막 글자 ( 자막이 플레이 중 )
  textPlayingDisable, /// 재생중 자막 글자 ( 다른 자막이 플레이 중 )
  textPause,          /// 정지중 자막 글자
  textSelect,         /// 선택된 자막 단어
  titleBackground,    /// Title 의 배경색
  titleText,          /// Title 글자색
  headerBackground,   /// header 의 배경색
  headerText,         /// header 글자색
  controlBackground,  /// Audio Controller 의 배경색
  icon,               /// google Material UI Icon color
  tooltipBackground,  /// tooltip 의 배경색
  tooltipText,        /// tooltip 글자색
  tooltipIcon,        /// tooltip 의 google Material UI Icon color
}

class AudioReadingController extends BaseController {

  ///====================================================================
  /// Rx Data 선언
  ///====================================================================
  /// RxList: 자막 ViewModel
  RxList<SentenceViewModel> sentences = RxList<SentenceViewModel>.empty();
  /// RxDouble: 현재 Scrolled Offset - Worker 의 Debounce 설정을 위해
  final RxDouble curOffset = 0.0.obs;
  /// Rx<ViewMode>: Dark/Light Mode 테마 값
  final Rx<ViewMode> _viewMode = Rx<ViewMode>(ViewMode.dark);
  ViewMode get viewMode => _viewMode.value; // getter
  set viewMode(mode) => _viewMode(mode);    // setter
  /// RxBool: 오디오 가 재생 중인지 여부를 판단 하는 Rx 데이터
  RxBool isPlaying = true.obs;
  /// RxInt: Header 영역에 보여줄 현재 재생 중인 문장의 Index
  RxInt curSentenceIndex = 0.obs;
  /// RxInt: Drag 되고 있는 문장의 Index ( -1: not Exist )
  RxInt dragSentenceIndex = (-1).obs;
  /// RxBool: ToolTip 이 보여 지고 있는 여부를 지정
  RxBool isTooltip = (false).obs;

  ///====================================================================
  /// 사용 하는 Widget or Controller
  ///====================================================================
  /// Audio Player
  final AudioPlayer player = AudioPlayer();

  /// Scroll Controller
  ScrollController? scrollController;
  /// ToolTip Controller
  JustTheController? tooltipController;
  /// debounce Worker
  Worker? debounceWorker;
  /// ListView 의 Scroll 위치를 계산 하기 위한 ListView 의 GlobalKey
  final GlobalKey listKey = GlobalKey();

  ///====================================================================
  /// 사용 하는 변수들.
  ///====================================================================
  /// 사용자 의 Scroll 여부
  bool isUserScroll = false;
  /// 최근 문장 과 최근 Chunk
  SentenceViewModel? lastSentence;
  ChunkViewModel? lastChunk;
  WordViewModel? selectedWord;  // 사용자 가 선택한 단어.
  /// 사용자 에 의한 스크롤 이 아닌 오디오 진행에 따른 스크롤 인지 여부.
  bool isInAutoScroll = false;
  /// 문장 이동이 필요 한지 판단 하는 내부 변수
  bool isNeedMoveSentence = false;

  ///====================================================================
  /// 테마 Color 값 설정
  /// ====================================================================
  /// dark 테마와 light 테마의 색상값 지정
  final Map<ViewMode, Map<ColorElement, Color>> colorMap = <ViewMode, Map<ColorElement, Color>>{
    /// 다크 모드
    ViewMode.dark : {
      ColorElement.background: AppColors.black,
      ColorElement.textPlayingEnable: AppColors.white,
      ColorElement.textPlayingDisable: AppColors.white.withOpacity(0.2),
      ColorElement.textPause: AppColors.white,
      ColorElement.textSelect: AppColors.orange01,
      ColorElement.titleBackground: AppColors.black,
      ColorElement.titleText: AppColors.white,
      ColorElement.headerBackground: AppColors.text04,
      ColorElement.headerText: AppColors.white,
      ColorElement.controlBackground: AppColors.black,
      ColorElement.icon: AppColors.white,
      ColorElement.tooltipBackground: AppColors.white,
      ColorElement.tooltipText: AppColors.black,
      ColorElement.tooltipIcon: AppColors.black,
    },
    /// Light 모드
    ViewMode.light : {
      ColorElement.background: AppColors.white,
      ColorElement.textPlayingEnable: AppColors.black,
      ColorElement.textPlayingDisable: AppColors.black.withOpacity(0.2),
      ColorElement.textPause: AppColors.black,
      ColorElement.textSelect: AppColors.orange01,
      ColorElement.titleBackground: AppColors.white,
      ColorElement.titleText: AppColors.black,
      ColorElement.headerBackground: AppColors.text08,
      ColorElement.headerText: AppColors.black,
      ColorElement.controlBackground: AppColors.white,
      ColorElement.icon: AppColors.black,
      ColorElement.tooltipBackground: AppColors.black,
      ColorElement.tooltipText: AppColors.white,
      ColorElement.tooltipIcon: AppColors.white,
    },
  };

  @override
  void onInit() {
    super.onInit();

    /// 초기값 설정
    curSentenceIndex(0);
    dragSentenceIndex(-1);
    viewMode = ViewMode.dark;

    /// Scroll Listener 등록
    scrollController = ScrollController();
    scrollController?.addListener(scrollListener);
    /// tooltip Controller 생성
    tooltipController = JustTheController();

    /// Assets 에서 Local Audio / SubTitle 정보를 읽어 온다.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchAudioBook();
    });
  }

  @override
  void onClose() {

    // ScrollController 자원 반납
    scrollController?.removeListener(scrollListener);
    scrollController?.dispose();

    // tooltip Controller 자원 반납
    tooltipController?.dispose();

    // Player 자원 반납
    player.stop();
    player.dispose();

    // Worker 자원 반납
    debounceWorker?.dispose();

    super.onClose();
  }

  @override
  Future<bool> goBack() async {
    unFocusAll();

    Get.back();

    return Future.value(false);
  }

  ///====================================================================
  ///
  ///  Repository 및 Data Model / View Model 관련 함수들.
  ///
  /// ====================================================================
  /// 오디오 파일과 자막 파일을 읽어 온다.
  Future<void> fetchAudioBook() async {
    String data = await rootBundle.loadString('assets/data/data.json');
    SubTitlesModel subtitle = SubTitlesModel.fromJson(jsonDecode(data));

    // fetch 자막 정보
    sentences.assignAll(subtitle.toViewModel().sentences!);

    if(scrollController != null && scrollController!.hasClients) {
      curOffset(scrollController!.offset);
    }

    /// 스크롤 종료 Worker 등록 : Scroll 이 멈추고 2초 이후에 실행됨
    setScrollDebounce(2);

    // fetch Audio 정보를 Player 에 지정
    player.setAsset('assets/data/audio.m4a');

    // Audio Player 가 재생 할때 재생 위치에 대한 Listener 등록
    setPlayPositionListener();

    /// Audio 재생
    player.play();
  }

  ///====================================================================
  ///
  ///  Controller / Listener / Widget 등등 관련 설정 및 해제 관련 기능 함수
  ///
  /// ====================================================================
  /// 스크롤 되는 위치를 가져 오고 제어 하는 Scroll Listener
  void scrollListener() {

    if(curOffset.value == scrollController!.offset) {
      return;
    }

    if(!isUserScroll && !isInAutoScroll) {
      /// User 스크롤 시작 Point
      onStartUserScroll();
      curOffset(scrollController!.offset);
    } else if(isUserScroll) {
      curOffset(scrollController!.offset);
    }
  }

  /// Audio Play 되는 time 에 대한 Listener
  /// 여기서 자막에 대한 처리 및 자동 스크롤 을 처리 다.
  void setPlayPositionListener() {

    player.positionStream.listen((duration) {
      int audioTime = duration.inMilliseconds;
      //Log.d('Playing 위치(ms) : ${duration.inMilliseconds}');
      /// 여기서 계산 하여 activation 시킬 sentence 와 chunk 구하여 'RxBool isActivate' 를 변경 한다..

      /// 오디오 시간 정보에 해당 하는 문장 서치.
      SentenceViewModel? curSentence = sentences.firstWhereOrNull((e) => audioTime >= e.startTime && audioTime <= e.endTime);

      if(curSentence != null) {
        /// 찾은 문장을 Activate
        curSentence.isActivate(true);
        curSentenceIndex(sentences.indexOf(curSentence));

        /// 오디오 시간 정보에 해당 하는 Chunk 서치.
        ChunkViewModel? curChunk = curSentence.chunks.firstWhereOrNull((e) => audioTime >= e.startTime && audioTime <= e.endTime);

        if(curChunk != null) {
          /// 찾은 Chunk 를 Activate
          curChunk.isActivate(true);
          if(lastChunk != curChunk && lastChunk != null) {
            /// 다음 chunk 로 이동, 이전 chunk 해제
            lastChunk!.isActivate(false);
          }
          lastChunk = curChunk;
        }

        /// 문장이 변경 되었는 지 확인
        if(lastSentence != curSentence && lastSentence != null) {

          /// 마지막 문장이 아니면
          if(lastSentence != sentences.last) {
            /// 다음 문장 으로 넘어 간다. 이전 문장 해제
            lastSentence!.isActivate(false);

            /// 다음 문장 으로 자동 스크롤 진행
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              scrollToSentence(curSentence, type: ScrollType.autoNextSentence);
            });
          } else {
            /// 마지막 문장 이면 시간이 지나도 줄 바꿈을 하지 않고 종료 할때 까지 대기 한다.
          }
        }
        lastSentence = curSentence;
      }

    });
  }

  /// debounce Worker 등록
  /// 지정한 초 동안 사용자 의 Scroll 입력이 없을 경우 onEndScroll()를 호출.
  void setScrollDebounce(int second) {
    debounceWorker = debounce(curOffset, (_) async {
      onEndUserScroll();
    }, time: Duration(seconds: second));
  }

  /// debounce Worker 해제
  void clearScrollDebounce() {
    debounceWorker?.dispose();
    debounceWorker = null;
  }

  void clearSelectedWord() {
    if(selectedWord != null) {
      selectedWord!.selectedSentenceIndex = -1;
      selectedWord!.selectedChunkIndex = -1;
      selectedWord!.isSelected(false);
    }
  }

  void userSelectWord(SentenceViewModel sentence, ChunkViewModel chunk, WordViewModel word) {

    clearSelectedWord();

    pause();

    word.selectedSentenceIndex = sentence.index;
    word.selectedChunkIndex = chunk.index;
    Log.d('selected \'${word.text}, 문장(${sentence.index}), Chunk(${chunk.index})\'');
    word.isSelected(true);

    selectedWord = word;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      tooltipController?.showTooltip();
    });

  }

  ///====================================================================
  ///
  ///  Scroll 관련 기능 함수
  ///
  /// ====================================================================
  /// 각 문장의 Scroll 을 위한 Offset 을 지정
  /// GlobalKey 를 이용 하여 문장의 RenderBox 를 찾아서 렌더링 되는 위치를 구하여 Scroll 시 Offset 을 지정 한다.
  void setRenderingOffset(SentenceViewModel sentence) {

    if(sentence.offset == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(sentence.key.currentContext != null) {
          RenderBox sentenceBox = sentence.key.currentContext!.findRenderObject()! as RenderBox;
          RenderBox listViewBox = listKey.currentContext!.findRenderObject()! as RenderBox;
          Offset listViewPosition = listViewBox.localToGlobal(Offset.zero);

          /// 상단 50 px 아래에 위치 하도록 한다.
          sentence.offset = sentenceBox.localToGlobal(Offset(0, scrollController!.offset - listViewPosition.dy - (/*50 * Get.pixelRatio*/ 50)));
        } else {
          Log.e('문장의 RenderBox 정보를 가져올 수 없습니다.  스크롤 을 빨리 하면 발생할 수 있음..  그 이외의 경우는 문제가 있는 경우 확인이 필요');
        }
      });
    }
  }

  /// 사용자 에 의한 Scroll 이 시작될 때의 처리를 담당
  Future<void> onStartUserScroll() async {
    if(player.playing) {
      Log.d('사용자 Scroll 시작');
      isUserScroll = true;
    }
  }

  /// 사용자 에 의한 Scroll 이 종료 될 때의 처리를 담당
  Future<void> onEndUserScroll() async {
    // 마지막 자막 위치로 이동
    if(isUserScroll && lastSentence != null && !isTooltip.value) {
      Log.d('사용자 Scroll 종료');
      scrollToSentence(lastSentence!, type: ScrollType.afterScroll);
    }
  }

  /// 지정된 문장 으로 Scroll 및 Play 이동
  Future<void> moveSentence(SentenceViewModel sentence) async {

    Log.d('문장 이동 => index(${sentence.index})');
    // 스크롤 위치 이동
    scrollToSentence(sentence, type: ScrollType.justGo);
    // Audio Play 지점 변경
    player.seek(Duration(milliseconds: sentence.startTime));

    if(!player.playing) {
      /// 멈춰 있으면 플레이 한다.
      player.play();
    }
    curSentenceIndex(sentence.index);
  }

  /// 지정한 문장 으로 Scroll 이동 ( ScrollType 별로 구분 )
  Future<void> scrollToSentence(SentenceViewModel sentence, { ScrollType type = ScrollType.justGo }) async {

    switch(type) {

      case ScrollType.autoNextSentence:
        /// Play 중에 다음 문장 으로 자동 스크롤
        Log.d('다음 문장 으로 자동 으로 스크롤 합니다.');
        if(!isUserScroll && scrollController != null && scrollController!.hasClients) {
          isInAutoScroll = true;
          await _scrollToSentence(sentence);
          isInAutoScroll = false;
        }
        break;
      case ScrollType.afterScroll:
        /// 사용자 의 스크롤 이후에 현재 플레이 중인 문장 으로 복귀 하기 위해 스크롤 합니다.
        Log.d('현재 플레이 중인 문장 으로 복귀 하기 위해 스크롤 합니다.');
        if(isUserScroll) {
          await _scrollToSentence(sentence);
          isUserScroll = false;
        }
        break;
      case ScrollType.justGo:
        Log.d('지정한 문장 으로 이동 합니다.');
        isInAutoScroll = true;
        await _scrollToSentence(sentence);
        isInAutoScroll = false;
        break;
    }
  }

  void onScrollNotification(ScrollNotification notification, SentenceViewModel sentence) {
    if (notification is ScrollStartNotification) {
      /// Drag 를 시작 하면 배경색 을 변경
      dragSentenceIndex(sentence.index);
      isNeedMoveSentence = false;
    } else if (notification is ScrollUpdateNotification) {
      /// Drag 가 된 문장 으로 이동 한다.
      //Log.d('Drag Update : ${notification.metrics.pixels}');
      // Drag 민감도 조절 어는 일정 수순 Drag 할 경우만 문장 이동을 동작 하자
      if (notification.metrics.pixels <= -40) {
        isNeedMoveSentence = true;
      }
    } else if (notification is ScrollEndNotification) {

      if (isNeedMoveSentence) {
        /// 일정 수준 이상 Drag 가 된 문장 인지 구별 해서.
        /// Drag 가 된 문장 으로 이동 한다.
        moveSentence(sentence);
      }
      dragSentenceIndex(-1);
      isNeedMoveSentence = false;
    }
  }

  /// 지정한 문장 으로 실제로 Scroll 이동 하는 내부 함수
  /// 상단 에서 offset(50px) 만큼 여백을 둔 문장의 offset 으로 이동 한다.
  Future<void> _scrollToSentence(SentenceViewModel sentence) async {

    if(sentence.offset == null) {
      Log.e('문장의 스크롤 위치가 지정 되지 않음... 이런 경우는 발생 하면 안된다.');
      return;
    }

    double offset = sentence.offset!.dy;

    if (offset > scrollController!.position.maxScrollExtent) {
      /// 스트롤 가능한 범위를 벗어남. 이 경우는 Max 로 설정
      offset = scrollController!.position.maxScrollExtent;
    }

    await scrollController!.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }


  ///====================================================================
  ///
  ///  Audio Controller 관련 기능 함수
  ///
  /// ====================================================================
  /// Audio Control UI의 이전 버튼 Action Handler
  void playPrevious() async {
    if(lastSentence != null) {

      int curIndex = sentences.indexOf(lastSentence);

      /// 첫 문장이 아니면
      if(curIndex > 0) {
        // 스크롤 위치 이동
        await scrollToSentence(sentences[curIndex-1], type: ScrollType.justGo);
        // Audio Play 지점 변경
        await player.seek(Duration(milliseconds: sentences[curIndex-1].startTime));

        if(!player.playing) {
          /// 멈춰 있으면 플레이 한다.
          player.play();
        }
      }
    }
  }
  /// Audio Control UI의 다음 버튼 Action Handler
  void playNext() async {

    if(lastSentence != null) {

      /// 마지막 문장이 아니면
      if(lastSentence != sentences.last) {
        int curIndex = sentences.indexOf(lastSentence);
        // 스크롤 위치 이동
        scrollToSentence(sentences[curIndex+1], type: ScrollType.justGo);
        // Audio Play 지점 변경
        player.seek(Duration(milliseconds: sentences[curIndex+1].startTime));

        if(!player.playing) {
          /// 멈춰 있으면 플레이 한다.
          player.play();
        }
      }
    }
  }

  /// Audio Control UI의 재생 버튼 Action Handler
  void play() async {

    if(lastSentence != null) {
      /// 마지막 문장 으로 Scroll
      scrollToSentence(lastSentence!, type: ScrollType.justGo);
    }

    if(!player.playing) {
      /// 재생 중이 아니면 플레이 한다.
      player.play();
    }
  }

  /// Audio Control UI의 재시작 버튼 Action Handler
  void rePlay() async {

    /// 처음 으로 이동
    scrollToSentence(sentences.first, type: ScrollType.justGo);

    /// 처음 부터 플레이
    player.seek(Duration.zero);
    player.play();

    curSentenceIndex(0);

  }

  /// Audio Control UI의 멈춤 버튼 Action Handler
  void pause() async {
    player.pause();
  }

  /// Audio Control UI의 볼륨 버튼 Action Handler
  void setVolume(double vol) {
    player.setVolume(vol);
  }

  /// Audio Control UI의 재생 속도 버튼 Action Handler
  void setSpeed(double speed) {
    player.setSpeed(speed);
  }

  ///====================================================================
  ///
  ///  ToolTip 관련 기능 함수
  ///
  /// ====================================================================
  void bookmark(WordViewModel word) {
    /// Not implemented yet
  }

  void playWord(WordViewModel word) {
    /// Not implemented yet
  }

  Future<void> goWordDetailView(WordViewModel word) async {
    /// WebView 로 다음 dic.daum.net 에 연결
    Log.d('Daum 어학 사전에 Web 으로 이동 (${word.text})');

    /// tooltip 이 켜져 있는 동안 ( Modal 로 되어 있어서 그런지.)
    /// 오픈된 다른 View 에서 터치 Event 가 동작 하지 않는다.. 이 때문에. 이동 전에 ToolTip 을 Hide 한다.
    await tooltipController?.hideTooltip(immediately: true);
    Get.toNamed(Routes.webview, arguments: {'title': word.text, 'url': 'https://dic.daum.net/search.do?q=${word.text}'});
  }
}