import 'package:commit/pages/root_page.dart';
import 'package:commit/shares/loading_share.dart';

import '../../services/user_service.dart';
import '../root_page.dart';
import 'signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    UserService? us = Provider.of<UserService?>(context, listen: true);
    return us?.uid == null
        ? const SignInScreen()
        : us?.uid != null
            ? const RootPage()
            : const LoadingShare();
  }
}
