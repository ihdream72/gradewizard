
import 'package:flutter/widgets.dart';

/// ## 디자인 작업이 된 기준 해상도 의 비율에 맞도록 Device 의 해상도 사이즈 를 조절 한다.
/// 즉 화면이 최대한 Design 된 모습과 일치 하도록 하기 위해 사용 되는 Class
///
class UISizeConfig {
  static final UISizeConfig _instance = UISizeConfig._();
  UISizeConfig._();

  factory UISizeConfig() => _instance;

  // iPhone6 Resolution
  static const double designScreenWidth = 375;
  static const double designScreenHeight = 667;

  static late double screenForDesignHorizontal;
  static late double screenForDesignVertical;
  static late double screenForDesign = 0.0;

  static void init(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    screenForDesignHorizontal = _screenWidth / designScreenWidth;
    screenForDesignVertical = _screenHeight / designScreenHeight;

    screenForDesign = screenForDesignHorizontal;

  }

  static double size(double size, {bool isTruncate = true}) {

    //return size;

    if ((size * screenForDesign) < 1.0 && size >= 1.0) return size;

    if (isTruncate) return (size * screenForDesign).truncateToDouble();

    return (size * screenForDesign);
  }
}

/// double type 에 extension 으로 이용
extension UISizeDouble on double {
  double get s {
    return UISizeConfig.size(this);
  }

}

/// int type 에 extension 으로 이용
extension UISizeInt on int {
  double get s {
    return UISizeConfig.size(toDouble());
  }
}
