import 'package:get/get.dart';

import '../controllers/audio_reading_controller.dart';


class AudioReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioReadingController>(() => AudioReadingController(),
      fenix: true
    );
  }
}
