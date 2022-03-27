import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../services/local_authentication_service.dart';
import 'authorization_utility.dart';

class LocalAuthorizationUtility extends StatefulWidget {
  const LocalAuthorizationUtility({Key? key}) : super(key: key);

  @override
  _LocalAuthorizationUtilityState createState() =>
      _LocalAuthorizationUtilityState();
}

class _LocalAuthorizationUtilityState extends State<LocalAuthorizationUtility> {
  //Future<dynamic> _canAuthenticate =
  //LocalAuthenticationService().checkBiometrics();
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

      LocalAuthenticationService().authenticate().then((result) => setState(
          () => result == true
              ? hasAuthenticated = true
              : hasAuthenticated = false));
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
