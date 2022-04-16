import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsModel extends ChangeNotifier {
  final String key = "analytics";
  late bool _analytics;

  bool get analytics => kDebugMode ? _analytics : !_analytics;

  AnalyticsModel() {
    _analytics = false;
    _loadFromPrefs();
  }

  toggleAnalytics() {
    _analytics = !_analytics;
    _saveToPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _analytics = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setBool(key, _analytics);
    notifyListeners();
  }
}
