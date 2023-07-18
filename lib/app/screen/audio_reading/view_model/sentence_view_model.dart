

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chunk_view_model.dart';

/// 문장의 ViewModel
class SentenceViewModel {
  final int index;      //
  final int startTime;  // milli-second
  final int endTime;    // milli-second
  final List<ChunkViewModel> chunks;  //
  final RxBool isActivate = false.obs;  // 현재 Play 되고 있는 지점 인지 아닌 지를 알려 준는 Rx 데이타
  late GlobalKey key; // List 내에서 문장의 RenderBox 를 찾기 위한 Key
  Offset? offset; // 스크롤 을 위한 문장의 Scroll offset

  SentenceViewModel({required this.index, required this.startTime, required this.endTime, required this.chunks,}) {
    key = GlobalKey();
  }
}