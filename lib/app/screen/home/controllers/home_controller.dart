
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_routes.dart';

class HomeController extends BaseController {

  /// Input Argument  ==>
  // 없음
  /// <== Input Argument


  @override
  void onInit() {
    super.onInit();
  }

  void goAudioReading() {
    Get.toNamed(Routes.audioReading);
  }

}
