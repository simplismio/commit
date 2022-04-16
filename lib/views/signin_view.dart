import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../helpers/authorization_helper.dart';
import '../models/language_model.dart';
import '../models/theme_model.dart';
import '../models/user_model.dart';
import 'reset_password_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;

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
          : Consumer<LanguageModel>(
              builder: (context, language, _) =>
                  Text(language.signInViewButtonText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);
          UserModel()
              .signInUsingEmailAndPassword(email, password)
              .then((result) {
            if (result == null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AuthorizationHelper(),
                  ));
            } else {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Consumer<LanguageModel>(
                    builder: (context, language, _) => Text(
                          language.genericAuthErrorMessage ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        )),
                backgroundColor: Colors.grey[800],
              ));
            }
          });
        } else {
          setState(() => loading = false);
        }
      },
    );
  }

  signUpButton() {
    return Consumer<LanguageModel>(
        builder: (context, language, _) => ElevatedButton(
              child: loading
                  ? const LinearProgressIndicator()
                  : Text(language.signUpViewButtonText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
              onPressed: () async {
                if (formKeyForm.currentState!.validate()) {
                  setState(() => loading = true);
                  UserModel()
                      .signUpUsingEmailAndPassword(username, email, password,
                          language.welcomeEmailTitle, language.welcomeEmailBody)
                      .then((result) {
                    if (result == null) {
                      if (mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const AuthorizationHelper(),
                            ));
                      }
                    } else {
                      setState(() => loading = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Consumer<LanguageModel>(
                            builder: (context, language, _) => Text(
                                  language.genericAuthErrorMessage ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                        backgroundColor: Colors.grey[800],
                      ));
                    }
                  });
                } else {
                  setState(() => loading = false);
                }
              },
            ));
  }

  signInForm() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
          key: formKeyForm,
          child: Column(
            children: <Widget>[
              signIn == true
                  ? Container()
                  : Consumer<LanguageModel>(
                      builder: (context, language, _) => TextFormField(
                          decoration: InputDecoration(
                              hintText: language.signUpViewUsernamePlaceholder),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? language.signUpViewUsernameErrorMessage
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => username = val);
                          })),
              const SizedBox(height: 10),
              Consumer<LanguageModel>(
                  builder: (context, language, _) => TextFormField(
                      decoration: InputDecoration(
                          hintText: language.signInUpViewEmailPlaceholder),
                      textAlign: TextAlign.left,
                      autofocus: true,
                      validator: (String? value) {
                        return (value != null && value.length < 2)
                            ? language.signInUpViewEmailErrorMessage
                            : null;
                      },
                      onChanged: (val) {
                        setState(() => email = val);
                      })),
              const SizedBox(height: 10),
              Consumer<LanguageModel>(
                  builder: (context, language, _) => TextFormField(
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: language.signInUpViewPasswordPlaceholder,
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
                            ? language.signInUpViewPasswordErrorMessage
                            : null;
                      },
                      onChanged: (val) {
                        setState(() => password = val);
                      })),
              const SizedBox(height: 20.0),
              signIn == true
                  ? SizedBox(
                      height: 25,
                      child: GestureDetector(
                          child: Consumer<LanguageModel>(
                              builder: (context, language, _) => Text(
                                  language.signInViewResetPasswordLink ?? '')),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ResetPasswordView()));
                          }),
                    )
                  : Container(),
              SizedBox(
                  width: 300,
                  child: signIn == true ? signInButton() : signUpButton()),
              const SizedBox(height: 10),
              signIn == true
                  ? Consumer<LanguageModel>(
                      builder: (context, language, _) => SizedBox(
                            height: 18,
                            child: GestureDetector(
                                child: Text(
                                    language.signInViewSignUpUsingEmailLink ??
                                        ''),
                                onTap: () {
                                  signInSignUpToggle();
                                }),
                          ))
                  : Consumer<LanguageModel>(
                      builder: (context, language, _) => SizedBox(
                            height: 18,
                            child: GestureDetector(
                                child: Text(
                                    language.signInViewgoBackToSignInLink ??
                                        ''),
                                onTap: () {
                                  signInSignUpToggle();
                                }),
                          )),
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
                  //         UserModel()
                  //             .signInWithFacebook()
                  //             .then((result) {});
                  //       }),
                  //   const Spacer(),
                  //   IconButton(
                  //       icon: const FaIcon(FontAwesomeIcons.google),
                  //       onPressed: () {
                  //         setState(() => loading = true);
                  //         UserModel()
                  //             .signInWithGoogle()
                  //             .then((result) {});
                  //       }),
                  //   (Platform.isIOS) ? const Spacer() : Container(),
                  //   (kIsWeb || Platform.isIOS)
                  //       ? IconButton(
                  //           icon: const FaIcon(FontAwesomeIcons.apple),
                  //           onPressed: () {
                  //             setState(() => loading = true);
                  //             UserModel()
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
                  ? Consumer<LanguageModel>(
                      builder: (context, language, _) =>
                          Text(language.signInViewAppBarTitle ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )))
                  : Consumer<LanguageModel>(
                      builder: (context, language, _) =>
                          Text(language.signUpViewAppBarTitle ?? '',
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
                            child: Consumer<ThemeModel>(
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
