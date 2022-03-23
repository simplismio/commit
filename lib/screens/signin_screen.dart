import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/user_service.dart';
import '../services/theme_service.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'package:provider/provider.dart';

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

  final double breakpoint = 800;
  final int paneProportion = 60;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  signInForm() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeService _theme = Provider.of<ThemeService>(context, listen: true);

    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: 0.0,
              centerTitle: true,
              title: !kIsWeb ? const Text('Sign-In') : Container(),
            ),
            body: (breakpoint < MediaQuery.of(context).size.width)
                ? Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: paneProportion,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 250),
                              Row(
                                children: const [
                                  Spacer(),
                                  Text('Commit & More',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 65)),
                                  Spacer(),
                                ],
                              ),
                              const Text('Just do it',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 100 - paneProportion,
                        child: Column(
                          children: [
                            SizedBox(height: 175),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: _theme.darkTheme == true
                                        ? Colors.grey[800]
                                        : Colors.grey[200]),
                                child: signInForm(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Flex(
                    direction: Axis.horizontal,
                    children: [Flexible(flex: 100, child: signInForm())],
                  ));
  }
}
