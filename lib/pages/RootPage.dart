import 'package:commit/screens/iam/localAuthorization.dart';
import 'package:commit/screens/public/homeScreen.dart';
import 'package:commit/services/localAuthenticationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalAuthenticationService>(builder:
        (context, LocalAuthenticationService localAuthentication, child) {
      if (kDebugMode) {
        print('Starting app, local user authentication status: ' +
            localAuthentication.biometrics.toString());
      }

      if (localAuthentication.biometrics == true) {
        return const LocalAuthorization();
      } else {
        return const HomeScreen();
      }
    });
  }
}
