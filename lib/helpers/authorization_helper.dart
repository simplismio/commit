import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../views/main_view.dart';
import '../views/sign_in_up_view.dart';

/// Authorization helper class
class AuthorizationHelper extends StatelessWidget {
  const AuthorizationHelper({Key? key}) : super(key: key);

  /// Widget to redirect user to SignInUpView if not authenticated, or to MainView if authenticated
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context, listen: true);
    return user?.uid == null ? const SignInUpView() : const MainView();
  }
}
