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
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;

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
            key: _formKeyForm,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                TextFormField(
                    decoration: const InputDecoration(hintText: "Title"),
                    textAlign: TextAlign.left,
                    autofocus: true,
                    validator: (String? value) {
                      //print(value.length);
                      return (value != null && value.length < 2)
                          ? 'Please provide a valid contract title.'
                          : null;
                    },
                    onChanged: (val) {
                      setState(() => title = val);
                    }),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: loading
                        ? const LinearProgressIndicator()
                        : const Text(
                            "Add contract",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    onPressed: () async {
                      if (_formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService().addContract(title);
                        Navigator.pop(context);
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
