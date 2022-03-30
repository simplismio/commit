import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/media_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final currentAvatarLink;
  final currentUserUid;
  final currentUsername;
  final currentUserEmail;
  EditProfileScreen(
      {Key? key,
      this.currentAvatarLink,
      this.currentUserUid,
      this.currentUsername,
      this.currentUserEmail})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? username;
  String? email;

  @override
  Widget build(BuildContext context) {
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
                    child: Consumer<MediaService>(
                        builder: (context, media, child) => SizedBox(
                              height: 150,
                              child: widget.currentAvatarLink == null
                                  ? GestureDetector(
                                      onTap: () {
                                        media.previewNewProfilePhoto();
                                      },
                                      child: CircleAvatar(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.file(
                                              media.newProfilePhotoUrl ??
                                                  File('')),
                                        ),
                                      ),
                                    )
                                  : const Positioned(
                                      top: 20.0,
                                      left: 95.0,
                                      child: CircleAvatar(
                                          radius: 50,
                                          child: FaIcon(FontAwesomeIcons.user,
                                              size: 60, color: Colors.grey)),
                                    ),
                            )),
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
                  const SizedBox(height: 20.0),
                  Consumer<LanguageService>(
                      builder: (context, language, _) => TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  language.editProfileScreenEmailPlaceholder),
                          textAlign: TextAlign.left,
                          initialValue: widget.currentUserEmail,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? language.editProfileScreenUsernameErrorMessage
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => email = val);
                          })),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 300,
                    child: Consumer<MediaService>(
                        builder: (context, media, child) => ElevatedButton(
                              child: loading
                                  ? const LinearProgressIndicator()
                                  : Consumer<LanguageService>(
                                      builder: (context, language, _) => Text(
                                          language.editProfileScreenButtonText ??
                                              '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ))),
                              onPressed: () async {
                                if (formKeyForm.currentState!.validate()) {
                                  setState(() => loading = true);
                                  UserService()
                                      .updateUserProfile(
                                          media.newProfilePhotoUrl,
                                          username,
                                          email)
                                      .then((result) {
                                    if (result == null) {
                                      media.newProfilePhotoUrl = null;
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
      ),
    );
  }
}
