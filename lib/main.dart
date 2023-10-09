import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/app_controller.dart';
import 'app/di/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/view_observer.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack, name: 'AppError');
  };

  runApp(MyApp());
}

class MyApp extends GetView<AppController> with WidgetsBindingObserver {
  final AppController appController = Get.put(AppController(), permanent: true);

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: '성적 관리기',
      initialRoute: AppPages.initial,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      navigatorKey: appController.navKey,
      navigatorObservers: [
        ViewObserver.instance,
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
        Locale('ko', ''), // set not supported language to english
      ],
      locale: const Locale('ko', 'KR'),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        /// 시스템 의 Text 사이즈 가 변경 되도 앱내의 텍스트 사이즈 를 고정 한다.
        return MediaQuery(
          data: context.mediaQuery.copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
    );
  }
}
