import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/values/app_colors.dart';
import '../values/app_values.dart';
import '../widget/loading.dart';

abstract class BaseView<Controller extends BaseController> extends GetView<Controller> {

  Widget body(BuildContext context);
  Widget? appBar(BuildContext context);
  Widget? bottomButton(BuildContext context) { return null; }

  const BaseView({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        pageScaffold(context),
        controller.viewState == ViewState.loading
            ? showLoading(controller.loadingType)
            : Container(),
      ],
    );
  }

  Widget pageScaffold(BuildContext context) {
    return Material(
      color: Colors.white,
      child: WillPopScope(
        onWillPop: controller.isCanSwipeBack() ? null : () {

          return controller.goBack();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: pageBackgroundColor(),
            floatingActionButton: floatingActionButton(),
            body: pageContent(context),
            bottomNavigationBar: bottomNavigationBar(),
            drawer: drawer(),
        ),
      ),
    );
  }

  Widget pageContent(BuildContext context) {

    Widget? bottom = bottomButton(context);
    Widget? bar = appBar(context);

    double bodyTopMargin = bar != null ? AppValues.appBarSize + Get.mediaQuery.padding.top : 0;
    double bodyBottomMargin = controller.isKeyboardVisible ? 0 : ( bottom != null ? AppValues.bottomButtonSize + Get.mediaQuery.padding.bottom : 0 );
    double heightBody = Get.height - (bar != null ? AppValues.appBarSize : 0) - (bottom != null ? AppValues.bottomButtonSize : 0) - Get.mediaQuery.padding.top - Get.mediaQuery.padding.bottom;


    return WillPopScope(
      onWillPop: controller.isCanSwipeBack() ? null : () {

        return controller.goBack();
      },
      child: InkWell(
        onTap: () => unFocusAll(),
        child: Stack(
          children: [
            bar ?? Container(),
            Container(
              height: heightBody,
              margin: EdgeInsets.only(top: bodyTopMargin, bottom: bodyBottomMargin),
              child: body(context)
            ),
            Container(
              margin: EdgeInsets.only(top: Get.height - (AppValues.bottomButtonSize + Get.mediaQuery.padding.bottom)),
              child: bottom ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

  Color pageBackgroundColor() {
    return AppColors.transparent;
  }

  Widget? floatingActionButton() {
    return null;
  }

  Widget? bottomNavigationBar() {
    return null;
  }

  Widget? drawer() {
    return null;
  }

  Widget showLoading(LoadingType type) {
    return Loading(type: type);
  }

  void unFocusAll(){
    controller.unFocusAll();
  }


}
