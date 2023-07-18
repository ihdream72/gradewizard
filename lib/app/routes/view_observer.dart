import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/logger.dart';
import 'app_routes.dart';

/// # 네비게이션 옵저버
/// > Single Tone
///
/// 어플리케이션 을 사용 하면서 화면 변경이 있을때([Navigator]작동시) 마다 [NavigatorObserver]를
/// 통해 페이지 변화를 감지 한다. Get 의 라우팅 관리 만 으로는 부족한 부분을 채우기 위해 해당 클래스 를
/// 사용 한다.
///
/// ---
/// 다음은 GetX 의 내비게이션 기능 사용시 어떻게 행동 하는 지를 설명 한다.
/// - 일반적 인 [Get.toNamed]실행시, [didPush]가 호출 되며, 첫 인자는 목적 라우트 에 대한 정보,
/// 두번째 인자는 직전 라우트 정보를 가진다. 첫 페이지 인 경우, 두번째 인자는 [null]값으로 전달 된다.
/// - 바텀 시트 가 생성([didPush])되거나 닫히는([didPop]) 과정 에서는 각 콜백 에서 첫번째 인자
/// (목적 라우트)가 [null]로 들어 온다.
class ViewObserver extends NavigatorObserver {
  ViewObserver._() {
    _instance ??= this;
  }

  static ViewObserver? _instance;

  /// ### 싱글톤 으로 만들어 진 GrowObserver 의 객체를 얻어 온다.
  static ViewObserver get instance => _instance ??= ViewObserver._();

  /// ### 태그를 사용 하는 라우팅 목록
  /// key 는 동일 라우팅 이 중첩 되는 화면의 라우팅 이름 이고, value 는 각 화면들 에서 tag 값을 전달 할때
  /// 사용 하는 [Get.arguments]의 키 값이다.
  final Map<String, String> _taggedRoute = {
    Routes.home : 'arg1',
  };

  /// ### ⭐ 페이지 스텍에 따라 [Get]라우팅 에서 사용 되는 이름과 테그 값을 저장
  /// 만약 특정 라우팅 이 여러 태그를 통해서 중첩 라우팅 되는 경우, 중첩 시 마다 키 값으로 가지고 있는
  /// 태그 까지 같이 관리 해서 스택을 관리 한다.
  final List<MapEntry<String, dynamic>> _routes = [];

  /// 현재 특정 라우트 네임이 페이지 스텍이 존재 하는지 확인
  bool containsRoute(String name, {dynamic tag}) {
    if (_taggedRoute.containsKey(name)) {
      return _routes.any((e) => e.key == name && e.value == tag);
    }

    return _routes.any((e) => e.key == name);
  }

  /// 현제 페이지 가 마지막 라우트 인지 확인 하는 getter.
  bool get isFirstRoute => _routes.length == 1;

  /// ### 현재의 라우팅 정보가 라우팅 스택의 최상단 에 있는지 확인 한다
  bool isCurrent(String route, {dynamic tag}) {
    final lastEntry = _routes.last;
    if (_taggedRoute.containsKey(route)) {
      return lastEntry.key == route && lastEntry.value == tag;
    } else {
      return lastEntry.key == route;
    }
  }

  /// ### 현재 라우팅 스텍에 있는 특정 라우팅 의 태그값 목록
  /// 특정 [route] 문자열 에 해당 하는 tag 값들을 추출 해서 목록 으로 반환 한다.
  List<T?> findTags<T>(String route) {
    return _routes
        .where((e) => e.key == route)
        .map((e) => e.value as T?)
        .toList();
  }

  /// 전달 받은 [GetPageRoute]에서 테그로 사용 되는 값을 추출 한다
  dynamic _obtainTag(GetPageRoute route, String routeName) {
    final arg = route.settings.arguments;
    if (arg != null && arg is Map) {
      return arg[_taggedRoute[routeName]];
    }

    return null;
  }

  /// 라우팅 스택에 새로운 화면을 추가 한다.
  void _putPage(GetPageRoute route) {
    final name = route.settings.name;
    if (name == null) {
      return;
    }
    // 태그를 사용 하는 페이지 라우팅 인 경우
    if (_taggedRoute.containsKey(name)) {
      final tag = _obtainTag(route, name);
      _routes.add(MapEntry(name, tag));
    }
    // 태그를 사용 하지 않고 한번에 하나의 라우팅 만 존재 하는 경우,
    else {
      _routes.add(MapEntry(name, null));
    }
  }

  /// 라우팅 스택 에서 기존 화면을 제거 한다
  void _removePage(GetPageRoute route) {
    final name = route.settings.name;
    if (name == null) {
      return;
    }
    dynamic tag;
    if (_taggedRoute.containsKey(name)) {
      tag = _obtainTag(route, name);
    }
    final removedIndex = _routes.lastIndexWhere((e) => e.key == name && e.value == tag);
    if (removedIndex >= 0) {
      _routes.removeAt(removedIndex);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route is GetPageRoute) {
      _removePage(route);
      _debugLine();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is GetPageRoute) {
      _putPage(route);
      _debugLine();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute != null && oldRoute != null) {
      didPop(oldRoute, newRoute);
      didPush(newRoute, oldRoute);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    didPop(route, previousRoute);
  }

  /// 디버깅 시 사용.
  void _debugLine() {
    if (!kDebugMode) {
      return;
    }
    const name = '화면 옵저버';
    Log.d('️️▷▷    화면 변경    ▷▷', name: name);
    for (var e in _routes) {
      if (_taggedRoute.containsKey(e.key)) {
        Log.d('라우트 명: ${e.key}, tag: ${e.value}', name: name);
      } else {
        Log.d('라우트 명: ${e.key}', name: name);
      }
    }
    Log.d('️️◀◀ 총 라우팅 스택 길이: ${_routes.length}︎', name: name);
  }
}
