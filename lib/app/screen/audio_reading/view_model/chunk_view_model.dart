
import 'package:get/get.dart';

import 'word_view_model.dart';

/// Chunk 의 ViewModel
class ChunkViewModel {
  final String text;    //
  final int startTime;  // milli-second
  final int endTime;    // milli-second
  final int index;      //
  final List<WordViewModel> words;  //
  final RxBool isActivate = false.obs;  // 현재 Play 되고 있는 지점 인지 아닌 지를 알려 준는 Rx 데이타

  ChunkViewModel({required this.text, required this.startTime, required this.endTime, required this.index, required this.words});
}