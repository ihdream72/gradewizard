
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/ui_size_config.dart';
import '/app/core/values/app_values.dart';
import '/app/core/widget/common/common_bottom_button.dart';
import '../../../core/utils/logger.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/common/common_title_bar.dart';
import '../controllers/home_controller.dart';

class HomeView extends BaseView<HomeController> {

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget? appBar(BuildContext context) {

    return CTitleBar(
      title: '등급 계산기',
      onBack: () => controller.goBack(),
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

    return Container(
      width: Get.width,
      height: Get.height - Get.mediaQuery.padding.top - Get.mediaQuery.padding.bottom - AppValues.appBarSize,
      padding: EdgeInsets.all(8.s),
      child: Column(
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
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0)),
              color: AppColors.white,
            ),
            child: Text('과목', style: Styles.suitMDBold.copyWith(color: AppColors.text01),),
          ),
          Container(
            height: 80.s,
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
            child: ListView(
              primary: true,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(8.s),
              children: [
                Container(
                  width: 50.s,
                  height: 50.s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.text01),
                    color: AppColors.white,
                  ),
                  child: Text('국어', style: Styles.suitMDBold.copyWith(color: AppColors.text01),),
                ),
                SizedBox(width: 10.s,),
                Container(
                  width: 50.s,
                  height: 50.s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.text01),
                    color: AppColors.white,
                  ),
                  child: Text('영어', style: Styles.suitMDBold.copyWith(color: AppColors.text01),),
                ),
                SizedBox(width: 10.s,),
                Container(
                  width: 50.s,
                  height: 50.s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.text01),
                    color: AppColors.white,
                  ),
                  child: Text('수학', style: Styles.suitMDBold.copyWith(color: AppColors.text01),),
                ),
                SizedBox(width: 10.s,),
                Container(
                  width: 50.s,
                  height: 50.s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.text01),
                    color: AppColors.white,
                  ),
                  child: Text('과학', style: Styles.suitMDBold.copyWith(color: AppColors.text01),),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
