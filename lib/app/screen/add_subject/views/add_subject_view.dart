
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      child: Container()
    );
  }

}
