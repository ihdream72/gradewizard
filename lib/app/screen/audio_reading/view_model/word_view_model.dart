
import 'package:get/get.dart';

/// 단어 의 ViewModel
class WordViewModel {
  final String text;    // 단어
  final RxBool isSelected = false.obs;  // 사용자 가 터치로 선택 했는지 여부를 보여 준다.
  int? selectedSentenceIndex;
  int? selectedChunkIndex;

  WordViewModel({required this.text,});
}