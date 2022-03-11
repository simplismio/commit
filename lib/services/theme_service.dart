import 'storage_service.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: const Color(0xfff1f1f1));

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
);

class ThemeService extends ChangeNotifier {
  final String key = "theme";
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeService() {
    _darkTheme = false;
    _loadFromStorage();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToStorage();
  }

  Future<void> _loadFromStorage() async {
    _darkTheme = await StorageService.readData(key) ?? true;
    notifyListeners();
  }

  _saveToStorage() async {
    StorageService.saveData(key, _darkTheme);
    notifyListeners();
  }
}
