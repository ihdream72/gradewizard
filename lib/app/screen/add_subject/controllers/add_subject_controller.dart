
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_routes.dart';

class AddSubjectController extends BaseController {

  /// Input Argument  ==>
  // 없음
  /// <== Input Argument


  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<bool> goBack() async {
    unFocusAll();

    Get.back();

    return Future.value(false);
  }

  void goAddSubject() {
    Get.toNamed(Routes.addSubject);
  }

}
