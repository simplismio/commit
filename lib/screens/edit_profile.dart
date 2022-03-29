import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/media_service.dart';

class EditProfileScreen extends StatefulWidget {
  final currentAvatarLink;
  final currentUserUid;
  final currentUsername;
  EditProfileScreen(
      {Key? key,
      this.currentAvatarLink,
      this.currentUserUid,
      this.currentUsername})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? username;

  @override
  Widget build(BuildContext context) {
    print(widget.currentAvatarLink);
    print(widget.currentUserUid);
    print(widget.currentUsername);

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
                Text(language.editProfileScreenAppBarTitle ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: formKeyForm,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Center(
                    child: SizedBox(
                      height: 150,
                      child: widget.currentAvatarLink == null
                          ? GestureDetector(
                              onTap: () {
                                MediaService.displayPickImageDialog();
                              },
                              child: CircleAvatar(
                                child: ClipRRect(
                                  borderRadius:
                                      new BorderRadius.circular(100.0),
                                  child: Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/commit-b9e29.appspot.com/o/image.jpeg?alt=media&token=3076f6fb-5d7f-461c-9528-94e437ae021f'),
                                ),
                              ),
                            )
                          : const Positioned(
                              top: 20.0,
                              left: 95.0,
                              child: CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person,
                                    size: 60, color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Consumer<LanguageService>(
                      builder: (context, language, _) => TextFormField(
                          decoration: InputDecoration(
                              hintText: language
                                  .editProfileScreenUsernamePlaceholder),
                          textAlign: TextAlign.left,
                          initialValue: widget.currentUsername,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? language.editProfileScreenUsernameErrorMessage
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => username = val);
                          })),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      child: loading
                          ? const LinearProgressIndicator()
                          : Consumer<LanguageService>(
                              builder: (context, language, _) => Text(
                                  language.editProfileScreenButtonText ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                      onPressed: () async {
                        if (formKeyForm.currentState!.validate()) {
                          // setState(() => loading = true);
                          // ContractService().addContract(title).then((result) {
                          //   if (result == null) {
                          //     Navigator.of(context).maybePop();
                          //   } else {
                          //     setState(() => loading = false);
                          //     ScaffoldMessenger.of(context)
                          //         .showSnackBar(SnackBar(
                          //       content: Consumer<LanguageService>(
                          //           builder: (context, language, _) => Text(
                          //                 language.genericFirebaseErrorMessage ??
                          //                     '',
                          //                 style: const TextStyle(
                          //                     color: Colors.white,
                          //                     fontSize: 16,
                          //                     fontWeight: FontWeight.bold),
                          //               )),
                          //       backgroundColor: Colors.grey[800],
                          //     ));
                          //   }
                          // });
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
      ),
    );
  }
}
