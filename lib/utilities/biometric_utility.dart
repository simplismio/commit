import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/biometric_model.dart';
import 'authorization_utility.dart';

class BiometricUtility extends StatefulWidget {
  const BiometricUtility({Key? key}) : super(key: key);

  @override
  _BiometricUtilityState createState() => _BiometricUtilityState();
}

class _BiometricUtilityState extends State<BiometricUtility> {
  bool hasAuthenticated = false;

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
      return const AuthorizationUtility();
    } else {
      if (kDebugMode) {
        print('The user is not yet authenticated using biometrics');
      }

      BiometricModel().authenticate().then((result) => setState(() =>
          result == true ? hasAuthenticated = true : hasAuthenticated = false));
      if (hasAuthenticated == true) {
        if (kDebugMode) {
          print('The user is now authenticated using biometrics');
        }
        return const AuthorizationUtility();
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
