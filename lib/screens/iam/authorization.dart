//import 'package:firebase_auth/firebase_auth.dart';
import 'package:start/screens/iam/signinScreen.dart';
import 'package:start/screens/public/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:start/shares/loadingShare.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    print('Ready to check authorization state Firebase');
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Center(child: LoadingShare());
        }
        final user = snapshot.data;
        if (user != null) {
          print('User is logged in');
          return const HomeScreen();
        } else {
          print('User is NOT logged in');
          return const SignInScreen();
        }
      },
    );
  }
}
