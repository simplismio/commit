import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static void saveData(String _key, dynamic _value) async {
    final _preferences = await SharedPreferences.getInstance();
    if (_value is int) {
      await _preferences.setInt(_key, _value);
    } else if (_value is String) {
      await _preferences.setString(_key, _value);
    } else if (_value is bool) {
      await _preferences.setBool(_key, _value);
    } else {
      print("Invalid Type");
    }
  }

  static Future<dynamic> readData(String _key) async {
    final _preferences = await SharedPreferences.getInstance();
    dynamic _object = _preferences.get(_key);
    return _object;
  }

  static Future<bool> removeData(String _key) async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.remove(_key);
  }
}
