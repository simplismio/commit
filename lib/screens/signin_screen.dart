import 'package:commit/utilities/authorization_utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/user_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
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
          : Consumer<LanguageService>(
              builder: (context, language, _) =>
                  Text(language.signInScreenButtonText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
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
                    builder: (BuildContext context) =>
                        const AuthorizationUtility(),
                  ));
            } else {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Consumer<LanguageService>(
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
    return Consumer<LanguageService>(
        builder: (context, language, _) => ElevatedButton(
              child: loading
                  ? const LinearProgressIndicator()
                  : Text(language.signUpScreenButtonText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
              onPressed: () async {
                if (formKeyForm.currentState!.validate()) {
                  setState(() => loading = true);
                  UserService()
                      .signUpUsingEmailAndPassword(
                          username,
                          email,
                          password,
                          language.welcomeEmailTitle,
                          language.welcomeEmailBody,
                          language.welcomeEmailSignature)
                      .then((result) {
                    if (result == null) {
                      if (mounted) {
                        Navigator.pop(context); // Navigator.push(
                      }
                    } else {
                      setState(() => loading = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Consumer<LanguageService>(
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
                  : Consumer<LanguageService>(
                      builder: (context, language, _) => TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  language.signUpScreenUsernamePlaceholder),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? language.signUpScreenUsernameErrorMessage
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => username = val);
                          })),
              const SizedBox(height: 10),
              Consumer<LanguageService>(
                  builder: (context, language, _) => TextFormField(
                      decoration: InputDecoration(
                          hintText: language.signInUpScreenEmailPlaceholder),
                      textAlign: TextAlign.left,
                      autofocus: true,
                      validator: (String? value) {
                        return (value != null && value.length < 2)
                            ? language.signInUpScreenEmailErrorMessage
                            : null;
                      },
                      onChanged: (val) {
                        setState(() => email = val);
                      })),
              const SizedBox(height: 10),
              Consumer<LanguageService>(
                  builder: (context, language, _) => TextFormField(
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: language.signInUpScreenPasswordPlaceholder,
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
                            ? language.signInUpScreenPasswordErrorMessage
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
                          child: Consumer<LanguageService>(
                              builder: (context, language, _) => Text(
                                  language.signInScreenResetPasswordLink ??
                                      '')),
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
              const SizedBox(height: 10),
              signIn == true
                  ? Consumer<LanguageService>(
                      builder: (context, language, _) => SizedBox(
                            height: 18,
                            child: GestureDetector(
                                child: Text(
                                    language.signInScreenSignUpUsingEmailLink ??
                                        ''),
                                onTap: () {
                                  signInSignUpToggle();
                                }),
                          ))
                  : Consumer<LanguageService>(
                      builder: (context, language, _) => SizedBox(
                            height: 18,
                            child: GestureDetector(
                                child: Text(
                                    language.signInScreengoBackToSignInLink ??
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
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
