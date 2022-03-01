// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();

  final String key = "biometrics";
  late bool _biometrics;

  bool get biometrics => _biometrics;

  Future checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics == true) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      if (authenticated == true) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

  LocalAuthenticationService() {
    _biometrics = false;
    _loadFromPrefs();
  }

  toggleBiometrics() {
    _biometrics = !_biometrics;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref;
  }

  _loadFromPrefs() async {
    SharedPreferences _pref = await _initPrefs();
    _biometrics = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences _pref = await _initPrefs();
    _pref.setBool(key, _biometrics);
    //notifyListeners();
  }
}
