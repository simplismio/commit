import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/user_service.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;

  String? email;
  String? password;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: 0.0,
              centerTitle: true,
              title: const Text('Sign-In'),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: _formKeyForm,
                  child: Column(
                    children: <Widget>[
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
                      TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: InkWell(
                              onTap: _toggle,
                              child: Icon(
                                _obscureText
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 20.0,
                              ),
                            ),
                          ),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid password.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                          child: const Text("I forgot my password"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ForgotPasswordScreen()));
                          }),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Sign-In",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              UserService()
                                  .signInUsingEmailAndPassword(email, password)
                                  .then((result) {
                                if (result == null) {
                                  // Navigator.pop(context);
                                } else {
                                  setState(() => loading = false);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      result,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.grey[800],
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const SignUpScreen()));
                          }),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          //   (kIsWeb && Platform.isIOS)
                          //       ? const Spacer()
                          //       : Container(),
                          //   IconButton(
                          //       icon:
                          //           const FaIcon(FontAwesomeIcons.facebookSquare),
                          //       onPressed: () {
                          //         setState(() => loading = true);
                          //         UserService()
                          //             .signInWithFacebook()
                          //             .then((result) {});
                          //       }),
                          //   const Spacer(),
                          //   IconButton(
                          //       icon: const FaIcon(FontAwesomeIcons.google),
                          //       onPressed: () {
                          //         setState(() => loading = true);
                          //         UserService()
                          //             .signInWithGoogle()
                          //             .then((result) {});
                          //       }),
                          //   (Platform.isIOS) ? const Spacer() : Container(),
                          //   (kIsWeb || Platform.isIOS)
                          //       ? IconButton(
                          //           icon: const FaIcon(FontAwesomeIcons.apple),
                          //           onPressed: () {
                          //             setState(() => loading = true);
                          //             UserService()
                          //                 .signInWithApple()
                          //                 .then((result) {});
                          //           })
                          //       : Container(),
                          //   (kIsWeb && Platform.isIOS)
                          //       ? const Spacer()
                          //       : Container(),
                        ],
                      ),
                    ],
                  )),
            ),
          );
  }
}
