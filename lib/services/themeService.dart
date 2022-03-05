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
);

class ThemeService extends ChangeNotifier {
  final String key = "theme2";
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  ThemeService() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    final SharedPreferences prefs = await _preferences;
    _darkTheme = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    final SharedPreferences prefs = await _preferences;
    await prefs.setBool(key, _darkTheme);
  }
}
