import 'package:commit/views/main_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/contract_model.dart';
import '../models/language_model.dart';
import '../models/theme_model.dart';
import '../models/user_model.dart';

/// AddContractView view class
class AddContractView extends StatefulWidget {
  const AddContractView({
    Key? key,
  }) : super(key: key);

  @override
  _AddContractViewState createState() => _AddContractViewState();
}

/// AddContractView view state class
class _AddContractViewState extends State<AddContractView> {
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
  List participantEmails = [];
  List<UserModel?> matches = [];
  String? emailParticipant = '';

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

  /// Function to load AppBar
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
              Text(language.newContractViewAppBarTitle.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
      centerTitle: true,
      elevation: 0,
    );
  }

  /// Function to load title text field
  loadTitleTextField(language) {
    return TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
        ],
        decoration: InputDecoration(
            hintText: language.newContractViewContractTitlePlaceholder),
        textAlign: TextAlign.left,
        autofocus: true,
        validator: (String? value) {
          //print(value.length);
          return (value != null && value.length < 2)
              ? language.newContractViewContractTitleErrorMessage
              : null;
        },
        onChanged: (val) {
          setState(() => title = val);
        });
  }

  /// Function to load participant text field
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

  /// Function to load autocomplete username matches
  loadAutoCompleteUsernameMatches() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: SizedBox(
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
                    padding: const EdgeInsets.fromLTRB(3, 5, 3, 0),
                    child: Consumer<ThemeModel>(
                        builder: (context, theme, child) => Chip(
                              deleteIcon: const Icon(
                                Icons.close,
                              ),
                              onDeleted: () {
                                setState(() {
                                  participantUids.removeAt(index);
                                  participantUsernames.removeAt(index);
                                  participantEmails.removeAt(index);
                                });
                              },
                              label: Text(
                                participantUsernames[index],
                              ),
                            ))),
              );
            }),
      ),
    );
  }

  /// Function to load autocomplete participants
  loadAutoCompleteParticipants(user) {
    return Padding(
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
                          participantUids.add(matches[index]?.uid ?? '');
                          participantUsernames
                              .add(matches[index]?.username ?? '');
                          participantEmails.add(matches[index]?.email ?? '');
                          matches.removeAt(index);
                          participantController.clear();
                        });
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          child: ListTile(
                              title: Text(matches[index]?.username ?? '')),
                        ),
                      ),
                    );
            }),
      ),
    );
  }

  /// Function to load autocomplete email matches
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

  // Function to load form submit button
  loadFormSubmitButton(language) {
    return ElevatedButton(
      child: loading
          ? const LinearProgressIndicator()
          : Text(language.newContractViewButtonText ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
      onPressed: () async {
        if (formKeyForm.currentState!.validate()) {
          setState(() => loading = true);
          ContractModel()
              .addContract(
                  title,
                  participantUids,
                  participantEmails,
                  participantUsernames,
                  language.addContractEmailTitle,
                  language.addContractEmailBody)
              .then((result) {
            if (result == null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MainView(),
                  ));
            } else {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  language.genericFirebaseErrorMessage ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
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

  /// AddContractView view state class
  @override
  Widget build(BuildContext context) {
    List<UserModel?> users =
        Provider.of<List<UserModel>>(context, listen: false);
    UserModel? user = Provider.of<UserModel?>(context, listen: false);
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
                    : loadAutoCompleteUsernameMatches(),
                (matches.isEmpty || participant == '')
                    ? Container()
                    : loadAutoCompleteParticipants(user),
                emailParticipant == ''
                    ? Container()
                    : loadAutoCompleteEmailMatches(),
                const SizedBox(height: 5),
                SizedBox(
                  width: 300,
                  child: Consumer<LanguageModel>(
                      builder: (context, language, _) =>
                          loadFormSubmitButton(language)),
                ),
              ],
            )),
      ),
    );
  }
}
