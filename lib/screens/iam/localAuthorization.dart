import 'package:flutter/material.dart';
import 'package:start/screens/iam/authorization.dart';
import 'package:start/screens/public/homeScreen.dart';
import 'package:start/services/localAuthenticationService.dart';

class LocalAuthorization extends StatefulWidget {
  const LocalAuthorization({Key? key}) : super(key: key);

  @override
  _LocalAuthorizationState createState() => _LocalAuthorizationState();
}

class _LocalAuthorizationState extends State<LocalAuthorization> {
  //Future<dynamic> _canAuthenticate =
  //LocalAuthenticationService().checkBiometrics();
  bool hasAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    print('Loading local authentication status from memory: ' +
        hasAuthenticated.toString());

    if (hasAuthenticated == true) {
      print('The user is already authenticated using biometrics');
      return Authorization();
    } else {
      print('The user is not yet authenticated using biometrics');

      LocalAuthenticationService().authenticate().then((result) => setState(
          () => result == true
              ? hasAuthenticated = true
              : hasAuthenticated = false));
      if (hasAuthenticated == true) {
        print('The user is now authenticated using biometrics');
        return Authorization();
      } else {
        print('The user could not be authenticated using biometrics');
        //return LocalAuthorization();
        return Container();
      }
    }
  }
}
