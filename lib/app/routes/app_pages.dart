import 'package:get/get.dart';

import '../screen/add_subject/bindings/add_subject_binding.dart';
import '../screen/add_subject/views/add_subject_view.dart';
import '../screen/audio_reading/bindings/audio_reading_binding.dart';
import '../screen/audio_reading/views/audio_reading_view.dart';
import '../screen/home/bindings/home_binding.dart';
import '../screen/home/views/home_view.dart';
import '../screen/webview/bindings/webview_binding.dart';
import '../screen/webview/views/webview_view.dart';

import 'app_routes.dart';


class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [

    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.addSubject,
      page: () => const AddSubjectView(),
      binding: AddSubjectBinding(),
    ),
    GetPage(
      name: Routes.webview,
      page: () => const InAppWebView(),
      binding: InAppWebViewBinding(),
    ),
    GetPage(
      name: Routes.audioReading,
      page: () => const AudioReadingView(),
      binding: AudioReadingBinding(),
    ),

  ];
}
