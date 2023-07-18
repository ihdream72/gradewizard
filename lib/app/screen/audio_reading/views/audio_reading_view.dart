
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../../../core/utils/logger.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_values.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/common/common_title_bar.dart';
import '../view_model/chunk_view_model.dart';
import '../view_model/sentence_view_model.dart';
import '../view_model/word_view_model.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/ui_size_config.dart';
import '../controllers/audio_reading_controller.dart';
import '../widget/control_button.dart';

class AudioReadingView extends BaseView<AudioReadingController> {

  const AudioReadingView({super.key});

  @override
  Widget? appBar(BuildContext context) {

    Log.d('appBar Widget build');

    return Obx(() => CTitleBar(
      title: 'BTS UN 연셜',
      titleColor: controller.colorMap[controller.viewMode]![ColorElement.titleText]!,
      backWidget: SizedBox(
        width: AppValues.appBarSize,
        height: AppValues.appBarSize,
        child: Icon(Icons.arrow_back, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!,),
      ),
      onBack: () => controller.goBack(),
      color: controller.colorMap[controller.viewMode]![ColorElement.titleBackground]!,
      mode: controller.viewMode == ViewMode.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      listRightActionWidget: [
        SizedBox(
          width: AppValues.appBarSize,
          height: AppValues.appBarSize,
          child: IconButton(
            icon: Icon(Icons.light_mode, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!),
            onPressed: () {
              if(controller.viewMode == ViewMode.dark) {
                controller.viewMode = ViewMode.light;
              } else {
                controller.viewMode = ViewMode.dark;
              }
            },
          ),
        )
      ],
    ));
  }

  @override
  Widget body(BuildContext context) {
    Log.d('body Widget build');

    return Obx(() => Container(
      color: controller.colorMap[controller.viewMode]![ColorElement.background]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          subTitles(),
          ControlButton(controller),
        ],
      ),
    ));
  }

  Widget header() {
    Log.d('header Widget build');
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Get.width,
          height: 32.s,
          padding: EdgeInsets.only(left: 16.s),
          alignment: Alignment.centerLeft,
          color: controller.colorMap[controller.viewMode]![ColorElement.headerBackground]!,
          child: Text('${controller.curSentenceIndex.value+1}/${controller.sentences.length}',
            style: Styles.suitMDMedium.copyWith(color: controller.colorMap[controller.viewMode]![ColorElement.headerText]!)),
        ),
        Container(
          width: ((controller.curSentenceIndex.value+1) * (Get.width/controller.sentences.length)).toDouble(),
          height: 2,
          color: AppColors.orange04,
        )
      ],
    ));
  }

  Widget subTitles() {

    return Obx(() {
      Log.d('viewBody Widget build');

      return Expanded(
        child: ListView.separated(
          key: controller.listKey,
          shrinkWrap: false,
          primary: false,
          padding: const EdgeInsets.only(top: /*50 * Get.pixelRatio*/ 50, bottom: 80),
          controller: controller.scrollController,
          itemCount: controller.sentences.length,
          /// ToolTip 이 보여 지는 상황 에서는 Scroll 을 막는다.
          physics: controller.isTooltip.value ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
            return Obx(() => sentenceItem(controller.sentences[index]));
          }, separatorBuilder: (context, index) {
            /// 문장 사이는 80px 을 띄운다.
            return const SizedBox(height:  /*80 * Get.pixelRatio*/ 80,);
          },
        ),
      );
    });
  }

  Widget sentenceItem(SentenceViewModel sentence) {

    //Log.d('sentenceItem Widget build');

    List<Widget> textList = <Widget>[];

    for(ChunkViewModel chunk in sentence.chunks) {
      List<Widget> chunkList = <Widget>[];

      for(WordViewModel word in chunk.words){
        chunkList.add(wordItem(sentence, chunk, word));
      }

      controller.setRenderingOffset(sentence);
      textList.addAll(chunkList);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {

        controller.onScrollNotification(notification, sentence);
        return false;
      },
      /// 문장이 오른쪽 으로 Drag 되도록 수정
      child: SingleChildScrollView(
        primary: true,
        /// ToolTip 이 보여 지는 상황 에서는 Scroll 을 막는다.
        physics: controller.isTooltip.value ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(8.s),
        child: Container(
          key: sentence.key,
          width: Get.width,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.s),
          decoration: BoxDecoration(
            border: Border.all(color: controller.dragSentenceIndex.value == sentence.index ? AppColors.orange03.withOpacity(0.2) : controller.colorMap[controller.viewMode]![ColorElement.background]!),
            borderRadius: BorderRadius.circular(4.s),
            color: controller.dragSentenceIndex.value == sentence.index ? AppColors.orange03.withOpacity(0.2) : controller.colorMap[controller.viewMode]![ColorElement.background]!,
          ),
          child: Wrap(
            spacing: 8.s,
            runSpacing: 8.s,
            children: textList,
          ),
        ),
      ),
    );
  }

  Widget wordItem(SentenceViewModel sentence, ChunkViewModel chunk, WordViewModel word) {

    return Obx(() {
      //Log.d('Text Widget update : (${word.text}) => ${chunk.isActivate.value ? 'ON' : 'OFF'}');

      Color textColor;

      if((controller.isPlaying.value && chunk.isActivate.value) || !controller.isPlaying.value) {
        textColor = controller.dragSentenceIndex.value == sentence.index ? AppColors.white : controller.colorMap[controller.viewMode]![ColorElement.textPlayingEnable]!;
      } else {
        textColor = controller.dragSentenceIndex.value == sentence.index ? AppColors.white : controller.colorMap[controller.viewMode]![ColorElement.textPlayingDisable]!;
      }

      if(!word.isSelected.value) {

        return GestureDetector(
            onTap: () {
              controller.userSelectWord(sentence, chunk, word);
            },
            child: Text(word.text, style: Styles.suitLGRegular.copyWith(color: textColor,)
        ));
      }

      return JustTheTooltip(
        backgroundColor: controller.colorMap[controller.viewMode]![ColorElement.tooltipBackground]!,
        controller: controller.tooltipController,
        tailLength: 10.s,
        tailBaseWidth: 20.s,
        isModal: true,
        preferredDirection: AxisDirection.up,
        borderRadius: BorderRadius.circular(8.0),
        offset: 0,
        content: tooltipItem(word),
        onShow: () {
          Log.d('####### ToolTip ON');
          controller.isTooltip(true);
        },
        onDismiss: () {
          Log.d('####### ToolTip OFF');
          controller.isTooltip(false);
          controller.selectedWord?.isSelected(false);
          controller.selectedWord = null;
        },
        child: GestureDetector(
            onTap: () {
              controller.userSelectWord(sentence, chunk, word);
            },
            child: Text(word.text, style: Styles.suitLGRegular.copyWith(color: textColor, decoration: TextDecoration.underline))
        ),
      );
    });
  }

  Widget tooltipItem(WordViewModel word) {

    /// 어학 사전에 대한 데이터 가 없어
    /// 샘플 데이터 로 Hard Coding
    return Container(
      width: 200.s,
      height: 165.s,
      padding: EdgeInsets.all(16.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(word.text, style: Styles.suitLGBold.copyWith(color: controller.colorMap[controller.viewMode]![ColorElement.tooltipText]!)),
                  Text('[protékt]', style: Styles.suitSMRegular.copyWith(color: controller.colorMap[controller.viewMode]![ColorElement.tooltipText]!.withOpacity(0.2),))
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(left: 6.s, bottom: 6.s),
                child: Icon(Icons.bookmark, color: controller.colorMap[controller.viewMode]![ColorElement.tooltipIcon]!, size: 20.s,)
              ),
              Padding(
                  padding: EdgeInsets.only(left: 6.s, bottom: 6.s),
                  child: Icon(Icons.volume_up, color: controller.colorMap[controller.viewMode]![ColorElement.tooltipIcon]!, size: 20.s,)
              ),
            ],
          ),
          const Spacer(),
          Text('1. 보호하다', style: Styles.suitSMRegular.copyWith(color: controller.colorMap[controller.viewMode]![ColorElement.tooltipText]!),),
          Text('2. 지키다', style: Styles.suitSMRegular.copyWith(color: controller.colorMap[controller.viewMode]![ColorElement.tooltipText]!),),
          Text('3. 방어', style: Styles.suitSMRegular.copyWith(color: controller.colorMap[controller.viewMode]![ColorElement.tooltipText]!),),
          const Spacer(),
          GestureDetector(
            onTap: () async => controller.goWordDetailView(word),
            child: Text('자세히 보기', style: Styles.suitSMRegular.copyWith(
                color: controller.colorMap[controller.viewMode]![ColorElement.tooltipText]!,
                decoration: TextDecoration.underline,),
            ),
          ),
        ],
      ),
    );
  }
}
