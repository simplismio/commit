import 'package:commit/pages/iam/signinScreen.dart';
import 'package:commit/pages/public/homeScreen.dart';
import 'package:commit/services/userService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:commit/shares/loadingShare.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final UserService _user = UserService();

  Future<String> getActiveUserUid() async {
    var user = await _user.currentUser();
    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserService?>(context, listen: true);
    return FutureBuilder<String>(
        future: getActiveUserUid(),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingShare();
          } else {
            if (!snapshot.hasData) {
              return const SignInScreen();
            } else {
              return const HomeScreen();
            }
          }
        });
  }
}
