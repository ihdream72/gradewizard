import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../values/app_colors.dart';
import '../../values/app_values.dart';
import '../../values/text_styles.dart';

class CBottomButton extends StatelessWidget {

  final String? title;
  final Function()? onTap;
  final bool enable;
  final Color? background;

  const CBottomButton({
    super.key,
    this.title,
    this.onTap,
    this.enable = false,
    this.background,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        if(onTap != null && enable) onTap!();
      },
      child: Container(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
        height: AppValues.bottomButtonSize + Get.mediaQuery.padding.bottom,
        width: Get.width,
        color: enable ? background ?? AppColors.secondary : AppColors.text10,
        alignment: Alignment.center,
        child: Text(title ?? '', style: enable ? Styles.suitLGBold.copyWith(color: AppColors.white) : Styles.suitLGMedium.copyWith(color: AppColors.white),),
      ),
    );
  }

}