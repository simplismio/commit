import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart';

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
              icon: const Icon(
                Icons.chevron_left,
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
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: loading
                        ? const LinearProgressIndicator()
                        : const Text(
                            "Reset password",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        UserService().resetPassword(email).then((result) {
                          if (result == null) {
                            // Navigator.pop(context);
                          } else {
                            setState(() => loading = false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
              ],
            )),
      ),
    );
  }
}
