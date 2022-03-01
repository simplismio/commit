// ignore_for_file: unnecessary_import, file_names, prefer_const_constructors

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:commit/screens/iam/signupScreen.dart';
import 'package:commit/services/authenticationService.dart';
import 'package:commit/shares/loadingShare.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingShare()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: 0.0,
              centerTitle: true,
              title:
                  const Text('Sign-In', style: TextStyle(color: Colors.white)),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: _formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Text('Welcome',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5.0),
                      TextFormField(
                          decoration: const InputDecoration(hintText: "Email"),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            //print(value.length);
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid number.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => email = val);
                          }),
                      TextFormField(
                          decoration:
                              const InputDecoration(hintText: "Password"),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid number.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                          child: const Text("I forgot my password"),
                          onTap: () {
                            showMaterialModalBottomSheet(
                                expand: false,
                                context: context,
                                builder: (context) => const SizedBox(
                                    height: 300, child: ForgotPassword()));
                          }),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Sign-In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              AuthenticationService()
                                  .signIn(email, password)
                                  .then((result) {
                                if (result == null) {
                                  Get.back();
                                } else {
                                  setState(() => loading = false);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      result,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ));
                                }
                              });
                            } else {
                              setState(() {
                                loading = false;
                                error = 'Something went wrong.';
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      GestureDetector(
                          child: const Text("Sign-up using email"),
                          onTap: () {
                            Get.to(const SignUpScreen());
                          }),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          (kIsWeb && Platform.isIOS) ? Spacer() : Container(),
                          IconButton(
                              icon: FaIcon(FontAwesomeIcons.facebookSquare),
                              onPressed: () {
                                setState(() => loading = true);
                                AuthenticationService()
                                    .signInWithFacebook()
                                    .then((result) {});
                              }),
                          Spacer(),
                          IconButton(
                              icon: FaIcon(FontAwesomeIcons.google),
                              onPressed: () {
                                setState(() => loading = true);
                                AuthenticationService()
                                    .signInWithGoogle()
                                    .then((result) {});
                              }),
                          (Platform.isIOS) ? Spacer() : Container(),
                          (kIsWeb || Platform.isIOS)
                              ? IconButton(
                                  icon: FaIcon(FontAwesomeIcons.apple),
                                  onPressed: () {
                                    // setState(() => loading = true);
                                    // AuthenticationService()
                                    //     .signInWithApple()
                                    //     .then((result) {});
                                  })
                              : Container(),
                          (kIsWeb && Platform.isIOS) ? Spacer() : Container(),
                        ],
                      ),
                    ],
                  )),
            ),
          );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String? email;

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingShare()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: _formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30.0),
                      const Text('Reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          decoration: const InputDecoration(hintText: "Email"),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            //print(value.length);
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid email.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => email = val);
                          }),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Reset password",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              AuthenticationService()
                                  .resetPassword(email)
                                  .then((result) {
                                if (result == null) {
                                  Get.back();
                                } else {
                                  setState(() => loading = false);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      result,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ));
                                }
                              });
                            } else {
                              setState(() {
                                loading = false;
                                error = 'Something went wrong.';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }
}
