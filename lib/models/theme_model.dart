import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  scaffoldBackgroundColor: const Color(0xfff1f1f1),
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
);

/// Theme model class
/// Uses ChangeNotifier to update changes to Main
class ThemeModel extends ChangeNotifier {
  /// Theme class variables
  final String key = "theme";

  /// Toggle value theme
  late bool _darkTheme;

  /// Getter for the theme setting
  bool get darkTheme => kDebugMode ? _darkTheme : !_darkTheme;

  /// Theme model class constructor
  /// Initialize _darkTheme variable
  /// Loads latest theme setting from SharedPreferences
  ThemeModel() {
    _darkTheme = false;
    loadFromPrefs();
  }

  /// Function to toggle the theme setting in SharedPreferences
  void toggleTheme() {
    _darkTheme = !_darkTheme;
    saveToPrefs();
  }

  /// Function to load the theme settings in SharedPreferences
  void loadFromPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _darkTheme = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  /// Function to save the theme settings in SharedPreferences
  void saveToPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setBool(key, _darkTheme);
    notifyListeners();
  }
}
