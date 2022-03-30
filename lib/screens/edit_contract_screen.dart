import 'package:commit/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditContractScreen extends StatefulWidget {
  final ContractService? contract;

  const EditContractScreen({Key? key, this.contract}) : super(key: key);

  @override
  _EditContractScreenState createState() => _EditContractScreenState();
}

class _EditContractScreenState extends State<EditContractScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? title;

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
                Text(language.editContractScreenAppBarTitle ?? '',
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
                                .editContractScreenContractTitlePlaceholder),
                        textAlign: TextAlign.left,
                        initialValue: widget.contract!.title,
                        autofocus: true,
                        validator: (String? value) {
                          return (value != null && value.length < 2)
                              ? language
                                  .editContractScreenContractTitleErrorMessage
                              : null;
                        },
                        onChanged: (val) {
                          setState(() => title = val);
                        })),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: loading
                        ? const LinearProgressIndicator()
                        : Consumer<LanguageService>(
                            builder: (context, language, _) => Text(
                                language.editContractScreenButtonText ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService()
                            .editContract(widget.contract!.key, title)
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
                                            fontWeight: FontWeight.bold),
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
                const SizedBox(height: 50),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: Consumer<LanguageService>(
                        builder: (context, language, _) => Text(
                              language.editContractScreenDeleteContractButtonText ??
                                  '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService()
                            .deleteContract(widget.contract!.key)
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
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
