import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language_model.dart';

class LanguageService extends ChangeNotifier {
  static List<String> languages = ['English', 'Dutch'];
  final String key = "language";

  late String _language;
  late Map<String, dynamic> translations;

  LanguageService() {
    _language = 'English';
    _loadFromPrefs();
  }

  String get language => _language;

  setLanguage(_value) {
    _language = _value;
    _saveToPrefs();
  }

  defaultLanguage() {
    String? systemLanguage;
    String? defaultLanguage;

    if (kIsWeb) {
      Locale webLocale = ui.window.locale;
      String webLocaleAsString = webLocale.toString();
      List<String> split = webLocaleAsString.split("_");
      systemLanguage = split[0];
    } else {
      String systemLocale = Platform.localeName;
      List<String> split = systemLocale.split("_");
      systemLanguage = split[0];
    }

    if (kDebugMode) {
      print('Setting system language as default: $systemLanguage');
    }

    switch (systemLanguage) {
      case 'en':
        defaultLanguage = 'English';
        break;
      case 'nl':
        defaultLanguage = 'Dutch';
        break;
      default:
        defaultLanguage = 'English';
    }
    return defaultLanguage;
  }

  _loadFromPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    _language = preference.getString(key) ?? defaultLanguage();
    _switchLanguage(_language);
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setString(key, _language);
    _switchLanguage(_language);
    notifyListeners();
  }

  // AppBar titles
  String? mainScreenAppBarTitle;
  String? newContractScreenAppBarTitle;
  String? newCommitmentScreenAppBarTitle;
  String? editContractScreenAppBarTitle;
  String? editCommitmentScreenAppBarTitle;
  String? resetPasswordScreenAppBarTitle;
  String? editProfileScreenAppBarTitle;
  String? signInScreenAppBarTitle;
  String? signUpScreenAppBarTitle;

  // Buttons
  String? newContractScreenButtonText;
  String? newCommitmentScreenButtonText;
  String? editContractScreenButtonText;
  String? editCommitmentScreenButtonText;
  String? resetPasswordScreenButtonText;
  String? editProfileScreenButtonText;
  String? editContractScreenDeleteContractButtonText;
  String? signInScreenButtonText;
  String? signUpScreenButtonText;
  String? mainScreenSettingsLogoutButton;

  // Placeholders
  String? newContractScreenContractTitlePlaceholder;
  String? newCommitmentScreenCommitmentPlaceholder;
  String? editContractScreenContractTitlePlaceholder;
  String? editCommitmentScreenCommitmentPlaceholder;
  String? resetPasswordScreenEmailPlaceholder;
  String? editProfileScreenUsernamePlaceholder;
  String? editProfileScreenEmailPlaceholder;
  String? signUpScreenUsernamePlaceholder;
  String? signInUpScreenEmailPlaceholder;
  String? signInUpScreenPasswordPlaceholder;

  // Error Messages
  String? newContractScreenContractTitleErrorMessage;
  String? newCommitmentScreenCommitmentErrorMessage;
  String? editContractScreenContractTitleErrorMessage;
  String? editCommitmentScreenCommitmentErrorMessage;
  String? resetPasswordScreenEmailErrorMessage;
  String? editProfileScreenUsernameErrorMessage;
  String? signUpScreenUsernameErrorMessage;
  String? signInUpScreenEmailErrorMessage;
  String? signInUpScreenPasswordErrorMessage;
  String? mainScreenNoContractsErrorMessage;
  String? mainScreenNoCommitmentsErrorMessage;
  String? mainScreenNoNotificationsErrorMessage;
  String? genericAuthErrorMessage;
  String? genericFirebaseErrorMessage;

  // Links
  String? signInScreenResetPasswordLink;
  String? signInScreenSignUpUsingEmailLink;
  String? signInScreengoBackToSignInLink;
  String? mainScreenDismissebleEditCommitmentLink;
  String? mainScreenDismissebleDeleteCommitmentLink;
  String? mainScreenDismissebleMarkNotificationReadLink;

  // Labels
  String? mainScreenSettingEditProfileLabel;
  String? mainScreenSettingsLanguageLabel;
  String? mainScreenSettingsThemeLabel;
  String? mainScreenSettingsBiometricsLabel;
  String? mainScreenSettingsAnalyticsLabel;

  // Headers
  String? mainScreenNotificationHeader;

  // Push notifications titles
  String? activateContractNotificationTitle;

  // Push notifications bodies
  String? activateContractNotificationBody;

  // Email titles
  String? welcomeEmailTitle;
  String? addContractEmailTitle;

  // Email bodies
  String? welcomeEmailBody;
  String? addContractEmailBody;

  // Email signatures
  String? welcomeEmailSignature;

  void _switchLanguage(_language) {
    // AppBar titles
    mainScreenAppBarTitle = LanguageModel.mainScreenAppBarTitle?[_language];
    newContractScreenAppBarTitle =
        LanguageModel.newContractScreenAppBarTitle?[_language];
    newCommitmentScreenAppBarTitle =
        LanguageModel.newCommitmentScreenAppBarTitle?[_language];
    editContractScreenAppBarTitle =
        LanguageModel.editContractScreenAppBarTitle?[_language];
    editCommitmentScreenAppBarTitle =
        LanguageModel.editCommitmentScreenAppBarTitle?[_language];
    resetPasswordScreenAppBarTitle =
        LanguageModel.resetPasswordScreenAppBarTitle?[_language];
    editProfileScreenAppBarTitle =
        LanguageModel.editProfileScreenAppBarTitle?[_language];
    signInScreenAppBarTitle = LanguageModel.signInScreenAppBarTitle?[_language];
    signUpScreenAppBarTitle = LanguageModel.signUpScreenAppBarTitle?[_language];
    // Buttons
    newContractScreenButtonText =
        LanguageModel.newContractScreenButtonText?[_language];
    newCommitmentScreenButtonText =
        LanguageModel.newCommitmentScreenButtonText?[_language];
    editContractScreenButtonText =
        LanguageModel.editContractScreenButtonText?[_language];
    editCommitmentScreenButtonText =
        LanguageModel.editCommitmentScreenButtonText?[_language];
    resetPasswordScreenButtonText =
        LanguageModel.resetPasswordScreenButtonText?[_language];
    editProfileScreenButtonText =
        LanguageModel.editProfileScreenButtonText?[_language];
    editContractScreenDeleteContractButtonText =
        LanguageModel.editContractScreenDeleteContractButtonText?[_language];
    signInScreenButtonText = LanguageModel.signInScreenButtonText?[_language];
    signUpScreenButtonText = LanguageModel.signUpScreenButtonText?[_language];
    mainScreenSettingsLogoutButton =
        LanguageModel.mainScreenSettingsLogoutButton?[_language];
    // Placeholder
    newContractScreenContractTitlePlaceholder =
        LanguageModel.newContractScreenContractTitlePlaceholder?[_language];
    newCommitmentScreenCommitmentPlaceholder =
        LanguageModel.newCommitmentScreenCommitmentPlaceholder?[_language];
    editContractScreenContractTitlePlaceholder =
        LanguageModel.editContractScreenContractTitlePlaceholder?[_language];
    editCommitmentScreenCommitmentPlaceholder =
        LanguageModel.editCommitmentScreenCommitmentPlaceholder?[_language];
    resetPasswordScreenEmailPlaceholder =
        LanguageModel.resetPasswordScreenEmailPlaceholder?[_language];
    editProfileScreenUsernamePlaceholder =
        LanguageModel.editProfileScreenUsernamePlaceholder?[_language];
    editProfileScreenEmailPlaceholder =
        LanguageModel.editProfileScreenEmailPlaceholder?[_language];
    signUpScreenUsernamePlaceholder =
        LanguageModel.signUpScreenUsernamePlaceholder?[_language];
    signInUpScreenEmailPlaceholder =
        LanguageModel.signInUpScreenEmailPlaceholder?[_language];
    signInUpScreenPasswordPlaceholder =
        LanguageModel.signInUpScreenPasswordPlaceholder?[_language];
    // Error Messages
    newContractScreenContractTitleErrorMessage =
        LanguageModel.signInUpScreenPasswordPlaceholder?[_language];
    newCommitmentScreenCommitmentErrorMessage =
        LanguageModel.signInUpScreenPasswordPlaceholder?[_language];
    editContractScreenContractTitleErrorMessage =
        LanguageModel.signInUpScreenPasswordPlaceholder?[_language];
    editCommitmentScreenCommitmentErrorMessage =
        LanguageModel.signInUpScreenPasswordPlaceholder?[_language];
    resetPasswordScreenEmailErrorMessage =
        LanguageModel.signInUpScreenPasswordPlaceholder?[_language];
    signUpScreenUsernameErrorMessage =
        LanguageModel.signUpScreenUsernameErrorMessage?[_language];
    signInUpScreenEmailErrorMessage =
        LanguageModel.signInUpScreenEmailErrorMessage?[_language];
    signInUpScreenPasswordErrorMessage =
        LanguageModel.signInUpScreenPasswordErrorMessage?[_language];
    editProfileScreenUsernameErrorMessage =
        LanguageModel.editProfileScreenUsernameErrorMessage?[_language];
    mainScreenNoContractsErrorMessage =
        LanguageModel.mainScreenNoContractsErrorMessage?[_language];
    mainScreenNoCommitmentsErrorMessage =
        LanguageModel.mainScreenNoCommitmentsErrorMessage?[_language];
    mainScreenNoNotificationsErrorMessage =
        LanguageModel.mainScreenNoNotificationsErrorMessage?[_language];
    genericAuthErrorMessage = LanguageModel.genericAuthErrorMessage?[_language];
    genericFirebaseErrorMessage =
        LanguageModel.genericFirebaseErrorMessage?[_language];
    // Links
    signInScreenResetPasswordLink =
        LanguageModel.signInScreenResetPasswordLink?[_language];
    signInScreenSignUpUsingEmailLink =
        LanguageModel.signInScreenSignUpUsingEmailLink?[_language];
    signInScreengoBackToSignInLink =
        LanguageModel.signInScreengoBackToSignInLink?[_language];
    mainScreenDismissebleEditCommitmentLink =
        LanguageModel.mainScreenDismissebleEditCommitmentLink?[_language];
    mainScreenDismissebleDeleteCommitmentLink =
        LanguageModel.mainScreenDismissebleDeleteCommitmentLink?[_language];
    mainScreenDismissebleMarkNotificationReadLink =
        LanguageModel.mainScreenDismissebleMarkNotificationReadLink?[_language];
    // Labels
    mainScreenSettingEditProfileLabel =
        LanguageModel.mainScreenSettingEditProfileLabel?[_language];
    mainScreenSettingsLanguageLabel =
        LanguageModel.mainScreenSettingsLanguageLabel?[_language];
    mainScreenSettingsThemeLabel =
        LanguageModel.mainScreenSettingsThemeLabel?[_language];
    mainScreenSettingsBiometricsLabel =
        LanguageModel.mainScreenSettingsBiometricsLabel?[_language];
    mainScreenSettingsAnalyticsLabel =
        LanguageModel.mainScreenSettingsAnalyticsLabel?[_language];
    // Header
    mainScreenNotificationHeader =
        LanguageModel.mainScreenNotificationHeader?[_language];
    // Push notifications titles
    activateContractNotificationTitle =
        LanguageModel.activateContractNotificationTitle?[_language];
    // Push notifications bodies
    activateContractNotificationBody =
        LanguageModel.activateContractNotificationBody?[_language];
    // Email titles
    welcomeEmailTitle = LanguageModel.welcomeEmailTitle?[_language];
    addContractEmailTitle = LanguageModel.addContractEmailTitle?[_language];
    // Email bodies
    welcomeEmailBody = LanguageModel.welcomeEmailBody?[_language];
    addContractEmailBody = LanguageModel.addContractEmailBody?[_language];
  }
}
