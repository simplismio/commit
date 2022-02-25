import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    fontFamily: 'Poppins-Bold',
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Color(0xfff1f1f1));

ThemeData dark = ThemeData(
    fontFamily: 'Poppins-Bold',
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey[900]);

class ThemeService extends ChangeNotifier {
  final String key = "theme";
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeService() {
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref;
  }

  _loadFromPrefs() async {
    SharedPreferences _pref = await _initPrefs();
    _darkTheme = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences _pref = await _initPrefs();
    _pref.setBool(key, _darkTheme);
  }
}
