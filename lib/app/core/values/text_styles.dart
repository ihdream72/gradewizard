
import 'package:flutter/material.dart';
import '/app/core/values/app_colors.dart';

class Styles {
  static String mainFontRegular = 'SUIT Regular';
  static String mainFontMedium = 'SUIT Medium';
  static String mainFontBold = 'SUIT Bold';
  static FontWeight mainWeightRegular = FontWeight.w400;
  static FontWeight mainWeightMedium = FontWeight.w500;
  static FontWeight mainWeightBold = FontWeight.w700;

  static TextStyle suitXXLRegular = TextStyle(
    color: AppColors.text01,
    fontFamily: mainFontRegular,
    fontWeight: mainWeightRegular,
    fontStyle: FontStyle.normal,
    fontSize: 24,
    height: centerHeight, //38/24.s,
  );
  static TextStyle suitXXLMedium = suitXXLRegular.copyWith(fontFamily: mainFontMedium, fontWeight: mainWeightMedium);
  static TextStyle suitXXLBold = suitXXLRegular.copyWith(fontFamily: mainFontBold, fontWeight: mainWeightBold);

  static TextStyle suitXLRegular = suitXXLRegular.copyWith(fontSize: 20, height: centerHeight); //height: 32/20.s);
  static TextStyle suitXLMedium = suitXLRegular.copyWith(fontFamily: mainFontMedium, fontWeight: mainWeightMedium);
  static TextStyle suitXLBold = suitXLRegular.copyWith(fontFamily: mainFontBold, fontWeight: mainWeightBold);

  static TextStyle suitLGRegular = suitXXLRegular.copyWith(fontSize: 18, height: centerHeight); //height: 28/18.s);
  static TextStyle suitLGMedium = suitLGRegular.copyWith(fontFamily: mainFontMedium, fontWeight: mainWeightMedium);
  static TextStyle suitLGBold = suitLGRegular.copyWith(fontFamily: mainFontBold, fontWeight: mainWeightBold);

  static TextStyle suitMDRegular = suitXXLRegular.copyWith(fontSize: 16, height: centerHeight); //height: 26/16.s);
  static TextStyle suitMDMedium = suitMDRegular.copyWith(fontFamily: mainFontMedium, fontWeight: mainWeightMedium);
  static TextStyle suitMDBold = suitMDRegular.copyWith(fontFamily: mainFontBold, fontWeight: mainWeightBold);

  static TextStyle suitSMRegular = suitXXLRegular.copyWith(fontSize: 14, height: centerHeight); //height: 22/14.s);
  static TextStyle suitSMMedium = suitSMRegular.copyWith(fontFamily: mainFontMedium, fontWeight: mainWeightMedium);
  static TextStyle suitSMBold = suitSMRegular.copyWith(fontFamily: mainFontBold, fontWeight: mainWeightBold);

  static TextStyle suitXSRegular = suitXXLRegular.copyWith(fontSize: 13, height: centerHeight); //height: 20/13.s);
  static TextStyle suitXSMedium = suitXSRegular.copyWith(fontFamily: mainFontMedium, fontWeight: mainWeightMedium);
  static TextStyle suitXSBold = suitXSRegular.copyWith(fontFamily: mainFontBold, fontWeight: mainWeightBold);

  static TextStyle suitXXSRegular = suitXXLRegular.copyWith(fontSize: 12, height: centerHeight); //height: 18/12.s);
  static TextStyle suitXXSMedium = suitXXSRegular.copyWith(fontFamily: mainFontMedium, fontWeight: mainWeightMedium);
  static TextStyle suitXXSBold = suitXXSRegular.copyWith(fontFamily: mainFontBold, fontWeight: mainWeightBold);

  static double centerHeight = 1.3;

}
