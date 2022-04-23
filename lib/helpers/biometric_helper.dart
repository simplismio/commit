import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/biometric_model.dart';
import 'authorization_helper.dart';

/// Biometric helper class
class BiometricHelper extends StatefulWidget {
  const BiometricHelper({Key? key}) : super(key: key);

  @override
  _BiometricHelperState createState() => _BiometricHelperState();
}

class _BiometricHelperState extends State<BiometricHelper> {
  bool hasAuthenticated = false;

  /// Widget to locally authenticate using biometrics.
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Loading local authentication status from memory: ' +
          hasAuthenticated.toString());
    }

    if (hasAuthenticated == true) {
      if (kDebugMode) {
        print('The user is already authenticated using biometrics');
      }
      return const AuthorizationHelper();
    } else {
      if (kDebugMode) {
        print('The user is not yet authenticated using biometrics');
      }

      BiometricModel().localAuthenticate().then((result) => setState(() =>
          result == true ? hasAuthenticated = true : hasAuthenticated = false));
      if (hasAuthenticated == true) {
        if (kDebugMode) {
          print('The user is now authenticated using biometrics');
        }
        return const AuthorizationHelper();
      } else {
        if (kDebugMode) {
          print('The user could not be authenticated using biometrics');
        }
        //return LocalAuthorization();
        return Container();
      }
    }
  }
}
