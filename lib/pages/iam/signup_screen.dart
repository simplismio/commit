import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../shares/loading_share.dart';
import 'authorization.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingShare()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: Colors.white,
                  onPressed: () {
                    Get.offAll(const Authorization());
                  }),
              elevation: 0.0,
              centerTitle: true,
              title:
                  const Text('Sign-Up', style: TextStyle(color: Colors.white)),
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
                      const SizedBox(height: 20.0),
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
                            //_showConfirmDialog(context);
                          }),
                      TextFormField(
                          decoration:
                              const InputDecoration(hintText: "Password"),
                          textAlign: TextAlign.left,
                          // initialValue: _auth.phoneNumberSignIn == ''
                          //     ? '+95 9'
                          //     : _auth.phoneNumberSignIn,
                          autofocus: true,
                          validator: (String? value) {
                            //print(value.length);
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid number.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => password = val);
                            //_showConfirmDialog(context);
                          }),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Sign-Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              UserService()
                                  .signUpUsingEmailAndPassword(
                                      email: email, password: password)
                                  .then((result) {
                                if (result == null) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Authorization()));
                                } else {
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
                                error = 'Unable to send a SMS login code.';
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
