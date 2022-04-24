import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../models/contract_model.dart';
import '../models/language_model.dart';
import '../models/theme_model.dart';
import '../models/user_model.dart';
import 'package:date_time_picker/date_time_picker.dart';

/// AddCommitmentView view class
class AddCommitmentView extends StatefulWidget {
  /// Initialize class variable contract to widget
  final ContractModel? contract;
  //final String? contractKey;

  const AddCommitmentView({Key? key, this.contract}) : super(key: key);

  @override
  _AddCommitmentViewState createState() => _AddCommitmentViewState();
}

/// AddCommitmentView view state class
class _AddCommitmentViewState extends State<AddCommitmentView> {
  /// Generate unique form key
  final formKeyForm = GlobalKey<FormState>();

  /// Initialize loading bool
  bool loading = false;

  /// Initialize form variable commitment
  String? commitment;

  /// Initialize autocomplete lists and variables
  List<String> participantUids = [];
  List<String> participantUsernames = [];
  List<UserModel?> matches = [];
  String? emailParticipant = '';
  bool matchesAreSetAtStart = false;
  String? counterparty;
  String? proof;
  String? resolution;
  String? counterpartyValue = '...';

  setParticipantsOnStart(users) {
    matches = [];
    List? tempParticipants = widget.contract!.participants;
    tempParticipants?.forEach((item) {
      for (var i = 0; i < users.length; i++) {
        if (users[i]!.uid! == item) {
          if (participantUids.contains(item) == false) {
            participantUids.add(item.toString());
          }
          if (participantUsernames.contains(users[i]!.username!) == false) {
            participantUsernames.add(users[i]!.username!.toString());
          }
        }
        if (EmailValidator.validate(item) == true) {
          if (participantUsernames.contains(item) == false) {
            participantUids.add(item.toString());
            participantUsernames.add(item.toString());
          }
        }
      }
      matchesAreSetAtStart = true;
    });
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
              Text(language.newCommitmentViewAppBarTitle ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
      centerTitle: true,
      elevation: 0,
    );
  }

  loadCounterpartyDropdown(language) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        value: counterparty,
        hint: Text(language.addCommitmentCounterpartyPlaceholder ?? ''),
        onChanged: (value) {
          setState(() {
            counterparty = value as String?;
            counterpartyValue = value;
            if (counterparty == '') {
              counterpartyValue = '...';
            }
            //TODO: find UID and add it to a list
          });
        },
        items: participantUsernames.map(
          (item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          },
        ).toList(),
      ),
    );
  }

  /// Function to commitment text field
  loadCommitmentTextField(language) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: language.newCommitmentViewCommitmentPlaceholder),
          textAlign: TextAlign.left,
          autofocus: true,
          validator: (String? value) {
            //print(value.length);
            return (value != null && value.length < 2)
                ? language.newCommitmentViewCommitmentErrorMessage
                : null;
          },
          onChanged: (val) {
            setState(() {
              commitment = val;
              if (commitment == '') {
                commitment = "...";
              }
            });
          }),
    );
  }

  loadDateRangePicker() {
    return SizedBox(
      width: double.infinity,
      child: DateTimePicker(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        type: DateTimePickerType.dateTimeSeparate,
        dateMask: 'd MMM, yyyy',
        initialValue: DateTime.now().toString(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        dateLabelText: 'Date',
        timeLabelText: "Hour",
        selectableDayPredicate: (date) {
          // Disable weekend days to select from the calendar
          if (date.weekday == 6 || date.weekday == 7) {
            return false;
          }

          return true;
        },
        onChanged: (val) => print(val),
        validator: (val) {
          print(val);
          return null;
        },
        onSaved: (val) => print(val),
      ),
    );
  }

  loadProofsDropdown(language) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        value: proof,
        hint: Text(language.addCommitmentProofPlaceholder ?? ''),
        onChanged: (value) {
          setState(() {
            proof = value as String?;
            counterpartyValue = value;
            if (proof == '') {
              counterpartyValue = '...';
            }
            //TODO: find UID and add it to a list
          });
        },
        items: language.addEditCommitmentProofDropdownList.map(
          (item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          },
        ).toList(),
      ),
    );
  }

  loadResolutionDropdown(language) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        value: resolution,
        hint: Text(language.addCommitmentResolutionPlaceholder ?? ''),
        onChanged: (value) {
          setState(() {
            resolution = value as String?;

            //TODO: find UID and add it to a list
          });
        },
        items: language.addEditCommitmentResolutionDropdownList.map(
          (item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          },
        ).toList(),
      ),
    );
  }

  /// Function to load commitment summary
  loadCommitmentSummary(language) {
    return SizedBox(
        width: double.infinity,
        child: Consumer<ThemeModel>(
            builder: (context, theme, child) => Container(
                color: theme.darkTheme == true
                    ? Colors.grey[800]
                    : Colors.grey[300],
                child: counterparty == null && commitment == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            const Text('Commitment Summary',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 25),
                            Text(
                              'Ik beloof $counterpartyValue om $commitment',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ))));
  }

  /// Function to load form submit button
  loadFormSubmitButton(language) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: loading
            ? const LinearProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(language.newCommitmentViewButtonText ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
        onPressed: () async {
          if (formKeyForm.currentState!.validate()) {
            setState(() => loading = true);
            ContractModel()
                .addCommitment(widget.contract!.key, commitment)
                .then((result) {
              if (result == null) {
                Navigator.of(context).maybePop();
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
      ),
    );
  }

  /// AddCommitmentView view state class
  @override
  Widget build(BuildContext context) {
    List<UserModel?> users =
        Provider.of<List<UserModel>>(context, listen: false);

    if (matchesAreSetAtStart == false) {
      setParticipantsOnStart(users);
    }
    commitment = commitment ?? '...';

    return Scaffold(
      appBar: loadAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 15.0),
                      Consumer<LanguageModel>(
                          builder: (context, language, _) =>
                              loadCounterpartyDropdown(language)),
                      const SizedBox(height: 15.0),
                      Consumer<LanguageModel>(
                          builder: (context, language, _) =>
                              loadCommitmentTextField(language)),
                      const SizedBox(height: 15.0),
                      loadDateRangePicker(),
                      const SizedBox(height: 15.0),
                      Consumer<LanguageModel>(
                          builder: (context, language, child) =>
                              loadProofsDropdown(language)),
                      const SizedBox(height: 15.0),
                      Consumer<LanguageModel>(
                          builder: (context, language, child) =>
                              loadResolutionDropdown(language)),
                      const SizedBox(height: 20),
                      Consumer<LanguageModel>(
                          builder: (context, language, _) =>
                              loadCommitmentSummary(language)),
                      const SizedBox(height: 20.0),
                      Consumer<LanguageModel>(
                          builder: (context, language, _) =>
                              loadFormSubmitButton(language)),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
