import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService extends ChangeNotifier {
  final String key = "analytics";
  late bool _analytics;

  bool get analytics => kDebugMode ? _analytics : !_analytics;

  AnalyticsService() {
    _analytics = false;
    _loadFromPrefs();
  }

  toggleAnalytics() {
    _analytics = !_analytics;
    _saveToPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _analytics = _pref.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setBool(key, _analytics);
    notifyListeners();
  }
}
