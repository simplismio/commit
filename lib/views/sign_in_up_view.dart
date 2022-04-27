import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../helpers/authorization_helper.dart';
import '../models/language_model.dart';
import '../models/theme_model.dart';
import '../models/user_model.dart';
import 'reset_password_view.dart';

/// SignInView view class
class SignInUpView extends StatefulWidget {
  const SignInUpView({Key? key}) : super(key: key);

  @override
  _SignInUpViewState createState() => _SignInUpViewState();
}

/// SignInView view state class
class _SignInUpViewState extends State<SignInUpView> {
  /// Generate unique form key
  final formKeyForm = GlobalKey<FormState>();

  /// Initialize loading bool
  bool loading = false;

  /// Initialize form variable username
  String? username;

  /// Initialize form variable email
  String? email;

  /// Initialize form variable password
  String? password;

  /// Initialize variables to show/hide password
  bool obscureText = true;
  bool signIn = true;

  /// Initialize variables to serve layout for mobile and web layouts
  final double breakpoint = 800;
  final int paneProportion = 60;

  /// Function to toggle password
  void showOrHidePasswordToggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  /// Function to toggle password
  void signInSignUpToggle() {
    setState(() {
      signIn = !signIn;
      (signIn);
    });
  }

  /// Function to load AppBar
  loadAppBar() {
    return AppBar(
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
    );
  }

  /// Load sign in button
  loadSignInButton(language) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: loading
            ? const LinearProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(language.signInViewButtonText ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
        onPressed: () async {
          if (formKeyForm.currentState!.validate()) {
            setState(() => loading = true);
            UserModel()
                .signInUsingEmailAndPassword(email, password)
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
      ),
    );
  }

  /// Load sign un button
  loadSignUpButton(language) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(25.0),
                child: LinearProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(language.signUpViewButtonText ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
        onPressed: () async {
          if (formKeyForm.currentState!.validate()) {
            setState(() => loading = true);
            UserModel()
                .signUpUsingEmailAndPassword(
                    username,
                    email,
                    password,
                    language.welcomeEmailTitle,
                    language.welcomeEmailBody,
                    language.verifyEmailEmailTitle,
                    language.verifyEmailEmailBody)
                .then((result) {
              if (result == null) {
                UserModel().signOut();
                if (mounted) {
                  UserModel().signOut();
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
      ),
    );
  }

  /// Load username text field
  loadUsernameTextField(language) {
    return TextFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
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
        });
  }

  /// Load email text field
  loadEmailTextField(language) {
    return TextFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
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
        });
  }

  /// Load password text field
  loadPasswordTextField(language) {
    return TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: language.signInUpViewPasswordPlaceholder,
          suffixIcon: InkWell(
            onTap: showOrHidePasswordToggle,
            child: Icon(
              obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
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
        });
  }

  /// Load sign in link
  loadSignInLink(language) {
    return SizedBox(
      height: 18,
      child: GestureDetector(
          child: Text(language.signInViewSignUpUsingEmailLink ?? ''),
          onTap: () {
            signInSignUpToggle();
          }),
    );
  }

  /// Load sign un link
  loadSignUpLink(language) {
    return SizedBox(
      height: 18,
      child: GestureDetector(
          child: Text(language.signInViewgoBackToSignInLink ?? ''),
          onTap: () {
            signInSignUpToggle();
          }),
    );
  }

  /// Load password reset link
  loadPasswordResetLink(language) {
    return Text(language.signInViewResetPasswordLink ?? '');
  }

  /// Load sign in form
  loadSignInUpForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
      child: Form(
          key: formKeyForm,
          child: Column(
            children: <Widget>[
              signIn == true
                  ? Container()
                  : Consumer<LanguageModel>(
                      builder: (context, language, _) =>
                          loadUsernameTextField(language)),
              const SizedBox(height: 10),
              Consumer<LanguageModel>(
                  builder: (context, language, _) =>
                      loadEmailTextField(language)),
              const SizedBox(height: 10),
              Consumer<LanguageModel>(
                  builder: (context, language, _) =>
                      loadPasswordTextField(language)),
              const SizedBox(height: 20.0),
              signIn == true
                  ? SizedBox(
                      height: 35,
                      child: GestureDetector(
                          child: Consumer<LanguageModel>(
                              builder: (context, language, _) =>
                                  loadPasswordResetLink(language)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ResetPasswordView()));
                          }),
                    )
                  : Container(),
              Consumer<LanguageModel>(
                  builder: (context, language, _) => SizedBox(
                      width: double.maxFinite,
                      child: signIn == true
                          ? loadSignInButton(language)
                          : loadSignUpButton(language))),
              const SizedBox(height: 30),
              signIn == true
                  ? Consumer<LanguageModel>(
                      builder: (context, language, _) =>
                          loadSignInLink(language))
                  : Consumer<LanguageModel>(
                      builder: (context, language, _) =>
                          loadSignUpLink(language)),
              const SizedBox(height: 10.0),
              // Row(
              //   children: [
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
              //],
              //),
            ],
          )),
    );
  }

  /// Main SignInUp view widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: loadAppBar(),
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
                                child: loadSignInUpForm(),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              )
            : Flex(
                direction: Axis.horizontal,
                children: [Flexible(flex: 100, child: loadSignInUpForm())],
              ));
  }
}
