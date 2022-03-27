import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static List<String> languages = ['English', 'Dutch'];
  final String key = "language";

  late String _language;
  String? shoes;
  late Map<String, dynamic> translations;

  LanguageService() {
    _language = 'English';
    _loadFromPrefs();
  }

  String get language => _language;

  setLanguage(_value) {
    _language = _value;
    _saveToPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _language = _pref.getString(key) ?? 'English';
    _switchLanguage(_language);
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setString(key, _language);
    _switchLanguage(_language);
    notifyListeners();
  }

  void _switchLanguage(_language) {
    switch (_language) {
      case 'English':
        shoes = 'Shoes';
        break;
      case 'Dutch':
        shoes = 'Schoenen';
        break;
      default:
        shoes = 'Shoes';
    }
  }
}
