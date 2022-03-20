import 'package:flutter/material.dart';

class EditContractScreen extends StatefulWidget {
  final List? contract;

  const EditContractScreen({Key? key, this.contract}) : super(key: key);

  @override
  _EditContractScreenState createState() => _EditContractScreenState();
}

class _EditContractScreenState extends State<EditContractScreen> {
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
              title: const Text('Edit Contract',
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
                      // TextFormField(
                      //     decoration: const InputDecoration(
                      //         hintText: "Edit commitment"),
                      //     textAlign: TextAlign.left,
                      //     initialValue: widget.contract,
                      //     autofocus: true,
                      //     validator: (String? value) {
                      //       return (value != null && value.length < 2)
                      //           ? 'Please provide a valid commitment.'
                      //           : null;
                      //     },
                      //     onChanged: (val) {
                      //       setState(() => description = val);
                      //     }),
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
                              // DataService().editContract(
                              //     widget.contractKey, description);
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
