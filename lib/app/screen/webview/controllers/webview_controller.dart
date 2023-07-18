import 'dart:async';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/app/core/base/base_controller.dart';

class InAppWebViewController extends BaseController {

  /// Input Argument  ==>
  final RxString _url = ''.obs;
  String get url => _url.value;
  final RxString _title = ''.obs;
  String get title => _title.value;
  final RxString _html = ''.obs;
  String get html => _html.value;
  /// <== Input Argument

  RxBool isLoading = true.obs;

  Completer<WebViewController> webViewController = Completer<WebViewController>();

  @override
  void onInit() {
    super.onInit();
    _title(Get.arguments?['title'] ?? '');
    _url(Get.arguments?['url'] ?? '');
    _html(Get.arguments?['html'] ?? '');
  }

  @override
  Future<bool> goBack() async {
    unFocusAll();

    Get.back();

    return Future.value(false);
  }

  void setController(WebViewController controller) {
    webViewController.complete(controller);
  }
}
