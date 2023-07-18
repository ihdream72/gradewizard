
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/utils/logger.dart';

class AppController extends SuperController with WidgetsBindingObserver {
  static AppController get to => Get.find();
  final Rx<AppLifecycleState> _lifeCycleState = AppLifecycleState.detached.obs;

  late final GlobalKey<NavigatorState> navKey;
  late bool isAppBackground;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    navKey = GlobalKey<NavigatorState>();

    isAppBackground = false;

    super.onInit();
  }

  @override
  void onDetached() {
    _lifeCycleState.value = AppLifecycleState.detached;
  }

  @override
  void onInactive() {
    _lifeCycleState.value = AppLifecycleState.inactive;
  }

  @override
  void onPaused() {
    _lifeCycleState.value = AppLifecycleState.paused;
  }

  @override
  void onResumed() {
    _lifeCycleState.value = AppLifecycleState.resumed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      isAppBackground = true;
      Log.d('=========> 백그라운드 진입');
    } else if (state == AppLifecycleState.resumed) {
      isAppBackground = false;
      Log.d('=========> 백그라운드 에서 복귀');

    }

    _lifeCycleState.value = state;
    super.didChangeAppLifecycleState(state);
  }
}
