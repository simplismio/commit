import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Consumer<LanguageService>(
            builder: (context, language, _) =>
                Text(language.resetPasswordScreenAppBarTitle ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
        child: Form(
            key: formKeyForm,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                Consumer<LanguageService>(
                    builder: (context, language, _) => TextFormField(
                        decoration: InputDecoration(
                            hintText:
                                language.resetPasswordScreenEmailPlaceholder),
                        textAlign: TextAlign.left,
                        autofocus: true,
                        validator: (String? value) {
                          //print(value.length);
                          return (value != null && value.length < 2)
                              ? language.resetPasswordScreenEmailErrorMessage
                              : null;
                        },
                        onChanged: (val) {
                          setState(() => email = val);
                        })),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: loading
                        ? const LinearProgressIndicator()
                        : Consumer<LanguageService>(
                            builder: (context, language, _) => Text(
                                language.resetPasswordScreenButtonText ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        UserService().resetPassword(email).then((result) {
                          if (result == null) {
                            Navigator.of(context).maybePop();
                          } else {
                            setState(() => loading = false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Consumer<LanguageService>(
                                  builder: (context, language, _) => Text(
                                        language.genericFirebaseErrorMessage ??
                                            '',
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
                ),
              ],
            )),
      ),
    );
  }
}
