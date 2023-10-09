import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradewizard/app/core/utils/ui_size_config.dart';
import '../../values/app_colors.dart';
import '../../values/app_values.dart';
import '../../values/text_styles.dart';

class CBottomSheet {

  static final RxBool _enableOneButton = false.obs;
  static bool get enableOneButton => _enableOneButton.value;
  static set enableOneButton(i) => _enableOneButton(i);

  static final RxBool _enableLeftButton = false.obs;
  static bool get enableLeftButton => _enableLeftButton.value;
  static set enableLeftButton(i) => _enableLeftButton(i);

  static final RxBool _enableRightButton = false.obs;
  static bool get enableRightButton => _enableRightButton.value;
  static set enableRightButton(i) => _enableRightButton(i);

  static final RxInt _searchSelectedIndex = (-1).obs;
  static int get searchSelectedIndex => _searchSelectedIndex.value;
  static set searchSelectedIndex(i) => _searchSelectedIndex(i);

  static final RxList<int> selectList = RxList<int>.empty();

  static Map<String,dynamic> result = <String,dynamic>{};

  // ignore: long-parameter-list
  static Future<T?> showOneButton<T>({
    required Widget child,
    required String text,
    Color bgColor = AppColors.primary,
    Color textColor = AppColors.white,
    bool enable = true,
    String title = '',
    Function(dynamic)? onTap,
    Function(dynamic)? onClose,
    bool isScrollControlled = false,
    bool isCancellable = true,
    double topPadding = 32,
    double bottomPadding = 44,
  }) async {

    enableOneButton = enable;

    Widget body = Obx(() => WillPopScope(
      onWillPop: () {

        if(isCancellable) {
          Get.back(result: null);
        }

        return Future.value(false);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bodyBottomSheet(title: title, child: child, topPadding: topPadding.s, bottomPadding: bottomPadding.s),
          oneButton<T>(text: text, bgColor: bgColor, textColor: textColor, onTap: onTap,),
        ],
      ),
    ));

    T? result = await bottomSheet(body: body, isScrollControlled: isScrollControlled, isCancellable: isCancellable, isSafeArea: false);

    if (onClose != null) onClose(result);

    return result;
  }

  // ignore: long-parameter-list
  static Future<T?> showTwoButton<T>({
    required Widget child,
    required String left,
    required String right,
    Color bgLeft = AppColors.white,
    Color bgRight = AppColors.primary,
    Color? colorLeft,
    Color? colorRight,
    bool enableLeft = true,
    bool enableRight = true,
    String title = '',
    Function(dynamic)? onLeft,
    Function(dynamic)? onRight,
    Function(dynamic)? onClose,
    bool isScrollControlled = false,
    bool isCancellable = true,
    double topPadding = 32,
    double bottomPadding = 44,
  }) async {

    enableLeftButton = enableLeft;
    enableRightButton = enableRight;

    Widget body = Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bodyBottomSheet(title: title, child: child, topPadding: topPadding.s, bottomPadding: bottomPadding.s),
        twoButton<T>(left: left, right: right, bgLeft: bgLeft, bgRight: bgRight, colorLeft: colorLeft, colorRight: colorRight, onLeft: onLeft, onRight: onRight),
      ],
    ));

    T? result = await bottomSheet(body: body, isScrollControlled: isScrollControlled, isCancellable: isCancellable,);

    if (onClose != null) onClose(result);

    return result;
  }

  static Widget bodyBottomSheet({required String title, required Widget child, required double topPadding, required double bottomPadding,}) {

    return Padding(
      padding: EdgeInsets.only(top: 12.s, left: 24.s, right: 24.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: SvgPicture.asset('assets/svg/bottomsheet_indicator.svg')),
          SizedBox(height: topPadding),
          title.isEmpty ? Container() :
          SizedBox(
            width: 327.s,
            height: 32.s,
            child: Text(title, style: Styles.suitXLBold.copyWith(color: AppColors.text01),),
          ),
          title.isEmpty ? Container() : SizedBox(height: 16.s),
          child,
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  static Widget oneButton<T>({required String text, required Color bgColor, required Color textColor, Function(dynamic)? onTap}) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              if(onTap != null && enableOneButton) {
                onTap(result);
              }
            },
            child: Container(
              height: AppValues.bottomButtonSize + Get.mediaQuery.padding.bottom,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
              decoration: BoxDecoration(
                color: enableOneButton ?
                bgColor
                    :
                AppColors.text10,
                // border: Border.all(
                //   color:AppColors.text10,
                // ),
              ),
              child: Text(text, style: Styles.suitLGMedium.copyWith(color: enableOneButton ? textColor : AppColors.white),),
            ),
          ),
        )
      ],
    );
  }

  static Widget twoButton<T>({required String left, required String right, required Color bgLeft, required Color bgRight, Color? colorLeft, Color? colorRight, Function(dynamic)? onLeft, Function(dynamic)? onRight}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              if(onLeft != null && enableLeftButton) {
                onLeft(result);
                //Get.back(result: { '111':'222' });
              }
            },
            child: Container(
              height: AppValues.bottomButtonSize,
              width: Get.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: enableLeftButton ? bgLeft : AppColors.text10,
                border: Border.all(
                  color:AppColors.text10,
                ),
              ),
              child: Text(left, style: Styles.suitLGMedium.copyWith(color: colorLeft ?? (enableLeftButton ? AppColors.text03 : AppColors.white)),),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              if(onRight != null && enableRightButton) {
                onRight(result);
              }
            },
            child: Container(
              height: AppValues.bottomButtonSize,
              width: Get.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: enableRightButton ? bgRight : AppColors.text10,
                border: Border.all(
                  color: enableRightButton ? bgRight : AppColors.text10,
                ),
              ),
              child: Text(right, style: Styles.suitLGMedium.copyWith(color: colorRight ?? /*enableRightButton.value ? AppColors.white : AppColors.primary*/AppColors.white),),
            ),
          ),
        )
      ],
    );
  }

  static Future<T?> bottomSheet<T>({required Widget body, required bool isScrollControlled, required bool isCancellable, bool isSafeArea = true}) async {

    return Get.bottomSheet<T>(
      isSafeArea ? SafeArea(child: body) : body,
      //persistent: false,
      //ignoreSafeArea: false,
      isScrollControlled: isScrollControlled,
      enableDrag: isCancellable,
      isDismissible: isCancellable,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );

  }

  static Future<double?> score({required double score}) async {

    List<int> weightList = [for (var i = 0; i <= 100; i++) i];
    List<int> weightDecimalList = [for (var i = 0; i < 10; i++) i];

    String weightString = score.toString();
    int weightInteger = int.parse(weightString.split('.')[0]);
    int weightDecimal = int.parse(weightString.split('.')[1]);


    double? result = await CBottomSheet.showOneButton<double>(child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.s)),
            color: const Color(0x0A000000),
          ),
          width: 323.s,
          height: 32.s,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 70.s,
              height: 174.s,
              child: CupertinoPicker(
                  itemExtent: 32.s,
                  selectionOverlay: null,
                  scrollController: FixedExtentScrollController(initialItem: weightInteger),
                  offAxisFraction: -0.3,
                  onSelectedItemChanged: (int value) {
                    weightInteger = value;
                    // if(onChange != null) {
                    //   onChange(double.parse('$weightInteger.$weightDecimal'));
                    // }
                  },
                  children: [
                    ...weightList.map((e) => Text(
                      e.toString(),
                      style: Styles.suitMDMedium
                          .copyWith(color: Colors.black, fontSize: 26),
                    ))
                  ]
              ),
            ),
            SizedBox(width: 5.s,),
            Text('.', style: Styles.suitMDMedium.copyWith(color: Colors.black, fontSize: 26),),
            SizedBox(width: 5.s,),
            SizedBox(
              width: 70.s,
              height: 174.s,
              child: CupertinoPicker(
                  itemExtent: 32.s,
                  selectionOverlay: null,
                  offAxisFraction: 0.3,
                  scrollController: FixedExtentScrollController(initialItem: weightDecimal),
                  onSelectedItemChanged: (int value) {
                    weightDecimal = value;
                    // if(onChange != null) {
                    //   onChange(double.parse('$weightInteger.$weightDecimal'));
                    // }
                  },
                  children: [
                    ...weightDecimalList.map((e) => Text(
                      e.toString(),
                      style: Styles.suitMDMedium
                          .copyWith(color: Colors.black, fontSize: 26),
                    ))
                  ]
              ),
            ),
            SizedBox(width: 15.s,),
            Text('점', style: Styles.suitMDMedium.copyWith(color: Colors.black, fontSize: 26),),
          ],
        ),
      ],
    ), text: '완료', bgColor: AppColors.primary, textColor: AppColors.white,
        topPadding: 16, bottomPadding: 16,
        onTap: (val){
          Get.back(result: double.parse('$weightInteger.$weightDecimal'));
        });


    return result;
  }


  static Future<DateTime?> datePicker({required DateTime initDate, String format = 'yyyy년-MM월-dd일', DateTime? minDate }) async {

    DateTime tempPickedDate = initDate;

    DateTime? result = await CBottomSheet.showOneButton<DateTime>(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.s)),
                color: const Color(0x0A000000),
              ),
              width: 323.s,
              height: 32.s,
            ),
            Container(
              child: DateTimePickerWidget(
                minDateTime: minDate ?? DateTime.parse('${DateTime.now().year-30}-01-01'),
                maxDateTime: DateTime.now(),
                initDateTime: initDate,
                dateFormat: format,
                pickerTheme: DateTimePickerTheme(
                  backgroundColor: AppColors.transparent,
                  // cancelTextStyle: TextStyle(color: Colors.white),
                  // confirmTextStyle: TextStyle(color: Colors.black),
                  itemTextStyle: Styles.suitMDMedium.copyWith(color: Colors.black, fontSize: 22),
                  //pickerHeight: UI.ratioY(216, context),
                  titleHeight: 0,
                  itemHeight: 32.s,
                  selectionOverlay: Container(color: AppColors.transparent),
                ),
                onChange: (dateTime, selectedIndex) {
                  tempPickedDate = dateTime;
                },
              ),
            )
          ],
        ),
        text: '완료', bgColor: AppColors.primary, textColor: AppColors.white,
        topPadding: 16, bottomPadding: 16,
        onTap: (val) {
          Get.back(result: tempPickedDate);
        });


    return result;
  }
}
