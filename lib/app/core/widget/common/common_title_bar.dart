import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/app/core/values/app_values.dart';

import '../../utils/ui_size_config.dart';
import '../../values/app_colors.dart';
import '../../values/text_styles.dart';

class CTitleBar extends StatelessWidget {

  final String title;
  final Color titleColor;
  final Widget? titleWidget;
  final Function()? onBack;
  final Widget? backWidget;
  final List<Widget>? listRightActionWidget;
  final Color color;
  final SystemUiOverlayStyle? mode;

  const CTitleBar({
    super.key,
    this.title = '',
    this.titleColor = AppColors.text01,
    this.titleWidget,
    this.onBack,
    this.backWidget,
    this.listRightActionWidget,
    this.color = AppColors.background,
    this.mode = SystemUiOverlayStyle.dark,
  });


  @override
  Widget build(BuildContext context) {

    var barHeight = AppValues.appBarSize + Get.mediaQuery.padding.top;
    var barContentsHeight = barHeight - Get.mediaQuery.padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: mode ?? SystemUiOverlayStyle.dark,
      child: Container(
        color: color,
        padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
        height: barHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            onBack == null ? SizedBox(
              width: barContentsHeight,
              height: barContentsHeight,) :
            GestureDetector(
              onTap: () {
                onBack!();
              },
              child: SizedBox(
                width: barContentsHeight,
                height: barContentsHeight,
                child: backWidget
              ),
            ),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width - AppValues.appBarSize*2 - 64.s,
              height: barContentsHeight,
              padding: EdgeInsets.only(left: 16.s, right: 16.s),
              alignment: Alignment.center,
              child: titleWidget ?? Text(
                title,
                style: Styles.suitXLBold.copyWith(color: titleColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: barContentsHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: listRightActionWidget ?? [Container( width: AppValues.appBarSize)],
              ),
            ),
          ],
        ),
      ),
    );
  }

}