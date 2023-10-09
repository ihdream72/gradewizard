import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/add_subject_controller.dart';


class AddSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSubjectController>(() => AddSubjectController(),
      fenix: true
    );
    Get.lazyPut<HomeController>(() => HomeController(),
      fenix: true
    );
  }
}
