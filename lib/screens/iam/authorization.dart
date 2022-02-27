import 'package:commit/screens/iam/signinScreen.dart';
import 'package:commit/screens/public/homeScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:commit/shares/loadingShare.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Ready to check authorization state Firebase');
    }
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(child: LoadingShare());
        }
        final user = snapshot.data;
        if (user != null) {
          if (kDebugMode) {
            print('User is logged in');
          }
          return const HomeScreen();
        } else {
          if (kDebugMode) {
            print('User is NOT logged in');
          }
          return const SignInScreen();
        }
      },
    );
  }
}
