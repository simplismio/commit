import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/contract_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';

class AddContractScreen extends StatefulWidget {
  const AddContractScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddContractScreenState createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final formKeyForm = GlobalKey<FormState>();
  TextEditingController participantController = TextEditingController();

  bool loading = false;
  String? title;
  String? participant;
  List participantUids = [];
  List participantUsernames = [];
  List participantEmails = [];
  List<UserModel?> matches = [];
  String? emailParticipant = '';

  _getSuggestions(String query, users) {
    matches = List.from(users);

    for (var i = 0; i < matches.length; i++) {
      if (!matches[i]!.username!.toLowerCase().contains(query)) {
        setState(() {
          matches.removeAt(i);
        });
      }
    }
    for (var i = 0; i < matches.length; i++) {
      if (participantUsernames.contains(matches[i]!.username!)) {
        setState(() {
          matches.removeAt(i);
        });
      }
    }
    if (EmailValidator.validate(query) == true) {
      setState(() {
        emailParticipant = query;
      });
    } else {
      emailParticipant = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel?> users =
        Provider.of<List<UserModel>>(context, listen: false);
    UserModel? user = Provider.of<UserModel?>(context, listen: false);

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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
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
                TextFormField(
                    controller: participantController,
                    decoration: const InputDecoration(
                        hintText: "Participants' username or email"),
                    textAlign: TextAlign.left,
                    autofocus: true,
                    validator: (String? value) {},
                    onChanged: (val) {
                      setState(() {
                        participant = val;
                        _getSuggestions(val.toLowerCase(), users);
                      });
                    }),
                participantUsernames.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                          width: 300,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: participantUsernames.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      participantUids.removeAt(index);
                                      participantUsernames.removeAt(index);
                                      participantEmails.removeAt(index);
                                      participantController.clear();
                                    });
                                  }),
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(3, 5, 3, 0),
                                      child: Consumer<ThemeService>(
                                          builder: (context, theme, child) =>
                                              Chip(
                                                deleteIcon: const Icon(
                                                  Icons.close,
                                                ),
                                                onDeleted: () {
                                                  setState(() {
                                                    participantUids
                                                        .removeAt(index);
                                                    participantUsernames
                                                        .removeAt(index);
                                                    participantEmails
                                                        .removeAt(index);
                                                  });
                                                },
                                                label: Text(
                                                  participantUsernames[index],
                                                ),
                                              ))),
                                );
                              }),
                        ),
                      ),
                (matches.isEmpty || participant == '')
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: SizedBox(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: matches.length,
                              itemBuilder: (BuildContext context, int index) {
                                return matches[index]?.uid == user?.uid
                                    ? Container()
                                    : GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            participantUids
                                                .add(matches[index]?.uid ?? '');
                                            participantUsernames.add(
                                                matches[index]?.username ?? '');
                                            participantEmails.add(
                                                matches[index]?.email ?? '');
                                            matches.removeAt(index);
                                            participantController.clear();
                                          });
                                        }),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Card(
                                            child: ListTile(
                                                title: Text(
                                                    matches[index]?.username ??
                                                        '')),
                                          ),
                                        ),
                                      );
                              }),
                        ),
                      ),
                emailParticipant == ''
                    ? Container()
                    : SizedBox(
                        width: 300,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              participantUsernames.add(emailParticipant);
                              participantUids.add(emailParticipant);
                              participant = '';
                              emailParticipant = '';
                            });
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 18, 3, 18),
                            child: Text(
                              emailParticipant ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )),
                        ),
                      ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 300,
                  child: Consumer<LanguageService>(
                      builder: (context, language, _) => ElevatedButton(
                            child: loading
                                ? const LinearProgressIndicator()
                                : Text(
                                    language.newContractScreenButtonText ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                            onPressed: () async {
                              if (formKeyForm.currentState!.validate()) {
                                setState(() => loading = true);
                                ContractService()
                                    .addContract(
                                        title,
                                        participantUids,
                                        participantEmails,
                                        participantUsernames,
                                        language.addContractEmailTitle,
                                        language.addContractEmailBody)
                                    .then((result) {
                                  if (result == null) {
                                    Navigator.of(context).maybePop();
                                  } else {
                                    setState(() => loading = false);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Consumer<LanguageService>(
                                          builder: (context, language, _) =>
                                              Text(
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
                          )),
                ),
              ],
            )),
      ),
    );
  }
}
