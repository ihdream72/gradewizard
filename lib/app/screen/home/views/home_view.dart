
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/app/core/utils/ui_size_config.dart';
import '/app/core/values/app_values.dart';
import '/app/core/widget/common/common_bottom_button.dart';
import '../../../core/base/base_view.dart';
import '../../../core/utils/logger.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/common/common_title_bar.dart';
import '../controllers/home_controller.dart';

class HomeView extends BaseView<HomeController> {

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget? appBar(BuildContext context) {

    return const CTitleBar(
      title: '등급 계산기',
      titleColor: AppColors.white,
      color: AppColors.secondary,
    );
  }

  @override
  Widget? bottomButton(BuildContext context) {

    return CBottomButton(
      title: '종료 하기',
      onTap: () {
        Log.d('종료 하기');
        SystemNavigator.pop();
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            subjectList(),
            SizedBox(height: 80.s,),
            summarizeGrade(),
            SizedBox(height: 80.s,),
            shareGrade(),
            SizedBox(height: 80.s,),
          ],
        )
    ));
  }

  Widget subjectList() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20.s,),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.s),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text01),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),

            color: AppColors.blue02,
          ),
          child: Text('과목 - ${controller.subjectList.length}개', style: Styles.suitMDBold.copyWith(color: AppColors.white),),
        ),
        Container(
          height: 80.s,
          padding: EdgeInsets.all(4.s),
          decoration: const BoxDecoration(
            // border: Border.all(color: AppColors.text01),
            border: Border(
              left: BorderSide(color: AppColors.text04),
              right: BorderSide(color: AppColors.text01),
              bottom: BorderSide(color: AppColors.text01),),
            // borderRadius: const BorderRadius.only(
            //     bottomRight: Radius.circular(8.0),
            //     bottomLeft: Radius.circular(8.0)),
            color: AppColors.white,
          ),
          child: ListView.builder(
            primary: true,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8.s),
            itemCount: controller.subjectList.length+1,
            itemBuilder: (context, index) {

              return subject(index);
            },
          ),
        ),
      ],
    );
  }

  Widget subject(int index) {

    return index == 0 ?
    GestureDetector(
      onTap: () => controller.goAddSubject(),
      child: Container(
          width: 60.s,
          height: 50.s,
          margin: EdgeInsets.only( right: 10.s),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.blue04),
            color: AppColors.blue04,
          ),
          child: const Icon(Icons.add, color: AppColors.white,),
        ),
    ) :
    GestureDetector(
      onTap: () => controller.goEditSubject(index - 1),
      child: Container(
        width: 60.s,
        height: 50.s,
        margin: EdgeInsets.only( right: 10.s),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.blue04),
          color: AppColors.blue04,
        ),
        child: Obx(() => Text(HomeController.subjectName[controller.subjectList[index-1].type]!, style: Styles.suitMDBold.copyWith(color: AppColors.white),)),
      ),
    );
  }

  Widget summarizeGrade() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.s),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text01),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
            color: AppColors.blue02,
          ),
          child: Text('나의 성적', style: Styles.suitMDBold.copyWith(color: AppColors.white),),
        ),
        Container(
          alignment: Alignment.center,
          height: 85.s,
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
          child: SizedBox(
            height: 100.s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textItem('평균 점수', controller.averageScore ),
                SizedBox(width: 20.s,),
                textItem('평균 등급', controller.averageGrade),
              ],
            ),

          ),
        ),
      ],
    );
  }

  Widget textItem(String header, double value) {

    return Row(
      children: [
        Text('$header : ', style: Styles.suitLGBold.copyWith(color: AppColors.text01),),
        Text('$value', style: Styles.suitLGBold.copyWith(color: AppColors.red01),),
      ],
    );
  }

  Widget shareGrade() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.s),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text01),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
            color: AppColors.blue02,
          ),
          child: Text('공유 하기', style: Styles.suitMDBold.copyWith(color: AppColors.white),),
        ),
        Container(
          height: 100.s,
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
          child: Column(
            children: [
              SizedBox(height: 6.s,),
              Text('나의 성적을 친구들과 공유하여\n 자신의 위치를 알아봅시다!', style: Styles.suitMDRegular.copyWith(color: AppColors.text02),),
              SizedBox(height: 10.s,),
              GestureDetector(
                onTap: () => controller.onShare(),
                child: Container(
                  width: 100.s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.text01),
                    borderRadius: BorderRadius.circular(40.s),
                    color: AppColors.white
                  ),
                  padding: EdgeInsets.all(4.s),
                  child: Text('공유하기', style: Styles.suitMDRegular.copyWith(color: AppColors.text01))
                ),
              )
            ],
          ),

        ),
      ],
    );
  }


}

