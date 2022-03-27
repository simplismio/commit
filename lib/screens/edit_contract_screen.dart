import 'package:commit/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import 'main_screen.dart';

class EditContractScreen extends StatefulWidget {
  final ContractService? contract;

  const EditContractScreen({Key? key, this.contract}) : super(key: key);

  @override
  _EditContractScreenState createState() => _EditContractScreenState();
}

class _EditContractScreenState extends State<EditContractScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String? title;

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
                TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Edit contract"),
                    textAlign: TextAlign.left,
                    initialValue: widget.contract!.title,
                    autofocus: true,
                    validator: (String? value) {
                      return (value != null && value.length < 2)
                          ? 'Please provide a valid contract.'
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
                            "Edit contract",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService()
                            .editContract(widget.contract!.key, title);
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
                const SizedBox(height: 50),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: const Text(
                      "Delete contract",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService().deleteContract(widget.contract!.key);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (Route<dynamic> route) => false);
                      } else {
                        setState(() {
                          loading = false;
                          error = 'Something went wrong.';
                        });
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
