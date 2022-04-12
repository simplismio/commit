import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../screens/main_screen.dart';
import '../screens/signin_screen.dart';

class AuthorizationUtility extends StatelessWidget {
  const AuthorizationUtility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context, listen: true);
    return user?.uid == null ? const SignInScreen() : const MainScreen();
  }
}
