import 'package:flutter/material.dart';
import '../services/contract_service.dart';
import 'package:provider/provider.dart';

import '../services/language_service.dart';

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({Key? key}) : super(key: key);

  @override
  _NewContractScreenState createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? title;
  String? commitment;

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
                Text(language.newContractScreenAppBarTitle ?? '',
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
                                .newContractScreenContractTitlePlaceholder),
                        textAlign: TextAlign.left,
                        autofocus: true,
                        validator: (String? value) {
                          //print(value.length);
                          return (value != null && value.length < 2)
                              ? language
                                  .newContractScreenContractTitleErrorMessage
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
                            builder: (context, language, _) =>
                                Text(language.newContractScreenButtonText ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ))),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService().addContract(title).then((result) {
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
                        setState(() {
                          loading = false;
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
