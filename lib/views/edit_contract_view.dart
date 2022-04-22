import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import '../models/contract_model.dart';
import '../models/language_model.dart';
import '../models/theme_model.dart';
import '../models/user_model.dart';

/// EditContractView view class
class EditContractView extends StatefulWidget {
  /// Initialize class variable contract to widget
  final ContractModel? contract;

  /// Constructor to load contract variable from MainView
  const EditContractView({Key? key, this.contract}) : super(key: key);

  @override
  _EditContractViewState createState() => _EditContractViewState();
}

/// EditContractView view state class
class _EditContractViewState extends State<EditContractView> {
  /// Generate unique form key
  final formKeyForm = GlobalKey<FormState>();

  /// Initialize text editing controller to empty form fields from code
  TextEditingController participantController = TextEditingController();

  /// Initialize loading bool
  bool loading = false;

  /// Initialize form variable title
  String? title;

  /// Initialize form variable participant
  String? participant;

  /// Initialize autocomplete lists and variables
  List participantUids = [];
  List participantUsernames = [];
  List<UserModel?> matches = [];
  String? emailParticipant = '';
  bool matchesAreSetAtStart = false;

  /// Function to return suggestions to the autocomplete participant field
  getSuggestions(String query, users) {
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

  /// Function to set contract participants Uid and Username lists
  setParticipantsOnStart(users) {
    matches = [];
    List? tempParticipants = widget.contract!.participants;
    tempParticipants?.forEach((item) {
      for (var i = 0; i < users.length; i++) {
        if (users[i]!.uid! == item) {
          if (participantUids.contains(item) == false) {
            participantUids.add(item);
          }
          if (participantUsernames.contains(users[i]!.username!) == false) {
            participantUsernames.add(users[i]!.username!);
          }
        }
        if (EmailValidator.validate(item) == true) {
          if (participantUsernames.contains(item) == false) {
            participantUids.add(item);
            participantUsernames.add(item);
          }
        }
      }
      matchesAreSetAtStart = true;
    });
  }

  /// Load AppBar
  loadAppBar() {
    return AppBar(
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
              Text(language.editContractViewAppBarTitle ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
      centerTitle: true,
      elevation: 0,
    );
  }

  loadTitleTextField(language) {
    return TextFormField(
        decoration: InputDecoration(
            hintText: language.editContractViewContractTitlePlaceholder),
        textAlign: TextAlign.left,
        initialValue: widget.contract!.title,
        autofocus: true,
        validator: (String? value) {
          return (value != null && value.length < 2)
              ? language.editContractViewContractTitleErrorMessage
              : null;
        },
        onChanged: (val) {
          setState(() => title = val);
        });
  }

  loadParticipantTextField(users) {
    return TextFormField(
        controller: participantController,
        decoration:
            const InputDecoration(hintText: "Participants' username or email"),
        textAlign: TextAlign.left,
        autofocus: true,
        onChanged: (val) {
          setState(() {
            participant = val;
            getSuggestions(val.toLowerCase(), users);
          });
        });
  }

  loadAutoCompleteUsernameMatches(user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: SizedBox(
        width: 300,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: participantUsernames.length,
            itemBuilder: (BuildContext context, int participantIndex) {
              return participantUsernames[participantIndex] == user!.username
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(3, 5, 3, 0),
                      child: Consumer<ThemeModel>(
                          builder: (context, theme, child) => Chip(
                                deleteIcon: const Icon(
                                  Icons.close,
                                ),
                                onDeleted: () {
                                  setState(() {
                                    participantUids.removeAt(participantIndex);
                                    participantUsernames
                                        .removeAt(participantIndex);
                                  });
                                },
                                label: Text(
                                  participantUsernames[participantIndex],
                                ),
                              )));
            }),
      ),
    );
  }

  loadAutoCompleteParticipants(user) {
    Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: SizedBox(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: matches.length,
            itemBuilder: (BuildContext context, int matchesIndex) {
              return matches[matchesIndex]?.uid == user?.uid
                  ? Container()
                  : GestureDetector(
                      onTap: (() {
                        setState(() {
                          participantUids.add(matches[matchesIndex]?.uid ?? '');
                          participantUsernames
                              .add(matches[matchesIndex]?.username ?? '');
                          matches.removeAt(matchesIndex);
                          participantController.clear();
                        });
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          child: ListTile(
                              title:
                                  Text(matches[matchesIndex]!.username ?? '')),
                        ),
                      ),
                    );
            }),
      ),
    );
  }

  loadAutoCompleteEmailMatches() {
    return SizedBox(
      width: 300,
      child: GestureDetector(
        onTap: () {
          setState(() {
            participantUsernames.add(emailParticipant);
            participantUids.add(emailParticipant);
            participant = '';
            emailParticipant = '';
            participantController.clear();
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
    );
  }

  loadFormSubmitButton() {
    return ElevatedButton(
      child: loading
          ? const LinearProgressIndicator()
          : Consumer<LanguageModel>(
              builder: (context, language, _) =>
                  Text(language.editContractViewButtonText ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);

          // ignore: prefer_conditional_assignment
          if (title == null) {
            title = widget.contract!.title;
          }

          ContractModel()
              .editContract(widget.contract!.key, title, participantUids)
              .then((result) {
            if (result == null) {
              Navigator.of(context).maybePop();
            } else {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Consumer<LanguageModel>(
                    builder: (context, language, _) => Text(
                          language.genericFirebaseErrorMessage ?? '',
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
    );
  }

  loadContractDeleteButton() {
    return ElevatedButton(
      child: Consumer<LanguageModel>(
          builder: (context, language, _) => Text(
                language.editContractViewDeleteContractButtonText ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);

          ContractModel().deleteContract(widget.contract!.key).then((result) {
            if (result == null) {
              Navigator.of(context).maybePop();
            } else {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Consumer<LanguageModel>(
                    builder: (context, language, _) => Text(
                          language.genericFirebaseErrorMessage ?? '',
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
          textStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  /// EditContractView view state class
  @override
  Widget build(BuildContext context) {
    List<UserModel?> users =
        Provider.of<List<UserModel>>(context, listen: false);
    UserModel? user = Provider.of<UserModel?>(context, listen: false);

    if (matchesAreSetAtStart == false) {
      setParticipantsOnStart(users);
    }

    return Scaffold(
      appBar: loadAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
        child: Form(
            key: formKeyForm,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                Consumer<LanguageModel>(
                    builder: (context, language, _) =>
                        loadTitleTextField(language)),
                const SizedBox(height: 10.0),
                loadParticipantTextField(users),
                participantUsernames.isEmpty
                    ? Container()
                    : loadAutoCompleteUsernameMatches(user),
                (matches.isEmpty || participant == '')
                    ? Container()
                    : loadAutoCompleteParticipants(user),
                emailParticipant == ''
                    ? Container()
                    : loadAutoCompleteEmailMatches(),
                const SizedBox(height: 5),
                SizedBox(width: 300, child: loadFormSubmitButton()),
                const SizedBox(height: 50),
                SizedBox(width: 300, child: loadContractDeleteButton()),
              ],
            )),
      ),
    );
  }
}
