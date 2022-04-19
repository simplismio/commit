import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/contract_model.dart';
import '../models/language_model.dart';

/// AddCommitmentView view class
class AddCommitmentView extends StatefulWidget {
  final String? contractKey;

  const AddCommitmentView({Key? key, this.contractKey}) : super(key: key);

  @override
  _AddCommitmentViewState createState() => _AddCommitmentViewState();
}

/// AddCommitmentView view state class
class _AddCommitmentViewState extends State<AddCommitmentView> {
  /// Generate unique form key
  final formKeyForm = GlobalKey<FormState>();

  /// Initialize loading bool
  bool loading = false;

  /// Initialize form variable commitment
  String? commitment;

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
              Text(language.newCommitmentViewAppBarTitle ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
      centerTitle: true,
      elevation: 0,
    );
  }

  /// Function to commitment text field
  loadCommitmentTextField(language) {
    return TextFormField(
        decoration: InputDecoration(
            hintText: language.newCommitmentViewCommitmentPlaceholder),
        textAlign: TextAlign.left,
        autofocus: true,
        validator: (String? value) {
          //print(value.length);
          return (value != null && value.length < 2)
              ? language.newCommitmentViewCommitmentErrorMessage
              : null;
        },
        onChanged: (val) {
          setState(() => commitment = val);
        });
  }

  /// Function to load form submit button
  loadFormSubmitButton() {
    ElevatedButton(
      child: loading
          ? const LinearProgressIndicator()
          : Consumer<LanguageModel>(
              builder: (context, language, _) =>
                  Text(language.newCommitmentViewButtonText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);
          ContractModel()
              .addCommitment(widget.contractKey, commitment)
              .then((result) {
            if (result == null) {
              Navigator.of(context).maybePop();
            } else {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Consumer<LanguageModel>(
                    builder: (context, language, _) => Text(
                          language.genericFirebaseErrorMessage ?? '',
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

  /// AddCommitmentView view state class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loadAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
        child: Form(
            key: formKeyForm,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                Consumer<LanguageModel>(
                    builder: (context, language, _) =>
                        loadCommitmentTextField(language)),
                const SizedBox(height: 10.0),
                SizedBox(width: 300, child: loadFormSubmitButton()),
              ],
            )),
      ),
    );
  }
}
