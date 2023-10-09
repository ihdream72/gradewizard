
import 'package:get/get.dart';
import 'package:gradewizard/app/screen/home/controllers/home_controller.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_routes.dart';
import '../../home/model/subject.dart';

class AddSubjectController extends BaseController {



  /// Input Argument  ==>
  int index = -1;
  /// <== Input Argument


  final HomeController homeController = Get.find();
  late Subject subject;

  bool get isAdded => index == -1;

  final Rx<SubjectType> _type = Rx<SubjectType>(SubjectType.korean);
  SubjectType get type => _type.value;
  set type(state) => _type(state);

  final RxInt _unit = 1.obs;
  int get unit => _unit.value;
  set unit(state) => _unit(state);

  final RxInt _grade = 1.obs;
  int get grade => _grade.value;
  set grade(state) => _grade(state);

  final RxDouble _score = 80.0.obs;
  double get score => _score.value;
  set score(state) => _score(state);

  @override
  void onInit() {
    super.onInit();

    index = Get.arguments?['index'] ?? -1;

    if(!isAdded) {
      subject = homeController.subjectList[index];

      type = subject.type;
      unit = subject.unit;
      grade = subject.grade;
      score = subject.score;
    } else {
      subject = Subject();
    }
  }

  @override
  Future<bool> goBack() async {
    unFocusAll();

    Get.back();

    return Future.value(false);
  }

  void saveSubject() {

    subject.type = type;
    subject.unit = unit;
    subject.grade = grade;
    subject.score = score;

    if(isAdded) {
      homeController.subjectList.add(subject);
    } else {

    }

  }

  void deleteSubject() {
    if(!isAdded) {
      homeController.subjectList.remove(subject);
    }
  }
}
