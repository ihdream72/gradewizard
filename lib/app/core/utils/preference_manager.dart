import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/logger.dart';

class PreferenceManager {

  static final PreferenceManager _instance = PreferenceManager._internal();

  factory PreferenceManager() => _instance;

  //클래스 가 최초 생성될 때 1회 발생
  PreferenceManager._internal() {
    Log.d('SharedPreferences 싱글턴 생성 완료', name: 'SharedPreferences');
  }

  final _preference = SharedPreferences.getInstance();

  Future<String> getString(String key, {String defaultValue = ''}) {
    return _preference
        .then((preference) => preference.getString(key) ?? defaultValue);
  }

  Future<bool> setString(String key, String value) {
    return _preference.then((preference) => preference.setString(key, value));
  }

  Future<int> getInt(String key, {int defaultValue = 0}) {
    return _preference
        .then((preference) => preference.getInt(key) ?? defaultValue);
  }

  Future<bool> setInt(String key, int value) {
    return _preference.then((preference) => preference.setInt(key, value));
  }

  Future<double> getDouble(String key, {double defaultValue = 0.0}) {
    return _preference
        .then((preference) => preference.getDouble(key) ?? defaultValue);
  }

  Future<bool> setDouble(String key, double value) {
    return _preference.then((preference) => preference.setDouble(key, value));
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) {
    return _preference
        .then((preference) => preference.getBool(key) ?? defaultValue);
  }

  Future<bool> setBool(String key, bool value) {
    return _preference.then((preference) => preference.setBool(key, value));
  }

  Future<List<String>> getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _preference
        .then((preference) => preference.getStringList(key) ?? defaultValue);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _preference
        .then((preference) => preference.setStringList(key, value));
  }

  Future<bool> remove(String key) {
    return _preference.then((preference) => preference.remove(key));
  }

  Future<bool> clear() {
    return _preference.then((preference) => preference.clear());
  }
}
