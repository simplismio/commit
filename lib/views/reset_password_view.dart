import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/language_model.dart';
import '../models/user_model.dart';

/// ResetPasswordView view class
class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  /// Generate unique form key
  final formKeyForm = GlobalKey<FormState>();

  /// Initialize loading bool
  bool loading = false;

  /// Initialize form variable email
  String? email;

  /// Function to load AppBar
  loadAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
      title: Consumer<LanguageModel>(
          builder: (context, language, _) =>
              Text(language.resetPasswordViewAppBarTitle ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
      centerTitle: true,
      elevation: 0,
    );
  }

  /// Function to load email text field
  loadEmailTextField(language) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: language.resetPasswordViewEmailPlaceholder),
          textAlign: TextAlign.left,
          autofocus: true,
          validator: (String? value) {
            //print(value.length);
            return (value != null && value.length < 2)
                ? language.resetPasswordViewEmailErrorMessage
                : null;
          },
          onChanged: (val) {
            setState(() => email = val);
          }),
    );
  }

  /// Function to load form submit button
  loadFormSubmitButton(language) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: loading
            ? const LinearProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(language.resetPasswordViewButtonText ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
        onPressed: () async {
          if (formKeyForm.currentState!.validate()) {
            setState(() => loading = true);
            // UserModel()
            //     .resetPasswordWhileSignedIn(email, language.resetPasswordEmailTitle,
            //         language.resetPasswordEmailBody)
            UserModel().resetPasswordWhileNotSignedIn(email).then((result) {
              if (result == null) {
                Navigator.of(context).maybePop();
              } else {
                setState(() => loading = false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    language.genericFirebaseErrorMessage ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
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

  /// Main ResetPasswordView view widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loadAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Form(
            key: formKeyForm,
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                Consumer<LanguageModel>(
                    builder: (context, language, _) =>
                        loadEmailTextField(language)),
                const SizedBox(height: 20.0),
                Consumer<LanguageModel>(
                    builder: (context, language, _) =>
                        loadFormSubmitButton(language)),
              ],
            )),
      ),
    );
  }
}
