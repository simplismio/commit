import 'package:flutter/material.dart';
import '../services/contract_service.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditCommitmentScreen extends StatefulWidget {
  final String? contractKey;
  // ignore: prefer_typing_uninitialized_variables
  final commitmentArray;
  final int? commitmentIndex;

  const EditCommitmentScreen({
    Key? key,
    this.contractKey,
    this.commitmentArray,
    this.commitmentIndex,
  }) : super(key: key);

  @override
  _EditCommitmentScreenState createState() => _EditCommitmentScreenState();
}

class _EditCommitmentScreenState extends State<EditCommitmentScreen> {
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
        title: Consumer<LanguageService>(
            builder: (context, language, _) =>
                Text(language.editCommitmentScreenAppBarTitle ?? '',
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
                            hintText: language
                                    .editCommitmentScreenCommitmentPlaceholder ??
                                ''),
                        textAlign: TextAlign.left,
                        initialValue:
                            widget.commitmentArray[widget.commitmentIndex]
                                ['commitment'],
                        autofocus: true,
                        validator: (String? value) {
                          return (value != null && value.length < 2)
                              ? language
                                  .editCommitmentScreenCommitmentErrorMessage
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
                        : Consumer<LanguageService>(
                            builder: (context, language, _) => Text(
                                language.editCommitmentScreenButtonText ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService()
                            .editCommitment(
                                widget.contractKey,
                                widget.commitmentArray,
                                widget.commitmentIndex,
                                commitment)
                            .then((result) {
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
