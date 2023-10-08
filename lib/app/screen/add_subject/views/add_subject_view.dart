
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/text_styles.dart';
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
      title: '과목 추가',
      backWidget: SizedBox(
        width: AppValues.appBarSize,
        height: AppValues.appBarSize,
        child: const Icon(Icons.arrow_back, color: AppColors.white,),
      ),
      onBack: () => controller.goBack(),
      color: AppColors.secondary,
    );
  }



  @override
  Widget? bottomButton(BuildContext context) {

    return CBottomButton(
      title: '저장 하기',
      onTap: () {
        Log.d('저장 하기');
        Get.back();
      },
      enable: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    UISizeConfig.init(context);

    return Container(
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
          rate(),
          SizedBox(height: 50.s,),
          grade(),
        ],
      )
    );
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
              Text('과목:', style: Styles.suitMDRegular.copyWith(color: AppColors.text02),),
            ],
          ),

        ),
      ],
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
              Text('단위 수:', style: Styles.suitMDRegular.copyWith(color: AppColors.text02),),
            ],
          ),

        ),
      ],
    );
  }

  Widget score() {


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
            children: [
              SizedBox(height: 6.s,),
              Text('점수:', style: Styles.suitMDRegular.copyWith(color: AppColors.text02),),
            ],
          ),

        ),
      ],
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
              Text('등급:', style: Styles.suitMDRegular.copyWith(color: AppColors.text02),),
            ],
          ),

        ),
      ],
    );
  }

}
