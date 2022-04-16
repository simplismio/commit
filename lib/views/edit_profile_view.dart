import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/language_model.dart';
import '../models/media_model.dart';
import '../models/user_model.dart';

class EditProfileView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final currentAvatarLink;

  // ignore: prefer_typing_uninitialized_variables
  final currentUserUid;

  // ignore: prefer_typing_uninitialized_variables
  final currentUsername;

  // ignore: prefer_typing_uninitialized_variables
  final currentUserEmail;

  const EditProfileView(
      {Key? key,
      this.currentAvatarLink,
      this.currentUserUid,
      this.currentUsername,
      this.currentUserEmail})
      : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
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
        title: Consumer<LanguageModel>(
            builder: (context, language, _) =>
                Text(language.editProfileViewAppBarTitle ?? '',
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
                    child: Consumer<MediaModel>(
                        builder: (context, media, _) => Column(
                              children: [
                                widget.currentAvatarLink == null
                                    ? GestureDetector(
                                        onTap: () {
                                          kIsWeb
                                              ? media.previewNewAvatar('camera')
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content: Row(
                                                    children: [
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .camera,
                                                        ),
                                                        onPressed: () {
                                                          media
                                                              .previewNewAvatar(
                                                                  'camera');
                                                        },
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .photoFilm,
                                                        ),
                                                        onPressed: () {
                                                          media
                                                              .previewNewAvatar(
                                                                  'gallery');
                                                        },
                                                      ),
                                                      const Spacer()
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.grey[800],
                                                ));
                                          //media.previewNewProfilePhoto('camera');
                                        },
                                        child: media.newAvatarUrlMobile == null
                                            ? CircularProfileAvatar(
                                                '',
                                                child: const CircleAvatar(
                                                    radius: 50,
                                                    child: FaIcon(
                                                        FontAwesomeIcons.user,
                                                        size: 60,
                                                        color: Colors.grey)),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                placeHolder: (context, url) =>
                                                    const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                radius: 50,
                                                borderWidth: 2,
                                                borderColor: Colors.grey,
                                                elevation: 10,
                                                backgroundColor:
                                                    Colors.transparent,
                                                imageFit: BoxFit.fill,
                                                cacheImage: true,
                                              )
                                            : kIsWeb
                                                ? CircularProfileAvatar(
                                                    media.newAvatarUrlWeb,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    placeHolder:
                                                        (context, url) =>
                                                            const SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    radius: 50,
                                                    borderWidth: 2,
                                                    borderColor: Colors.grey,
                                                    elevation: 10,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    imageFit: BoxFit.fill,
                                                    cacheImage: true,
                                                  )
                                                : CircularProfileAvatar(
                                                    '',
                                                    child: getImageFile(media
                                                        .newAvatarUrlMobile),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    placeHolder:
                                                        (context, url) =>
                                                            const SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    radius: 50,
                                                    borderWidth: 2,
                                                    borderColor: Colors.grey,
                                                    elevation: 10,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    imageFit: BoxFit.fill,
                                                    cacheImage: true,
                                                  ))
                                    : GestureDetector(
                                        onTap: () {
                                          kIsWeb
                                              ? media.previewNewAvatar('camera')
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content: Row(
                                                    children: [
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .camera,
                                                        ),
                                                        onPressed: () {
                                                          media
                                                              .previewNewAvatar(
                                                                  'camera');
                                                        },
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .photoFilm,
                                                        ),
                                                        onPressed: () {
                                                          media
                                                              .previewNewAvatar(
                                                                  'gallery');
                                                        },
                                                      ),
                                                      const Spacer()
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.grey[800],
                                                ));
                                          //media.previewNewProfilePhoto('camera');
                                        },
                                        child: media.newAvatarUrlMobile != null
                                            ? kIsWeb
                                                ? CircularProfileAvatar(
                                                    media.newAvatarUrlWeb,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    placeHolder:
                                                        (context, url) =>
                                                            const SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    radius: 50,
                                                    borderWidth: 2,
                                                    borderColor: Colors.grey,
                                                    elevation: 10,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    imageFit: BoxFit.fill,
                                                    cacheImage: true,
                                                  )
                                                : CircularProfileAvatar(
                                                    '',
                                                    child: getImageFile(media
                                                        .newAvatarUrlMobile),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    placeHolder:
                                                        (context, url) =>
                                                            const SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    radius: 50,
                                                    borderWidth: 2,
                                                    borderColor: Colors.grey,
                                                    elevation: 10,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    imageFit: BoxFit.fill,
                                                    cacheImage: true,
                                                  )
                                            : CircularProfileAvatar(
                                                widget.currentAvatarLink,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                placeHolder: (context, url) =>
                                                    const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                radius: 50,
                                                borderWidth: 2,
                                                borderColor: Colors.grey,
                                                elevation: 10,
                                                backgroundColor:
                                                    Colors.transparent,
                                                imageFit: BoxFit.fill,
                                                cacheImage: true,
                                              ))
                              ],
                            )),
                  ),
                  const SizedBox(height: 20.0),
                  Consumer<LanguageModel>(
                      builder: (context, language, _) => TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  language.editProfileViewUsernamePlaceholder),
                          textAlign: TextAlign.left,
                          initialValue: widget.currentUsername,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? language.editProfileViewUsernameErrorMessage
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => username = val);
                          })),
                  const SizedBox(height: 20.0),
                  Consumer<LanguageModel>(
                      builder: (context, language, _) => TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  language.editProfileViewEmailPlaceholder),
                          textAlign: TextAlign.left,
                          initialValue: widget.currentUserEmail,
                          autofocus: true,
                          validator: (String? value) {
                            return (value != null && value.length < 2)
                                ? language.editProfileViewUsernameErrorMessage
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => email = val);
                          })),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 300,
                    child: Consumer<MediaModel>(
                        builder: (context, media, child) => ElevatedButton(
                              child: loading
                                  ? const LinearProgressIndicator()
                                  : Consumer<LanguageModel>(
                                      builder: (context, language, _) => Text(
                                          language.editProfileViewButtonText ??
                                              '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ))),
                              onPressed: () async {
                                if (formKeyForm.currentState!.validate()) {
                                  setState(() => loading = true);
                                  // ignore: prefer_conditional_assignment
                                  if (username == null) {
                                    username = widget.currentUsername;
                                  }
                                  // ignore: prefer_conditional_assignment
                                  if (email == null) {
                                    email = widget.currentUserEmail;
                                  }

                                  UserModel()
                                      .updateUserProfile(
                                          widget.currentAvatarLink,
                                          media.newAvatarUrlMobile,
                                          media.newAvatarUrlWebData,
                                          username,
                                          email)
                                      .then((result) {
                                    if (result == null) {
                                      media.newAvatarUrlMobile = null;
                                      media.newAvatarUrlWeb = null;
                                      if (mounted) {
                                        Navigator.of(context).maybePop();
                                      }
                                    } else {
                                      setState(() => loading = false);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Consumer<LanguageModel>(
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

  getImageFile(_image) {
    return Image.file(_image);
  }
}
