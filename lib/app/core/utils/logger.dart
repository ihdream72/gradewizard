import 'dart:developer' as developer;


/// ## 로그 클래스
/// - [static] 메소드로 파져있는 [d], [e] 함수를 사용해서 로그를 남긴다.
/// - Example: Log.d('message');
class Log {
  Log._internal();

  factory Log() => _instance;
  static late final Log _instance = Log._internal();

  /// ## Debug 레벨 로그
  /// - [showPath] 값은 로그를 찍는 파일 명을 출력할지 안할지를 정한다 (기본값 false).
  /// - [name] 값으로 내가 원하는 로그명으로 출력할수있음 (기본값 ⭐️️).
  static void d(dynamic message, {bool showPath = false, String name = '⭐️', StackTrace? stacktrace, DateTime? time, Object? error}) {
    String? stackTraceStr = formatStackTrace(StackTrace.current, 2);
    var emittedFile = stackTraceStr?.split('\n').last.split('   ').last;
    var messageStr = showPath ? '$message \n\t\t파일명: $emittedFile' : message;

    developer.log(messageStr, name: name, stackTrace: stacktrace, time: time, error: error);

    /// Release Build에서 로그 확인 ( Android 만 가능 )
    //var messageLog = '[$name] $messageStr';
    //print(messageLog);
  }

  /// ## Error 레벨 로그
  /// - [showPath] 값은 로그를 찍는 파일 명을 출력할지 안할지를 정한다 (기본값 true).
  /// - [name] 값으로 내가 원하는 로그명으로 출력할수있음 (기본값 🚫오류).
  static void e(dynamic message, {bool showPath = true, String name = '🚫오류', StackTrace? stacktrace, DateTime? time, Object? error}) {
    String? stackTraceStr = formatStackTrace(StackTrace.current, 2);
    var emittedFile = stackTraceStr?.split('\n').last.split('   ').last;
    var messageStr = showPath ? '$message \n\t\t파일명: $emittedFile' : message;

    developer.log(messageStr, name: name, stackTrace: stacktrace, time: time, error: error);

    /// Release Build 에서 로그 확인 ( Android 만 가능 )
    //var messageLog = '[$name] $messageStr';
    //print(messageLog);
  }

  /// StackTrace에 있는 로그들 필터링 해주는 함수
  static String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (line.isEmpty) {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      if (++count == methodCount) {
        break;
      }
    }

    return formatted.isEmpty ? null : formatted.join('\n');
  }
}