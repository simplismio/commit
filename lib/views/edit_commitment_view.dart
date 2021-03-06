import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/contract_model.dart';
import '../models/language_model.dart';

/// EditCommitmentView view class
class EditCommitmentView extends StatefulWidget {
  final String? contractKey;

  // ignore: prefer_typing_uninitialized_variables
  final commitmentArray;
  final int? commitmentIndex;

  const EditCommitmentView({
    Key? key,
    this.contractKey,
    this.commitmentArray,
    this.commitmentIndex,
  }) : super(key: key);

  @override
  _EditCommitmentViewState createState() => _EditCommitmentViewState();
}

/// EditCommitmentView view state class
class _EditCommitmentViewState extends State<EditCommitmentView> {
  /// Generate unique form key
  final formKeyForm = GlobalKey<FormState>();

  /// Initialize loading bool
  bool loading = false;

  /// Initialize form variable commitment
  String? commitment;

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
              Text(language.editCommitmentViewAppBarTitle ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
      centerTitle: true,
      elevation: 0,
    );
  }

  loadCommitmentTextField(language) {
    return TextFormField(
        decoration: InputDecoration(
            hintText: language.editCommitmentViewCommitmentPlaceholder ?? ''),
        textAlign: TextAlign.left,
        initialValue: widget.commitmentArray[widget.commitmentIndex]
            ['commitment'],
        autofocus: true,
        validator: (String? value) {
          return (value != null && value.length < 2)
              ? language.editCommitmentViewCommitmentErrorMessage
              : null;
        },
        onChanged: (val) {
          setState(() => commitment = val);
        });
  }

  loadFormSubmitButton() {
    return ElevatedButton(
      child: loading
          ? const LinearProgressIndicator()
          : Consumer<LanguageModel>(
              builder: (context, language, _) =>
                  Text(language.editCommitmentViewButtonText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);

          // ignore: prefer_conditional_assignment
          if (commitment == null) {
            commitment =
                widget.commitmentArray[widget.commitmentIndex]['commitment'];
          }

          ContractModel()
              .editCommitment(widget.contractKey, widget.commitmentArray,
                  widget.commitmentIndex, commitment)
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

  /// EditCommitmentView view state class
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
