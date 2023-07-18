
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_values.dart';
import '../../../core/widget/common/common_title_bar.dart';
import '/app/core/base/base_view.dart';
import '../controllers/webview_controller.dart';

class InAppWebView extends BaseView<InAppWebViewController> {

  const InAppWebView({super.key});


  @override
  Widget? appBar(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Log.d('백버튼2');
      },
      child: CTitleBar(
        title: controller.title,
        color: AppColors.secondary,
        backWidget: SizedBox(
          width: AppValues.appBarSize,
          height: AppValues.appBarSize,
          child: const Icon(Icons.arrow_back, color: AppColors.black,),
        ),
        onBack: () {
          Log.d('백버튼');
          controller.goBack();
        },
      ),
    );
  }

  @override
  Widget body(BuildContext context) {

    return SizedBox(
      width: Get.width,
      height: Get.height - Get.mediaQuery.padding.top - Get.mediaQuery.padding.bottom - AppValues.appBarSize,
      child: WebView(
        initialUrl: controller.url.isEmpty ? null : controller.url,
        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: true,
        onWebResourceError: (error) {
          //controller.hideLoading();
          Log.e('error: ${error.description}');
        },
        onWebViewCreated: (WebViewController webViewController) {
          if(controller.html.isNotEmpty) {
            webViewController.loadHtmlString(controller.html);
          }
          controller.setController(webViewController);
        },
        onPageStarted: (String url) {
          //controller.showLoading();
          Log.d('onPageStarted: $url');
        },
        onPageFinished: (String url) {
          //controller.hideLoading();
          Log.d('onPageFinished: $url');
        },
      ),
    );
  }
}
