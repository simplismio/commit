import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/user_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../utilities/authorization_utility.dart';
import 'reset_password_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;

  String? username;
  String? email;
  String? password;
  bool obscureText = true;
  bool signIn = true;

  final double breakpoint = 800;
  final int paneProportion = 60;

  void showOrHidePasswordToggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void signInSignUpToggle() {
    setState(() {
      signIn = !signIn;
      (signIn);
    });
  }

  signInButton() {
    return ElevatedButton(
      child: loading
          ? const LinearProgressIndicator()
          : const Text(
              "Sign In",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);
          UserService()
              .signInUsingEmailAndPassword(email, password)
              .then((result) {
            if (result == null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuthorizationUtility()));
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
    );
  }

  signUpButton() {
    return ElevatedButton(
      child: loading
          ? const LinearProgressIndicator()
          : const Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);
          UserService()
              .signUpUsingEmailAndPassword(
                  username: username, email: email, password: password)
              .then((result) {
            if (result == null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuthorizationUtility()));
            } else {
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
            error = 'Unable to send a SMS login code.';
          });
        }
      },
    );
  }

  signInForm() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
          key: formKeyForm,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              signIn == true
                  ? Container()
                  : TextFormField(
                      decoration: const InputDecoration(hintText: "Username"),
                      textAlign: TextAlign.left,
                      autofocus: true,
                      validator: (String? value) {
                        return (value != null && value.length < 2)
                            ? 'Please provide a valid username.'
                            : null;
                      },
                      onChanged: (val) {
                        setState(() => username = val);
                      }),
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
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: InkWell(
                      onTap: showOrHidePasswordToggle,
                      child: Icon(
                        obscureText
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
              signIn == true
                  ? SizedBox(
                      height: 25,
                      child: GestureDetector(
                          child: const Text("I forgot my password"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ResetPasswordScreen()));
                          }),
                    )
                  : Container(),
              SizedBox(
                  width: 300,
                  child: signIn == true ? signInButton() : signUpButton()),
              const SizedBox(height: 20),
              signIn == true
                  ? SizedBox(
                      height: 30,
                      child: GestureDetector(
                          child: const Text("Sign-up using email"),
                          onTap: () {
                            signInSignUpToggle();
                          }),
                    )
                  : SizedBox(
                      height: 30,
                      child: GestureDetector(
                          child: const Text("Go back to sign in"),
                          onTap: () {
                            signInSignUpToggle();
                          }),
                    ),
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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0.0,
          centerTitle: true,
          title: !kIsWeb
              ? signIn
                  ? Consumer<LanguageService>(
                      builder: (context, language, _) =>
                          Text(language.signInScreenAppBarTitle ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )))
                  : Consumer<LanguageService>(
                      builder: (context, language, _) =>
                          Text(language.signUpScreenAppBarTitle ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )))
              : Container(),
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
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 100 - paneProportion,
                    child: Column(
                      children: [
                        const SizedBox(height: 175),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                            child: Consumer<ThemeService>(
                              builder: (context, theme, child) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: theme.darkTheme == true
                                        ? Colors.grey[800]
                                        : Colors.grey[200]),
                                child: signInForm(),
                              ),
                            ))
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
