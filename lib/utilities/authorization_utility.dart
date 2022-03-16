import '../../services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/main_screen.dart';
import '../screens/signin_screen.dart';

class AuthorizationUtility extends StatelessWidget {
  const AuthorizationUtility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserService? us = Provider.of<UserService?>(context, listen: true);
    return us?.uid == null
        ? const SignInScreen()
        : us?.uid != null
            ? const MainScreen()
            : const CircularProgressIndicator();
  }
}
