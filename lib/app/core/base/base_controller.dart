import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import '../utils/logger.dart';
import '../widget/loading.dart';

enum ViewState {
  defaultState,
  loading,
  success,
  failed,
  updated,
  created,
  noInternet,
  message,
  unAuthorized,
}

abstract class BaseController extends GetxController {

  // 키보드 보일떄 안 보일떄 화면 처리를 위해
  late StreamSubscription keyboardSubscription;
  final RxBool _isKeyboardVisible = false.obs; // 키보드 보임 여부
  bool get isKeyboardVisible => _isKeyboardVisible.value;

  bool isShowLoading = false;
  LoadingType loadingType = LoadingType.loading;

  final Rx<ViewState> _viewState = Rx<ViewState>(ViewState.defaultState);
  ViewState get viewState => _viewState.value;
  set viewState(state) => _viewState(state);


  ViewState showLoading({LoadingType type = LoadingType.loading}) {

    if(!isShowLoading) {
      isShowLoading = true;
      loadingType = type;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewState = ViewState.loading;
      });

      return ViewState.loading;
    }

    return viewState;
  }

  ViewState hideLoading() {

    if(isShowLoading) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        isShowLoading = false;
        viewState = ViewState.defaultState;
      });

      return ViewState.defaultState;
    }

    return viewState;
  }



  // ignore: long-parameter-list
  dynamic callDataService<T>(
    Future<T> future, {
    Function(Exception exception)? onError,
    Function(T response)? onSuccess,
    Function(T response)? onFail,
    Function? onStart,
    Function? onComplete,
    Function? onRefreshToken,
  }) async {
    Exception? _exception;

    try {
      final T response = await future;

      /// check Rest API 성공 여부를 여기서 체크하면 된다.

      return response;
    } catch (exception) {
      /// Error Handling
      ///
      hideLoading();
      _exception = exception as Exception?;
      Log.e('Controller>>>>>> error $exception');
    }

    if (onError != null && _exception != null) onError(_exception);

    onComplete == null ? hideLoading() : onComplete();
  }


  @override
  void onInit() {

    keyboardSubscription = KeyboardVisibilityController().onChange.listen((bool isVisible) {
      _isKeyboardVisible(isVisible);
    });

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void unFocusAll() {

  }

  Future<bool> goBack() {

    return Future.value(true);
  }

  /// iOS 의 Swipe Back 을 처리
  bool isCanSwipeBack() {

    if(!Platform.isAndroid) {
      /// iOS
      return true;
    }
    /// Android

    return false;
  }
}
