import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  PreferencesManager._internal();

  factory PreferencesManager() {
    return _instance;
  }

  static final PreferencesManager _instance = PreferencesManager._internal();
  late final SharedPreferences _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //Get
  String? getString(String key) {
    return _preferences.getString(key);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  //Set
  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  //remove & clear
  remove(String key) async {
    await _preferences.remove(key);
  }

  clear() async {
    await _preferences.clear();
  }
}
