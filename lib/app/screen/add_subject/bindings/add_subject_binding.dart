import 'package:get/get.dart';

import '../controllers/add_subject_controller.dart';


class AddSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSubjectController>(() => AddSubjectController(),
      fenix: true
    );
  }
}
