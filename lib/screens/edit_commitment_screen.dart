import 'package:flutter/material.dart';

import '../services/contract_service.dart';

class EditCommitmentScreen extends StatefulWidget {
  final String? currentDescription;
  final int? commitmentKey;

  const EditCommitmentScreen(
      {Key? key, this.commitmentKey, this.currentDescription})
      : super(key: key);

  @override
  _EditCommitmentScreenState createState() => _EditCommitmentScreenState();
}

class _EditCommitmentScreenState extends State<EditCommitmentScreen> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String? description;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
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
              title: const Text('Edit Commitment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
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
                          decoration: const InputDecoration(
                              hintText: "Edit commitment"),
                          textAlign: TextAlign.left,
                          initialValue: widget.currentDescription,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid commitment.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => description = val);
                          }),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Edit commitment",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              ContractService().editCommitment(
                                  widget.commitmentKey, description);
                              //Navigator.pop(context);
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
