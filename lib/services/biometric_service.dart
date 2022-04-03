import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService extends ChangeNotifier {
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
    } on PlatformException catch (error) {
      canCheckBiometrics = false;
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      if (authenticated == true) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return;
    }
  }

  BiometricService() {
    _biometrics = false;
    _loadFromPrefs();
  }

  toggleBiometrics() {
    _biometrics = !_biometrics;
    _saveToPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    _biometrics = preference.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setBool(key, _biometrics);
    notifyListeners();
  }
}
