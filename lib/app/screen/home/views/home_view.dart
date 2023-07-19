
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
              color: AppColors.blue02,
            ),
            child: Text('과목', style: Styles.suitMDBold.copyWith(color: AppColors.white),),
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
                subject(null),
                subject('영어'),
                subject('수학'),
                subject('과학'),
                subject('국사'),
                subject('정보'),
                subject('사회'),
              ],
            ),
          ),


        ],
      ),
    );
  }

  Widget subject(String? name) {

    return name == null ?
    GestureDetector(
      onTap: () => controller.goAddSubject() ,
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
    Container(
      width: 60.s,
      height: 50.s,
      margin: EdgeInsets.only( right: 10.s),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blue04),
        color: AppColors.blue04,
      ),
      child: Text(name, style: Styles.suitMDBold.copyWith(color: AppColors.white),),
    );
  }
}
