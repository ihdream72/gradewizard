
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/preference_manager.dart';
import '../../../core/values/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../model/subject.dart';




class HomeController extends BaseController {

  /// Input Argument  ==>
  // 없음
  /// <== Input Argument

  final RxList<Subject> subjectList = <Subject>[].obs;

  final RxDouble _averageScore = 0.0.obs;
  double get averageScore => _averageScore.value;
  set averageScore(s) => _averageScore(s);

  final RxDouble _averageGrade = 0.0.obs;
  double get averageGrade => _averageGrade.value;
  set averageGrade(s) => _averageGrade(s);

  static const Map<SubjectType, String> subjectName = {
    SubjectType.korean: '국어',
    SubjectType.english: '영어',
    SubjectType.mathematics: '수학',
    SubjectType.history: '한국사',
    SubjectType.science: '과학',
    SubjectType.social: '통합 사회',
  };

  @override
  void onInit() async {
    super.onInit();

    await loadSubject();
  }

  Future<void> loadSubject() async {

    List<String> list = <String>[];

    list = await PreferenceManager().getStringList('subjectList');

    subjectList.clear();

    for(String str in list) {
      Subject subject = Subject.fromString(str);
      subjectList.add(subject);
    }

    calculateAverage();
  }

  void calculateAverage() {

    averageScore = 0.0;
    averageGrade = 0.0;

    int unitCount = 0;

    for(Subject subject in subjectList) {
      averageScore += subject.score!;
      unitCount += subject.unit!;
      averageGrade += (subject.grade! * subject.unit!).toDouble();
    }

    averageScore = averageScore/subjectList.length;
    averageGrade = averageGrade/unitCount;

  }

  Future<void> saveSubject() async {
    List<String> list = <String>[];

    for(Subject subject in subjectList) {
      list.add(subject.toString());
    }

    await PreferenceManager().setStringList('subjectList', list);
    calculateAverage();
  }

  Future<void> goAddSubject() async {
    await Get.toNamed(Routes.addSubject);
    await saveSubject();
    subjectList.refresh();
  }

  Future<void> goEditSubject(int index) async {
    await Get.toNamed(Routes.addSubject, arguments: {'index':index,} );
    await saveSubject();
    subjectList.refresh();
  }

  void onShare() {
    //Get.toNamed(Routes.addSubject);

    Fluttertoast.showToast(
        msg: '아직 지원되지 않습니다.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.dim.withOpacity(0.4),
        textColor: AppColors.white,
        fontSize: 20);


  }

}
