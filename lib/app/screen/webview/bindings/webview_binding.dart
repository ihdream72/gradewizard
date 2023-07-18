import 'package:get/get.dart';
import '../controllers/webview_controller.dart';


class InAppWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InAppWebViewController>(() => InAppWebViewController(),
      fenix: true
    );
  }
}
