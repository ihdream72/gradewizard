
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:audioscript/app/core/values/app_values.dart';
import 'package:audioscript/app/core/widget/common/common_bottom_button.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/ui_size_config.dart';
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
      title: 'audioscript',
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

    return SizedBox(
      width: Get.width,
      height: Get.height - Get.mediaQuery.padding.top - Get.mediaQuery.padding.bottom - AppValues.appBarSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('audioscript', style: Styles.suitXXLBold.copyWith(color: AppColors.primary),),
          SizedBox(height: 20.s,),
          GestureDetector(
            onTap: () => controller.goAudioReading(),
            child: Container(
              padding: EdgeInsets.all(8.s),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.text01),
                borderRadius: BorderRadius.circular(8.s),
                color: AppColors.white,
              ),
              child: Text('BTS UN 연설 듣기', style: Styles.suitLGBold.copyWith(color: AppColors.text01)),
            ),
          ),
          SizedBox(height: 10.s,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                  width: 150,
                  child: TextField()
              ),
              Text('유승이 전교 3등', style: Styles.suitXXLBold.copyWith(color: Colors.black),),
            ],
          )

        ],
      ),
    );
  }
}
