import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Biometrics model class
/// Uses ChangeNotifier to update changes to Main
class BiometricModel extends ChangeNotifier {
  /// Initiate local authentication instance
  final LocalAuthentication authenticate = LocalAuthentication();

  /// Notification class variables
  final String key = "biometrics";

  /// Toggle value biometrics
  late bool _biometrics;

  /// Getter for the biometrics setting
  bool get biometrics => _biometrics;

  /// Function to check the authentication methods available on the phone of the user
  Future checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await authenticate.canCheckBiometrics;
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

  /// Function to locally authenticate user
  Future localAuthenticate() async {
    bool authenticated = false;
    try {
      authenticated = await authenticate.authenticate(
        localizedReason: 'Please authenticate',
        //useErrorDialogs: true,
        //stickyAuth: true
      );
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

  /// Biometric model class constructor
  /// Initialize _biometrics variable
  /// Loads latest biometric setting from SharedPreferences
  BiometricModel() {
    _biometrics = false;
    loadFromPrefs();
  }

  /// Function to toggle the biometrics setting in SharedPreferences
  void toggleBiometrics() {
    _biometrics = !_biometrics;
    saveToPrefs();
  }

  /// Function to load the biometric settings in SharedPreferences
  void loadFromPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    _biometrics = preference.getBool(key) ?? false;
    notifyListeners();
  }

  /// Function to save the biometric settings in SharedPreferences
  void saveToPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setBool(key, _biometrics);
    notifyListeners();
  }
}
