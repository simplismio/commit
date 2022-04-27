import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language model class
/// Uses ChangeNotifier to update changes to MainView
class LanguageModel with ChangeNotifier {
  /// Language class variables
  final String key = "language";

  /// Toggle value language
  late String _language;
  late Map<String, dynamic> translations;

  static String? systemLanguage;
  String? defaultLanguage;

  /// Getter for the language setting
  String get language => _language;

  /// Language model class constructor
  /// Initialize _language variable
  /// Loads latest language setting from SharedPreferences
  LanguageModel() {
    _language = setDefaultLanguage();
    loadFromPrefs();
  }

  /// Function to set the language
  setLanguage(value) {
    _language = value;
    saveToPrefs();
  }

  /// Identify the locale in the phone or browser and set the default locale in case user has not set language yet
  setDefaultLanguage() {
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
        defaultLanguage = 'Nederlands';
        break;
      default:
        defaultLanguage = 'English';
    }
    return defaultLanguage;
  }

  /// Function to load the language settings in SharedPreferences
  void loadFromPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    _language = preference.getString(key) ?? setDefaultLanguage();
    switchLanguage(_language);
    notifyListeners();
  }

  /// Function to save the language in SharedPreferences
  void saveToPrefs() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setString(key, _language);
    switchLanguage(_language);
    notifyListeners();
  }

  /// Set the Maps that contain translations
  final Map<String, String>? _mainViewAppBarTitle = {
    'English': 'Contracts',
    'Nederlands': 'Contracten'
  };
  final Map<String, String>? _newContractViewAppBarTitle = {
    'English': 'New contract',
    'Nederlands': 'Nieuw contract'
  };
  final Map<String, String>? _newCommitmentViewAppBarTitle = {
    'English': 'New commitment',
    'Nederlands': 'Nieuw commitment'
  };
  final Map<String, String>? _editContractViewAppBarTitle = {
    'English': 'Edit contract',
    'Nederlands': 'Wijzig contract'
  };
  final Map<String, String>? _editCommitmentViewAppBarTitle = {
    'English': 'Edit commitment',
    'Nederlands': 'Wijzig commitment'
  };
  final Map<String, String>? _resetPasswordViewAppBarTitle = {
    'English': 'Reset password',
    'Nederlands': 'Reset wachtwoord'
  };
  final Map<String, String>? _editProfileViewAppBarTitle = {
    'English': 'Edit profile',
    'Nederlands': 'Wijzig profiel'
  };
  final Map<String, String>? _editEmailViewAppBarTitle = {
    'English': 'Change email',
    'Nederlands': 'Wijzig email'
  };
  final Map<String, String>? _editPasswordViewAppBarTitle = {
    'English': 'Change password',
    'Nederlands': 'Wijzig password'
  };
  final Map<String, String>? _signInViewAppBarTitle = {
    'English': 'Sign in',
    'Nederlands': 'Log in'
  };
  final Map<String, String>? _signUpViewAppBarTitle = {
    'English': 'Sign up',
    'Nederlands': 'Registreer'
  };

  // Dropdown Lists
  final List<String> _mainViewLanguageDropdownList = ['English', 'Nederlands'];
  final Map<String, List<String>> _addEditCommitmentProofDropdownList = {
    'English': ['Bank statement', 'Transaction'],
    'Nederlands': ['Bankafschrift', 'Transactie'],
  };
  final Map<String, List<String>> _addEditCommitmentResolutionDropdownList = {
    'English': ['Payment', 'Blacklist'],
    'Nederlands': ['Betaling', 'Zwarte lijst'],
  };

  // Buttons
  final Map<String, String>? _newContractViewButtonText = {
    'English': 'Save contract',
    'Nederlands': 'Contract opslaan'
  };
  final Map<String, String>? _newCommitmentViewButtonText = {
    'English': 'Save commitment',
    'Nederlands': 'Commitment opslaan'
  };
  final Map<String, String>? _editContractViewButtonText = {
    'English': 'Save contract changes',
    'Nederlands': 'Wijziging contract opslaan'
  };
  final Map<String, String>? _editCommitmentViewButtonText = {
    'English': 'Save commitment changes',
    'Nederlands': 'Wijzigingn commitment opslaan'
  };
  final Map<String, String>? _resetPasswordViewButtonText = {
    'English': 'Email reset link',
    'Nederlands': 'Email reset link'
  };
  final Map<String, String>? _editProfileViewButtonText = {
    'English': 'Save profile changes',
    'Nederlands': 'Wijzingen profiel opslaan'
  };
  final Map<String, String>? _editEmailViewButtonText = {
    'English': 'Save new email',
    'Nederlands': 'Nieuw email adres opslaan'
  };
  final Map<String, String>? _editPasswordViewButtonText = {
    'English': 'Save new password',
    'Nederlands': 'Nieuw wachtwoord opslaan'
  };
  final Map<String, String>? _editContractViewDeleteContractButtonText = {
    'English': 'Delete contract',
    'Nederlands': 'Contract verwijderen'
  };
  final Map<String, String>? _signInViewButtonText = {
    'English': 'Sign in',
    'Nederlands': 'Log in'
  };
  final Map<String, String>? _signUpViewButtonText = {
    'English': 'Sign up',
    'Nederlands': 'Registreer'
  };
  final Map<String, String>? _mainViewSettingsLogoutButtonText = {
    'English': 'Log out',
    'Nederlands': 'Uitloggen'
  };
  final Map<String, String>? _mainViewResendEmailVerificationButtonText = {
    'English': 'Resend',
    'Nederlands': 'Opnieuw'
  };

  // Placeholders
  final Map<String, String>? _newContractViewContractTitlePlaceholder = {
    'English': 'Contract title',
    'Nederlands': 'Titel van het contract'
  };
  final Map<String, String>? _newCommitmentViewCommitmentPlaceholder = {
    'English': 'I promise to..',
    'Nederlands': 'Ik beloof om ..'
  };
  final Map<String, String>? _editContractViewContractTitlePlaceholder = {
    'English': 'Contract title',
    'Nederlands': 'Titel van het contract'
  };
  final Map<String, String>? _editCommitmentViewCommitmentPlaceholder = {
    'English': 'Commitment',
    'Nederlands': 'Commitment'
  };
  final Map<String, String>? _resetPasswordViewEmailPlaceholder = {
    'English': 'Email',
    'Nederlands': 'Email'
  };
  final Map<String, String>? _editProfileViewUsernamePlaceholder = {
    'English': 'Username',
    'Nederlands': 'Gebruikersnaam'
  };
  final Map<String, String>? _editEmailViewEmailPlaceholder = {
    'English': 'Current email',
    'Nederlands': 'Huidig email adres'
  };
  final Map<String, String>? _editEmailViewNewEmailPlaceholder = {
    'English': 'New email',
    'Nederlands': 'Nieuw email address'
  };
  final Map<String, String>? _signUpViewUsernamePlaceholder = {
    'English': 'Username',
    'Nederlands': 'Gebruikersnaam'
  };
  final Map<String, String>? _signInUpViewEmailPlaceholder = {
    'English': 'Email',
    'Nederlands': 'Email'
  };
  final Map<String, String>? _signInUpViewPasswordPlaceholder = {
    'English': 'Password',
    'Nederlands': 'Wachtwoord'
  };
  final Map<String, String>? _addCommitmentViewCounterpartyPlaceholder = {
    'English': 'Choose counterparty',
    'Nederlands': 'Kies tegenpartij'
  };
  final Map<String, String>? _addCommitmentViewProofPlaceholder = {
    'English': 'Choose proof mechanism for fulfillment',
    'Nederlands': 'Kies de bewijsvorm voor nakoming'
  };
  final Map<String, String>? _addCommitmentViewResolutionPlaceholder = {
    'English': 'Choose resolution mechanism if non-compliant',
    'Nederlands': 'Kies de resolutievorm bij niet na-koming'
  };
  final Map<String, String>? _editProfileViewNewPasswordPlaceholder = {
    'English': 'New password',
    'Nederlands': 'Nieuw wachtwoord'
  };
  final Map<String, String>? _editProfileViewRepeatNewPasswordPlaceholder = {
    'English': 'New password again',
    'Nederlands': 'Nieuw wachtwoord opnieuw'
  };

  // Error Messages
  final Map<String, String>? _newContractViewContractTitleErrorMessage = {
    'English': 'Please provide a valid contract title',
    'Nederlands': 'De ingegeven contract titel is incorrect'
  };
  final Map<String, String>? _newCommitmentViewCommitmentErrorMessage = {
    'English': 'Please provide a valid commitment',
    'Nederlands': 'Het ingegeven commitment is incorrect'
  };
  final Map<String, String>? _editContractViewContractTitleErrorMessage = {
    'English': 'Please provide a valid contract title',
    'Nederlands': 'De ingegeven contract title is incorrect'
  };
  final Map<String, String>? _editCommitmentViewCommitmentErrorMessage = {
    'English': 'Please provide a valid commitment',
    'Nederlands': 'Het ingegeven commitment is incorrect'
  };
  final Map<String, String>? _resetPasswordViewEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Nederlands': 'Het ingegeven email adres is incorrect'
  };
  final Map<String, String>? _editProfileViewUsernameErrorMessage = {
    'English': 'Please provide a valid username',
    'Nederlands': 'De ingegeven gebruikersnaam is incorrect'
  };
  final Map<String, String>? _editEmailViewEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Nederlands': 'Het ingegeven email adres is incorrect'
  };
  final Map<String, String>? _editEmailViewNewEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Nederlands': 'Het ingegeven email adres is incorrect'
  };
  final Map<String, String>? _signUpViewUsernameErrorMessage = {
    'English': 'Please provide a valid username',
    'Nederlands': 'De ingegeven gebruikersnaam is incorrect'
  };
  final Map<String, String>? _signInUpViewEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Nederlands': 'Het ingegeven email adres is incorrect'
  };
  final Map<String, String>? _signInUpViewPasswordErrorMessage = {
    'English': 'testEN',
    'Nederlands': 'Er zijn nog geen commitments gemaakt'
  };
  final Map<String, String>? _mainViewNoContractsErrorMessage = {
    'English': 'There are no contracts yet',
    'Nederlands': 'Er zijn nog geen contracten'
  };
  final Map<String, String>? _mainViewNoCommitmentsErrorMessage = {
    'English': 'There are no commitments yet',
    'Nederlands': 'Er zijn nog geen commitments gemaakt'
  };
  final Map<String, String>? _mainViewNoNotificationsErrorMessage = {
    'English': 'There are no notifications yet',
    'Nederlands': 'Er zijn nog geen notificaties'
  };
  final Map<String, String>? _genericAuthErrorMessage = {
    'English': 'Email address or password is incorrect',
    'Nederlands': 'Email adres of wachtwoord is incorrect'
  };
  final Map<String, String>? _genericFirebaseErrorMessage = {
    'English': 'Something went wrong. Please try again',
    'Nederlands': 'Er is iets verkeerd gegaan. Probeert u het s.v.p. opnieuw'
  };
  final Map<String, String>? _editPasswordViewNewPasswordErrorMessage = {
    'English': 'Please provide a valid password',
    'Nederlands': 'Het ingegeven wachtwoord is incorrect'
  };
  final Map<String, String>? _editPasswordViewRepeatNewPasswordErrorMessage = {
    'English': 'The provided passwords are not the same',
    'Nederlands': 'De ingegeven wachtwoorden zijn niet gelijk'
  };

  // Links
  final Map<String, String>? _signInViewResetPasswordLink = {
    'English': 'I forgot my password',
    'Nederlands': 'Ik ben mijn wachtwoord vergeten'
  };
  final Map<String, String>? _signInViewSignUpUsingEmailLink = {
    'English': 'Sign up using email',
    'Nederlands': 'Registreer met een email adres'
  };
  final Map<String, String>? _signInViewgoBackToSignInLink = {
    'English': 'Go back to sign in',
    'Nederlands': 'Ga terug naar log in'
  };
  final Map<String, String>? _mainViewDismissebleEditCommitmentLink = {
    'English': 'Edit commitment',
    'Nederlands': 'Wijzig commitment'
  };
  final Map<String, String>? _mainViewDismissebleDeleteCommitmentLink = {
    'English': 'Delete commitment',
    'Nederlands': 'Verwijder commitment'
  };
  final Map<String, String>? _mainViewDismissebleMarkNotificationReadLink = {
    'English': 'Mark as read',
    'Nederlands': 'Markeren als gelezen'
  };

  // Labels
  final Map<String, String>? _mainViewSettingEditProfileLabel = {
    'English': 'Edit profile',
    'Nederlands': 'Wijzig profiel'
  };
  final Map<String, String>? _mainViewSettingEditEmailLabel = {
    'English': 'Change email',
    'Nederlands': 'Wijzig email'
  };
  final Map<String, String>? _mainViewSettingEditPasswordLabel = {
    'English': 'Change password',
    'Nederlands': 'Wijzig wachtwoord'
  };
  final Map<String, String>? _mainViewSettingsLanguageLabel = {
    'English': 'Language',
    'Nederlands': 'Taal'
  };
  final Map<String, String>? _mainViewSettingsThemeLabel = {
    'English': 'Dark theme',
    'Nederlands': 'Donker thema'
  };
  final Map<String, String>? _mainViewSettingsBiometricsLabel = {
    'English': 'Biometric unlock',
    'Nederlands': 'Unlock met biometrie'
  };
  final Map<String, String>? _mainViewSettingsAnalyticsLabel = {
    'English': 'Share analytics',
    'Nederlands': 'Deel gebruiksgegevens'
  };
  final Map<String, String>? _mainViewSelfLabel = {
    'English': 'you',
    'Nederlands': 'jijzelf'
  };

  // Messages
  final Map<String, String>? _mainViewUnverifiedEmailMessage = {
    'English': 'Verify your email',
    'Nederlands': 'Bevestig je email adres'
  };
  final Map<String, String>? _editEmailViewSignOutMessage = {
    'English': 'You need to sign in again after making this change',
    'Nederlands':
        'Je zult opnieuw moeten inloggen na het maken van deze wijziging'
  };
  final Map<String, String>? _editPasswordViewSignOutMessage = {
    'English': 'You need to sign in again after making this change',
    'Nederlands':
        'Je zult opnieuw moeten inloggen na het maken van deze wijziging'
  };

  // Headers
  final Map<String, String>? _mainViewNotificationHeader = {
    'English': 'Notifications',
    'Nederlands': 'Notificaties'
  };

  // Push notifications titles
  final Map<String, String>? _activateContractNotificationTitle = {
    'English': 'Contract activated',
    'Nederlands': 'Contract geactiveerd'
  };

  // Push notifications bodies
  final Map<String, String>? _activateContractNotificationBody = {
    'English': 'Click to add commitment to the contract',
    'Nederlands': 'Contract geactiveerd'
  };

  // Email titles
  final Map<String, String>? _welcomeEmailTitle = {
    'English': 'Welcome to Commit',
    'Nederlands': 'Welkom bij Commit'
  };
  final Map<String, String>? _confirmAccountEmailTitle = {
    'English': 'Confirm your email address',
    'Nederlands': 'Bevestig je email address'
  };
  final Map<String, String>? _resetPasswordEmailTitle = {
    'English': 'Reset your password',
    'Nederlands': 'Wijzig je wachtwoord'
  };
  final Map<String, String>? _addContractEmailTitle = {
    'English': 'You have been added to a new contract',
    'Nederlands': 'Je bent toegevoegd aan een contract'
  };
  final Map<String, String>? _editProfileViewEmailTitle = {
    'English': 'Your profile has been updated',
    'Nederlands': 'Je profiel is bijgewerkt'
  };
  final Map<String, String>? _editEmailViewEmailTitle = {
    'English': 'Your email address has been changed',
    'Nederlands': 'Je email adres is gewijzigd.'
  };
  final Map<String, String>? _editPasswordViewEmailTitle = {
    'English': 'Your password has been changed',
    'Nederlands': 'Je wachwoord is gewijzigd'
  };

  // Email bodies
  final Map<String, String>? _welcomeEmailBody = {
    'English': 'You have made the right decision to commit',
    'Nederlands': 'Je hebt het juiste besluit genomen om je te commiteren'
  };
  final Map<String, String>? _verifyEmailEmailBody = {
    'English': 'Please confirm your email address by clicking on the link',
    'Nederlands': 'Bevestig je email adres via onderstaande link'
  };
  final Map<String, String>? _resetPasswordEmailBody = {
    'English': 'Please click the link to reset your password',
    'Nederlands': 'Reset je wachtwoord via de link'
  };
  final Map<String, String>? _addContractEmailBody = {
    'English': 'You have been added as a participant in a new contract',
    'Nederlands': 'Je bent toegevoegd aan een contract'
  };
  final Map<String, String>? _editProfileViewEmailBody = {
    'English':
        'Your profile has been updated. If you did not make this change, please contact us immediately',
    'Nederlands':
        'Je profiel is bijgewerkt. Indien je deze wijziging niet zelf gemaakt hebt, neem s.v.p. direct contact met ons op'
  };
  final Map<String, String>? _editEmailViewEmailBody = {
    'English':
        'Your email has been updated. If you did not make this change, please contact us immediately',
    'Nederlands':
        'Je email adres is gewijzigd. Indien je deze wijziging niet zelf gemaakt hebt, neem s.v.p. direct contact met ons op'
  };
  final Map<String, String>? _editPasswordViewEmailBody = {
    'English':
        'Your password has been updated. If you did not make this change, please contact us immediately',
    'Nederlands':
        'Je wachwoord is gewijzigd. Indien je deze wijziging niet zelf gemaakt hebt, neem s.v.p. direct contact met ons op'
  };

  /// Create the variables that hold the value to be shared with Views

  // AppBar titles
  String? mainViewAppBarTitle;
  String? newContractViewAppBarTitle;
  String? newCommitmentViewAppBarTitle;
  String? editContractViewAppBarTitle;
  String? editCommitmentViewAppBarTitle;
  String? resetPasswordViewAppBarTitle;
  String? editProfileViewAppBarTitle;
  String? editEmailViewAppBarTitle;
  String? editPasswordViewAppBarTitle;
  String? signInViewAppBarTitle;
  String? signUpViewAppBarTitle;

  // Dropdown lists
  List<String>? mainViewLanguageDropdownList;
  List<String>? addEditCommitmentProofDropdownList;
  List<String>? addEditCommitmentResolutionDropdownList;

  // Buttons
  String? newContractViewButtonText;
  String? newCommitmentViewButtonText;
  String? editContractViewButtonText;
  String? editCommitmentViewButtonText;
  String? resetPasswordViewButtonText;
  String? editProfileViewButtonText;
  String? editEmailViewButtonText;
  String? editPasswordViewButtonText;
  String? editContractViewDeleteContractButtonText;
  String? signInViewButtonText;
  String? signUpViewButtonText;
  String? mainViewSettingsLogoutButtonText;
  String? mainViewResendEmailVerificationButtonText;

  // Placeholders
  String? newContractViewContractTitlePlaceholder;
  String? newCommitmentViewCommitmentPlaceholder;
  String? editContractViewContractTitlePlaceholder;
  String? editCommitmentViewCommitmentPlaceholder;
  String? resetPasswordViewEmailPlaceholder;
  String? editProfileViewUsernamePlaceholder;
  String? editEmailViewEmailPlaceholder;
  String? editEmailViewNewEmailPlaceholder;
  String? signUpViewUsernamePlaceholder;
  String? signInUpViewEmailPlaceholder;
  String? signInUpViewPasswordPlaceholder;
  String? addCommitmentViewCounterpartyPlaceholder;
  String? addCommitmentViewProofPlaceholder;
  String? addCommitmentViewResolutionPlaceholder;
  String? editProfileViewNewPasswordPlaceholder;
  String? editProfileViewRepeatNewPasswordPlaceholder;

  // Error Messages
  String? newContractViewContractTitleErrorMessage;
  String? newCommitmentViewCommitmentErrorMessage;
  String? editContractViewContractTitleErrorMessage;
  String? editCommitmentViewCommitmentErrorMessage;
  String? resetPasswordViewEmailErrorMessage;
  String? editProfileViewUsernameErrorMessage;
  String? editEmailViewEmailErrorMessage;
  String? editEmailViewNewEmailErrorMessage;
  String? signUpViewUsernameErrorMessage;
  String? signInUpViewEmailErrorMessage;
  String? signInUpViewPasswordErrorMessage;
  String? mainViewNoContractsErrorMessage;
  String? mainViewNoCommitmentsErrorMessage;
  String? mainViewNoNotificationsErrorMessage;
  String? genericAuthErrorMessage;
  String? genericFirebaseErrorMessage;
  String? editPasswordViewNewPasswordErrorMessage;
  String? editPasswordViewRepeatNewPasswordErrorMessage;

  // Links
  String? signInViewResetPasswordLink;
  String? signInViewSignUpUsingEmailLink;
  String? signInViewgoBackToSignInLink;
  String? mainViewDismissebleEditCommitmentLink;
  String? mainViewDismissebleDeleteCommitmentLink;
  String? mainViewDismissebleMarkNotificationReadLink;

  // Labels
  String? mainViewSettingEditProfileLabel;
  String? mainViewSettingEditEmailLabel;
  String? mainViewSettingEditPasswordLabel;
  String? mainViewSettingsLanguageLabel;
  String? mainViewSettingsThemeLabel;
  String? mainViewSettingsBiometricsLabel;
  String? mainViewSettingsAnalyticsLabel;
  String? mainViewSelfLabel;

  // Messages
  String? mainViewUnverifiedEmailMessage;
  String? editEmailViewSignOutMessage;
  String? editPasswordViewSignOutMessage;

  // Headers
  String? mainViewNotificationHeader;

  // Push notifications titles
  String? activateContractNotificationTitle;

  // Push notifications bodies
  String? activateContractNotificationBody;

  // Email titles
  String? welcomeEmailTitle;
  String? verifyEmailEmailTitle;
  String? resetPasswordEmailTitle;
  String? addContractEmailTitle;
  String? editProfileViewEmailTitle;
  String? editEmailViewEmailTitle;
  String? editPasswordViewEmailTitle;

  // Email bodies
  String? welcomeEmailBody;
  String? verifyEmailEmailBody;
  String? resetPasswordEmailBody;
  String? addContractEmailBody;
  String? editProfileViewEmailBody;
  String? editEmailViewEmailBody;
  String? editPasswordViewEmailBody;

  /// Function to switch the language immediately
  void switchLanguage(_language) {
    // Titles
    mainViewAppBarTitle = _mainViewAppBarTitle?[_language].toString();
    newContractViewAppBarTitle =
        _newContractViewAppBarTitle?[_language].toString();
    newCommitmentViewAppBarTitle =
        _newCommitmentViewAppBarTitle?[_language].toString();
    editContractViewAppBarTitle =
        _editContractViewAppBarTitle?[_language].toString();
    editCommitmentViewAppBarTitle =
        _editCommitmentViewAppBarTitle?[_language].toString();
    resetPasswordViewAppBarTitle =
        _resetPasswordViewAppBarTitle?[_language].toString();
    editProfileViewAppBarTitle =
        _editProfileViewAppBarTitle?[_language].toString();
    editEmailViewAppBarTitle = _editEmailViewAppBarTitle?[_language].toString();
    editPasswordViewAppBarTitle =
        _editPasswordViewAppBarTitle?[_language].toString();
    signInViewAppBarTitle = _signInViewAppBarTitle?[_language].toString();
    signUpViewAppBarTitle = _signUpViewAppBarTitle?[_language].toString();
    // DropdownLists
    mainViewLanguageDropdownList = _mainViewLanguageDropdownList;
    addEditCommitmentProofDropdownList =
        _addEditCommitmentProofDropdownList[_language];
    addEditCommitmentResolutionDropdownList =
        _addEditCommitmentResolutionDropdownList[_language];
    // Buttons
    newContractViewButtonText =
        _newContractViewButtonText?[_language].toString();
    newCommitmentViewButtonText =
        _newCommitmentViewButtonText?[_language].toString();
    editContractViewButtonText =
        _editContractViewButtonText?[_language].toString();
    editCommitmentViewButtonText =
        _editCommitmentViewButtonText?[_language].toString();
    resetPasswordViewButtonText =
        _resetPasswordViewButtonText?[_language].toString();
    editProfileViewButtonText =
        _editProfileViewButtonText?[_language].toString();
    editEmailViewButtonText = _editEmailViewButtonText?[_language].toString();
    editPasswordViewButtonText =
        _editPasswordViewButtonText?[_language].toString();
    editContractViewDeleteContractButtonText =
        _editContractViewDeleteContractButtonText?[_language].toString();
    signInViewButtonText = _signInViewButtonText?[_language].toString();
    signUpViewButtonText = _signUpViewButtonText?[_language].toString();
    mainViewSettingsLogoutButtonText =
        _mainViewSettingsLogoutButtonText?[_language].toString();
    mainViewResendEmailVerificationButtonText =
        _mainViewResendEmailVerificationButtonText?[_language].toString();
    // Placeholder
    newContractViewContractTitlePlaceholder =
        _newContractViewContractTitlePlaceholder?[_language].toString();
    newCommitmentViewCommitmentPlaceholder =
        _newCommitmentViewCommitmentPlaceholder?[_language].toString();
    editContractViewContractTitlePlaceholder =
        _editContractViewContractTitlePlaceholder?[_language].toString();
    editCommitmentViewCommitmentPlaceholder =
        _editCommitmentViewCommitmentPlaceholder?[_language].toString();
    resetPasswordViewEmailPlaceholder =
        _resetPasswordViewEmailPlaceholder?[_language].toString();
    editProfileViewUsernamePlaceholder =
        _editProfileViewUsernamePlaceholder?[_language].toString();
    editEmailViewEmailPlaceholder =
        _editEmailViewEmailPlaceholder?[_language].toString();
    editEmailViewNewEmailPlaceholder =
        _editEmailViewNewEmailPlaceholder?[_language].toString();
    signUpViewUsernamePlaceholder =
        _signUpViewUsernamePlaceholder?[_language].toString();
    signInUpViewEmailPlaceholder =
        _signInUpViewEmailPlaceholder?[_language].toString();
    signInUpViewPasswordPlaceholder =
        _signInUpViewPasswordPlaceholder?[_language].toString();
    addCommitmentViewCounterpartyPlaceholder =
        _addCommitmentViewCounterpartyPlaceholder?[_language].toString();
    addCommitmentViewProofPlaceholder =
        _addCommitmentViewProofPlaceholder?[_language].toString();
    addCommitmentViewResolutionPlaceholder =
        _addCommitmentViewResolutionPlaceholder?[_language].toString();
    editProfileViewNewPasswordPlaceholder =
        _editProfileViewNewPasswordPlaceholder?[_language].toString();
    editProfileViewRepeatNewPasswordPlaceholder =
        _editProfileViewRepeatNewPasswordPlaceholder?[_language].toString();
    // Error messages
    newContractViewContractTitleErrorMessage =
        _newContractViewContractTitleErrorMessage?[_language].toString();
    newCommitmentViewCommitmentErrorMessage =
        _newCommitmentViewCommitmentErrorMessage?[_language].toString();
    editContractViewContractTitleErrorMessage =
        _editContractViewContractTitleErrorMessage?[_language].toString();
    editCommitmentViewCommitmentErrorMessage =
        _editCommitmentViewCommitmentErrorMessage?[_language].toString();
    resetPasswordViewEmailErrorMessage =
        _resetPasswordViewEmailErrorMessage?[_language].toString();
    signUpViewUsernameErrorMessage =
        _signUpViewUsernameErrorMessage?[_language].toString();
    signInUpViewEmailErrorMessage =
        _signInUpViewEmailErrorMessage?[_language].toString();
    signInUpViewPasswordErrorMessage =
        _signInUpViewPasswordErrorMessage?[_language].toString();
    editProfileViewUsernameErrorMessage =
        _editProfileViewUsernameErrorMessage?[_language].toString();
    editEmailViewEmailErrorMessage =
        _editEmailViewEmailErrorMessage?[_language].toString();
    editEmailViewNewEmailErrorMessage =
        _editEmailViewNewEmailErrorMessage?[_language].toString();
    mainViewNoContractsErrorMessage =
        _mainViewNoContractsErrorMessage?[_language].toString();
    mainViewNoCommitmentsErrorMessage =
        _mainViewNoCommitmentsErrorMessage?[_language].toString();
    mainViewNoNotificationsErrorMessage =
        _mainViewNoNotificationsErrorMessage?[_language].toString();
    genericAuthErrorMessage = _genericAuthErrorMessage?[_language].toString();
    genericFirebaseErrorMessage =
        _genericFirebaseErrorMessage?[_language].toString();
    editPasswordViewNewPasswordErrorMessage =
        _editPasswordViewNewPasswordErrorMessage?[_language].toString();
    editPasswordViewRepeatNewPasswordErrorMessage =
        _editPasswordViewRepeatNewPasswordErrorMessage?[_language].toString();
    // Links
    signInViewResetPasswordLink =
        _signInViewResetPasswordLink?[_language].toString();
    signInViewSignUpUsingEmailLink =
        _signInViewSignUpUsingEmailLink?[_language].toString();
    signInViewgoBackToSignInLink =
        _signInViewgoBackToSignInLink?[_language].toString();
    mainViewDismissebleEditCommitmentLink =
        _mainViewDismissebleEditCommitmentLink?[_language].toString();
    mainViewDismissebleDeleteCommitmentLink =
        _mainViewDismissebleDeleteCommitmentLink?[_language].toString();
    mainViewDismissebleMarkNotificationReadLink =
        _mainViewDismissebleMarkNotificationReadLink?[_language].toString();
    // Labels
    mainViewSettingEditProfileLabel =
        _mainViewSettingEditProfileLabel?[_language].toString();
    mainViewSettingEditEmailLabel =
        _mainViewSettingEditEmailLabel?[_language].toString();
    mainViewSettingEditPasswordLabel =
        _mainViewSettingEditPasswordLabel?[_language].toString();
    mainViewSettingsLanguageLabel =
        _mainViewSettingsLanguageLabel?[_language].toString();
    mainViewSettingsThemeLabel =
        _mainViewSettingsThemeLabel?[_language].toString();
    mainViewSettingsBiometricsLabel =
        _mainViewSettingsBiometricsLabel?[_language].toString();
    mainViewSettingsAnalyticsLabel =
        _mainViewSettingsAnalyticsLabel?[_language].toString();
    mainViewSelfLabel = _mainViewSelfLabel?[_language].toString();
    // Messages
    mainViewUnverifiedEmailMessage =
        _mainViewUnverifiedEmailMessage?[_language].toString();
    editEmailViewSignOutMessage =
        _editEmailViewSignOutMessage?[_language].toString();
    editPasswordViewSignOutMessage =
        _editPasswordViewSignOutMessage?[_language].toString();
    // Header
    mainViewNotificationHeader =
        _mainViewNotificationHeader?[_language].toString();
    // Push notifications titles
    activateContractNotificationTitle =
        _activateContractNotificationTitle?[_language].toString();
    // Push notifications bodies
    activateContractNotificationBody =
        _activateContractNotificationBody?[_language].toString();
    // Email titles
    welcomeEmailTitle = _welcomeEmailTitle?[_language].toString();
    verifyEmailEmailTitle = _confirmAccountEmailTitle?[_language].toString();
    resetPasswordEmailTitle = _resetPasswordEmailTitle?[_language].toString();
    addContractEmailTitle = _addContractEmailTitle?[_language].toString();
    editProfileViewEmailTitle =
        _editProfileViewEmailTitle?[_language].toString();
    editEmailViewEmailTitle = _editEmailViewEmailTitle?[_language].toString();
    editPasswordViewEmailTitle =
        _editPasswordViewEmailTitle?[_language].toString();

    // Email bodies
    welcomeEmailBody = _welcomeEmailBody?[_language].toString();
    verifyEmailEmailBody = _verifyEmailEmailBody?[_language].toString();
    resetPasswordEmailBody = _resetPasswordEmailBody?[_language].toString();
    addContractEmailBody = _addContractEmailBody?[_language].toString();
    editProfileViewEmailBody = _editProfileViewEmailBody?[_language].toString();
    editEmailViewEmailBody = _editEmailViewEmailBody?[_language].toString();
    editPasswordViewEmailBody =
        _editPasswordViewEmailBody?[_language].toString();
  }
}
