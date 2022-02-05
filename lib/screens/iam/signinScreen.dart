import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:start/screens/iam/signupScreen.dart';
import 'package:start/services/authenticationService.dart';
import 'package:start/shares/loadingShare.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                      const SizedBox(height: 5.0),
                      ButtonTheme(
                        minWidth: 330.0,
                        height: 50.0,
                        child: ElevatedButton(
                          child: const Text(
                            "Sign-In",
                            style: const TextStyle(
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
                      const SizedBox(height: 5.0),
                      GestureDetector(
                          child: const Text("Sign-up using email"),
                          onTap: () {
                            Get.to(const SignUpScreen());
                          }),
                      const SizedBox(height: 5.0),
                      const Divider(),
                      // SizedBox(height: 5.0),
                      // Text('Social Sign In'),
                      // SizedBox(height: 10.0),
                      // Row(
                      //   children: [
                      //     (kIsWeb && Platform.isIOS) ? Spacer() : Container(),
                      //     IconButton(
                      //         icon: FaIcon(FontAwesomeIcons.facebookSquare),
                      //         onPressed: () {
                      //           // setState(() => loading = true);
                      //           // AuthenticationService()
                      //           //     .signInWithFacebook()
                      //           //     .then((result) {});
                      //         }),
                      //     Spacer(),
                      //     IconButton(
                      //         icon: FaIcon(FontAwesomeIcons.google),
                      //         onPressed: () {
                      //           // setState(() => loading = true);
                      //           // AuthenticationService()
                      //           //     .signInWithGoogle()
                      //           //     .then((result) {});
                      //         }),
                      //     (kIsWeb && Platform.isIOS) ? Spacer() : Container(),
                      //     (kIsWeb && Platform.isIOS)
                      //         ? IconButton(
                      //             icon: FaIcon(FontAwesomeIcons.apple),
                      //             onPressed: () {
                      //               // setState(() => loading = true);
                      //               // AuthenticationService()
                      //               //     .signInWithApple()
                      //               //     .then((result) {});
                      //             })
                      //         : Container(),
                      //     (kIsWeb && Platform.isIOS) ? Spacer() : Container(),
                      //   ],
                      // ),
                    ],
                  )),
            ),
          );
  }
}
