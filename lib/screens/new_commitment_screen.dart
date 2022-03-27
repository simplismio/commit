import 'package:flutter/material.dart';
import '../services/contract_service.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';

class NewCommitmentScreen extends StatefulWidget {
  final String? contractKey;
  const NewCommitmentScreen({Key? key, this.contractKey}) : super(key: key);

  @override
  _NewCommitmentScreenState createState() => _NewCommitmentScreenState();
}

class _NewCommitmentScreenState extends State<NewCommitmentScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;
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
                Text(language.newCommitmentScreenAppBarTitle ?? '',
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
                        const InputDecoration(hintText: "New commitment"),
                    textAlign: TextAlign.left,
                    autofocus: true,
                    validator: (String? value) {
                      //print(value.length);
                      return (value != null && value.length < 2)
                          ? 'Please provide a valid contract title.'
                          : null;
                    },
                    onChanged: (val) {
                      setState(() => commitment = val);
                    }),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: loading
                        ? const LinearProgressIndicator()
                        : const Text(
                            "Add commitment",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    onPressed: () async {
                      if (formKeyForm.currentState!.validate()) {
                        setState(() => loading = true);
                        ContractService()
                            .addCommitment(widget.contractKey, commitment);
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
