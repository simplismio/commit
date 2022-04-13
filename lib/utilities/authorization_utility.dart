import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/user_Model.dart';
import '../views/main_view.dart';
import '../views/signin_view.dart';

class AuthorizationUtility extends StatelessWidget {
  const AuthorizationUtility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context, listen: true);
    return user?.uid == null ? const SignInView() : const MainView();
  }
}
