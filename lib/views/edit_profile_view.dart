import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/language_model.dart';
import '../helpers/media_helper.dart';
import '../models/user_model.dart';

/// EditProfileView view class
class EditProfileView extends StatefulWidget {
  /// Initialize class variables to widget
  final String? currentAvatarLink;
  final String? currentUsername;

  /// Constructor to load variables from MainView
  const EditProfileView({
    Key? key,
    this.currentAvatarLink,
    this.currentUsername,
  }) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

/// EditProfileView view state class
class _EditProfileViewState extends State<EditProfileView> {
  /// Generate unique form key
  final formKeyForm = GlobalKey<FormState>();

  /// Initialize form variable password
  String? password;
  String? repeatPassword;

  /// Initialize variables to show/hide password
  bool obscureTextPassword = true;
  bool obscureTextRepeatPassword = true;

  /// Initialize loading bool
  bool loading = false;

  String? username;
  String? email;

  /// Function to toggle password
  void showOrHidePasswordToggle() {
    setState(() {
      obscureTextPassword = !obscureTextPassword;
    });
  }

  /// Function to toggle password
  void showOrHideRepeatPasswordToggle() {
    setState(() {
      obscureTextRepeatPassword = !obscureTextRepeatPassword;
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
              Text(language.editProfileViewAppBarTitle ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
      centerTitle: true,
      elevation: 0,
    );
  }

  /// Function to load avatar field
  loadAvatarField() {
    return Consumer<MediaHelper>(
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
                                          FontAwesomeIcons.camera,
                                        ),
                                        onPressed: () {
                                          media.previewNewAvatar('camera');
                                        },
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.photoFilm,
                                        ),
                                        onPressed: () {
                                          media.previewNewAvatar('gallery');
                                        },
                                      ),
                                      const Spacer()
                                    ],
                                  ),
                                  backgroundColor: Colors.grey[800],
                                ));
                          //media.previewNewProfilePhoto('camera');
                        },
                        child: media.newAvatarUrlMobile == null
                            ? CircularProfileAvatar(
                                '',
                                child: const CircleAvatar(
                                    radius: 50,
                                    child: FaIcon(FontAwesomeIcons.user,
                                        size: 60, color: Colors.grey)),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                placeHolder: (context, url) => const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                                radius: 50,
                                borderWidth: 2,
                                borderColor: Colors.grey,
                                elevation: 10,
                                backgroundColor: Colors.transparent,
                                imageFit: BoxFit.fill,
                                cacheImage: true,
                              )
                            : kIsWeb
                                ? CircularProfileAvatar(
                                    media.newAvatarUrlWeb,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    placeHolder: (context, url) =>
                                        const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                    radius: 50,
                                    borderWidth: 2,
                                    borderColor: Colors.grey,
                                    elevation: 10,
                                    backgroundColor: Colors.transparent,
                                    imageFit: BoxFit.fill,
                                    cacheImage: true,
                                  )
                                : CircularProfileAvatar(
                                    '',
                                    child:
                                        getImageFile(media.newAvatarUrlMobile),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    placeHolder: (context, url) =>
                                        const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                    radius: 50,
                                    borderWidth: 2,
                                    borderColor: Colors.grey,
                                    elevation: 10,
                                    backgroundColor: Colors.transparent,
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
                                          FontAwesomeIcons.camera,
                                        ),
                                        onPressed: () {
                                          media.previewNewAvatar('camera');
                                        },
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.photoFilm,
                                        ),
                                        onPressed: () {
                                          media.previewNewAvatar('gallery');
                                        },
                                      ),
                                      const Spacer()
                                    ],
                                  ),
                                  backgroundColor: Colors.grey[800],
                                ));
                          //media.previewNewProfilePhoto('camera');
                        },
                        child: media.newAvatarUrlMobile != null
                            ? kIsWeb
                                ? CircularProfileAvatar(
                                    media.newAvatarUrlWeb,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    placeHolder: (context, url) =>
                                        const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                    radius: 50,
                                    borderWidth: 2,
                                    borderColor: Colors.grey,
                                    elevation: 10,
                                    backgroundColor: Colors.transparent,
                                    imageFit: BoxFit.fill,
                                    cacheImage: true,
                                  )
                                : CircularProfileAvatar(
                                    '',
                                    child:
                                        getImageFile(media.newAvatarUrlMobile),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    placeHolder: (context, url) =>
                                        const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                    radius: 50,
                                    borderWidth: 2,
                                    borderColor: Colors.grey,
                                    elevation: 10,
                                    backgroundColor: Colors.transparent,
                                    imageFit: BoxFit.fill,
                                    cacheImage: true,
                                  )
                            : CircularProfileAvatar(
                                widget.currentAvatarLink ?? '',
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                placeHolder: (context, url) => const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                                radius: 50,
                                borderWidth: 2,
                                borderColor: Colors.grey,
                                elevation: 10,
                                backgroundColor: Colors.transparent,
                                imageFit: BoxFit.fill,
                                cacheImage: true,
                              ))
              ],
            ));
  }

  /// Function to load username text field
  loadUsernameTextField() {
    return Consumer<LanguageModel>(
        builder: (context, language, _) => SizedBox(
              width: double.infinity,
              child: TextFormField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: language.editProfileViewUsernamePlaceholder),
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
                  }),
            ));
  }

  /// Function to load form submit button
  loadFormSubmitButton() {
    return Consumer<LanguageModel>(
        builder: (context, language, _) => SizedBox(
              width: double.infinity,
              child: Consumer<MediaHelper>(
                  builder: (context, media, _) => ElevatedButton(
                        child: loading
                            ? const LinearProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                    language.editProfileViewButtonText ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                        onPressed: () async {
                          if (formKeyForm.currentState!.validate()) {
                            setState(() => loading = true);
                            // ignore: prefer_conditional_assignment
                            if (username == null) {
                              username = widget.currentUsername;
                            }

                            UserModel()
                                .editProfile(
                              widget.currentAvatarLink,
                              media.newAvatarUrlMobile,
                              media.newAvatarUrlWebData,
                              username,
                            )
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
                      )),
            ));
  }

  /// Main EditProfileviewview widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loadAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
              key: formKeyForm,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Center(
                    child: loadAvatarField(),
                  ),
                  const SizedBox(height: 20.0),
                  loadUsernameTextField(),
                  const SizedBox(height: 20.0),
                  loadFormSubmitButton()
                ],
              )),
        ),
      ),
    );
  }

  /// Function to return image file to avatar widget
  getImageFile(_image) {
    return Image.file(_image);
  }
}
