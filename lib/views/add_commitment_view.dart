import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/contract_model.dart';
import '../models/language_model.dart';

class AddCommitmentView extends StatefulWidget {
  final String? contractKey;

  const AddCommitmentView({Key? key, this.contractKey}) : super(key: key);

  @override
  _AddCommitmentViewState createState() => _AddCommitmentViewState();
}

class _AddCommitmentViewState extends State<AddCommitmentView> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? commitment;

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
        title: Consumer<LanguageModel>(
            builder: (context, language, _) =>
                Text(language.newCommitmentViewAppBarTitle ?? '',
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
                Consumer<LanguageModel>(
                    builder: (context, language, _) => TextFormField(
                        decoration: InputDecoration(
                            hintText: language
                                .newCommitmentViewCommitmentPlaceholder),
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
                        })),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
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
