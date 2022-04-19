import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Analytics model class
/// Uses ChangeNotifier to update changes to Main
class AnalyticsModel extends ChangeNotifier {
  /// Notification class variables
  final String key = "analytics";

  /// Toggle value analytics
  late bool _analytics;

  /// Getter for the analytics setting
  bool get analytics => kDebugMode ? _analytics : !_analytics;

  /// Analytics model class constructor
  /// Initialize _analytics variable
  /// Loads latest analytics setting from SharedPreferences
  AnalyticsModel() {
    _analytics = false;
    loadFromPrefs();
  }

  /// Function to toggle the analytics setting in SharedPreferences
  void toggleAnalytics() {
    _analytics = !_analytics;
    saveToPrefs();
  }

  /// Function to load the analytics settings in SharedPreferences
  void loadFromPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _analytics = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  /// Function to save the analytics settings in SharedPreferences
  void saveToPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setBool(key, _analytics);
    notifyListeners();
  }
}
