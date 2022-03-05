import '../../services/user_service.dart';
import '../public/home_screen.dart';
import 'signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    UserService? us = Provider.of<UserService?>(context, listen: true);
    return us?.uid != null ? const HomeScreen() : const SignInScreen();
  }
}
