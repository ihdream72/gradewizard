
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/text_styles.dart';
import '../../../core/widget/common/common_bottom_sheet.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/model/subject.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/ui_size_config.dart';
import '/app/core/values/app_values.dart';
import '/app/core/widget/common/common_bottom_button.dart';
import '../../../core/utils/logger.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widget/common/common_title_bar.dart';
import '../controllers/add_subject_controller.dart';

class AddSubjectView extends BaseView<AddSubjectController> {

  const AddSubjectView({Key? key}) : super(key: key);

  @override
  Widget? appBar(BuildContext context) {

    return CTitleBar(
      title: controller.isAdded ? '과목 추가' : '과목 수정',
      titleColor: AppColors.white,
      backWidget: SizedBox(
        width: AppValues.appBarSize,
        height: AppValues.appBarSize,
        child: const Icon(Icons.arrow_back, color: AppColors.white,),
      ),
      onBack: () => controller.goBack(),
      color: AppColors.secondary,
      listRightActionWidget: [
        controller.isAdded ? Container() :
        GestureDetector(
          onTap: () {
            controller.deleteSubject();
            controller.goBack();
          },
          child: Container(
            width: AppValues.appBarSize,
            height: AppValues.appBarSize,
            alignment: Alignment.center,
            child: Text('삭제', style: Styles.suitLGBold.copyWith(color: AppColors.white))
          ),
        )
      ],
    );
  }



  @override
  Widget? bottomButton(BuildContext context) {

    return CBottomButton(
      title: controller.isAdded ? '추가 하기' : '수정 하기',
      onTap: () {
        controller.saveSubject();
        Get.back();
      },
      enable: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    UISizeConfig.init(context);

    return Obx(() => Container(
        width: Get.width,
        height: Get.height - Get.mediaQuery.padding.top - Get.mediaQuery.padding.bottom - AppValues.appBarSize,
        padding: EdgeInsets.all(8.s),
        child: Column(
          children:
          [
            SizedBox(height: 30.s,),
            name(),
            SizedBox(height: 50.s,),
            unit(),
            SizedBox(height: 50.s,),
            score(),
            SizedBox(height: 50.s,),
            grade(),
          ],
        )
    ));
  }

  Widget name() {

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.s),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text01),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                ),
            color: AppColors.blue02,
          ),
          child: Text('과목이름', style: Styles.suitMDBold.copyWith(color: AppColors.white)),
        ),
        Container(
          //height: 30.s,
          width: 400.s,
          padding: EdgeInsets.all(4.s),
          decoration: const BoxDecoration(
            // border: Border.all(color: AppColors.text01),
            border: Border(
              left: BorderSide(color: AppColors.text01),
              right: BorderSide(color: AppColors.text01),
              bottom: BorderSide(color: AppColors.text01),),
            // borderRadius: const BorderRadius.only(
            //     bottomRight: Radius.circular(8.0),
            //     bottomLeft: Radius.circular(8.0)),
            color: AppColors.white,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                item(
                  text: HomeController.subjectName[SubjectType.korean]!,
                  enable: controller.type == SubjectType.korean,
                  onTap: () {
                    controller.type = SubjectType.korean;
                  }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: HomeController.subjectName[SubjectType.english]!,
                    enable: controller.type == SubjectType.english,
                    onTap: () {
                      controller.type = SubjectType.english;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: HomeController.subjectName[SubjectType.mathematics]!,
                    enable: controller.type == SubjectType.mathematics,
                    onTap: () {
                      controller.type = SubjectType.mathematics;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: HomeController.subjectName[SubjectType.history]!,
                    enable: controller.type == SubjectType.history,
                    onTap: () {
                      controller.type = SubjectType.history;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: HomeController.subjectName[SubjectType.science]!,
                    enable: controller.type == SubjectType.science,
                    onTap: () {
                      controller.type = SubjectType.science;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: HomeController.subjectName[SubjectType.social]!,
                    enable: controller.type == SubjectType.social,
                    onTap: () {
                      controller.type = SubjectType.social;
                    }
                ),
              ],
            ),
          ),

        ),
      ],
    );
  }

  Widget item({String text = '', bool enable = false, Function()? onTap}) {

    return GestureDetector(
      onTap: () {
        if(onTap != null) {
          onTap();
        }
      },
      child: Container(
        width: 70.s,
        //height: 40.s,
        padding: EdgeInsets.all(8.s),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: enable ? AppColors.primary : AppColors.text01),
          borderRadius: BorderRadius.circular(8.s),
          color: enable ? AppColors.primary : AppColors.white
        ),
        child: Text(text, style: text.length > 3 ?
        Styles.suitSMMedium.copyWith(color: enable ? AppColors.white : AppColors.text01) :
        Styles.suitMDMedium.copyWith(color: enable ? AppColors.white : AppColors.text01),),
      ),
    );
  }

  Widget unit() {


    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.s),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text01),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: AppColors.blue02,
          ),
          child: Text('단위 수',style: Styles.suitMDBold.copyWith(color: AppColors.white)),
        ),
        Container(
          //height: 30.s,
          width: 400.s,
          padding: EdgeInsets.all(4.s),
          decoration: const BoxDecoration(
            // border: Border.all(color: AppColors.text01),
            border: Border(
              left: BorderSide(color: AppColors.text01),
              right: BorderSide(color: AppColors.text01),
              bottom: BorderSide(color: AppColors.text01),),
            // borderRadius: const BorderRadius.only(
            //     bottomRight: Radius.circular(8.0),
            //     bottomLeft: Radius.circular(8.0)),
            color: AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              item(
                  text: '1 단위',
                  enable: controller.unit == 1,
                  onTap: () {
                    controller.unit = 1;
                  }
              ),
              item(
                  text: '2 단위',
                  enable: controller.unit == 2,
                  onTap: () {
                    controller.unit = 2;
                  }
              ),
              item(
                  text: '3 단위',
                  enable: controller.unit == 3,
                  onTap: () {
                    controller.unit = 3;
                  }
              ),
              item(
                  text: '4 단위',
                  enable: controller.unit == 4,
                  onTap: () {
                    controller.unit = 4;
                  }
              ),
            ],
          ),

        ),
      ],
    );
  }

  Widget score() {


    return GestureDetector(
      onTap: () async {
        double? score = await CBottomSheet.score(score: 80.0);
        if(score != null) {
          if(score > 100) score = 100;
          controller.score = score;
        }
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(4.s),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.text01),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
              ),
              color: AppColors.blue02,
            ),
            child: Text('점수', style: Styles.suitMDBold.copyWith(color: AppColors.white)),
          ),
          Container(
            height: 30.s,
            width: 400.s,
            padding: EdgeInsets.all(4.s),
            decoration: const BoxDecoration(
              // border: Border.all(color: AppColors.text01),
              border: Border(
                left: BorderSide(color: AppColors.text01),
                right: BorderSide(color: AppColors.text01),
                bottom: BorderSide(color: AppColors.text01),),
              // borderRadius: const BorderRadius.only(
              //     bottomRight: Radius.circular(8.0),
              //     bottomLeft: Radius.circular(8.0)),
              color: AppColors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('점수: ', style: Styles.suitLGRegular.copyWith(color: AppColors.text02),),
                Text('${controller.score}', style: Styles.suitLGRegular.copyWith(color: AppColors.primary),),
              ],
            ),

          ),
        ],
      ),
    );
  }

  Widget rate() {


    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.s),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text01),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: AppColors.blue02,
          ),
          child: Text('상위 순위', style: Styles.suitMDBold.copyWith(color: AppColors.white)),
        ),
        Container(
          height: 30.s,
          width: 400.s,
          padding: EdgeInsets.all(4.s),
          decoration: const BoxDecoration(
            // border: Border.all(color: AppColors.text01),
            border: Border(
              left: BorderSide(color: AppColors.text01),
              right: BorderSide(color: AppColors.text01),
              bottom: BorderSide(color: AppColors.text01),),
            // borderRadius: const BorderRadius.only(
            //     bottomRight: Radius.circular(8.0),
            //     bottomLeft: Radius.circular(8.0)),
            color: AppColors.white,
          ),
          child: Row(
            children: [
              SizedBox(height: 6.s,),
              Text('상위 순위:', style: Styles.suitMDRegular.copyWith(color: AppColors.text02),),
            ],
          ),

        ),
      ],
    );
  }

  Widget grade() {


    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.s),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text01),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: AppColors.blue02,
          ),
          child: Text('등급', style: Styles.suitMDBold.copyWith(color: AppColors.white)),
        ),
        Container(
          //height: 30.s,
          width: 400.s,
          padding: EdgeInsets.all(4.s),
          decoration: const BoxDecoration(
            // border: Border.all(color: AppColors.text01),
            border: Border(
              left: BorderSide(color: AppColors.text01),
              right: BorderSide(color: AppColors.text01),
              bottom: BorderSide(color: AppColors.text01),),
            // borderRadius: const BorderRadius.only(
            //     bottomRight: Radius.circular(8.0),
            //     bottomLeft: Radius.circular(8.0)),
            color: AppColors.white,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                item(
                    text: '1 등급',
                    enable: controller.grade == 1,
                    onTap: () {
                      controller.grade = 1;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '2 등급',
                    enable: controller.grade == 2,
                    onTap: () {
                      controller.grade = 2;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '3 등급',
                    enable: controller.grade == 3,
                    onTap: () {
                      controller.grade = 3;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '4 등급',
                    enable: controller.grade == 4,
                    onTap: () {
                      controller.grade = 4;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '5 등급',
                    enable: controller.grade == 5,
                    onTap: () {
                      controller.grade = 5;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '6 등급',
                    enable: controller.grade == 6,
                    onTap: () {
                      controller.grade = 6;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '7 등급',
                    enable: controller.grade == 7,
                    onTap: () {
                      controller.grade = 7;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '8 등급',
                    enable: controller.grade == 8,
                    onTap: () {
                      controller.grade = 8;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '9 등급',
                    enable: controller.grade == 9,
                    onTap: () {
                      controller.grade = 9;
                    }
                ),
                SizedBox(width: 8.s,),
                item(
                    text: '10 등급',
                    enable: controller.grade == 10,
                    onTap: () {
                      controller.grade = 10;
                    }
                ),
              ],
            ),
          ),

        ),
      ],
    );
  }


}
