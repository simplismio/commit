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

  /// Inituate supported languages list for MainView
  static List<String> languages = ['English', 'Dutch'];

  /// Toggle value language
  late String _language;
  late Map<String, dynamic> translations;

  static String? systemLanguage;
  static String? defaultLanguage;

  /// Getter for the language setting
  String get language => _language;

  /// Language model class constructor
  /// Initialize _language variable
  /// Loads latest language setting from SharedPreferences
  LanguageModel() {
    _language = 'English';
    loadFromPrefs();
  }

  /// Function to set the language
  setLanguage(_value) {
    _language = _value;
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
        defaultLanguage = 'Dutch';
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
    'Dutch': 'Contracten'
  };
  final Map<String, String>? _newContractViewAppBarTitle = {
    'English': 'New contract',
    'Dutch': 'Nieuw contract'
  };
  final Map<String, String>? _newCommitmentViewAppBarTitle = {
    'English': 'New commitment',
    'Dutch': 'Nieuw commitment'
  };
  final Map<String, String>? _editContractViewAppBarTitle = {
    'English': 'Edit contract',
    'Dutch': 'Wijzig contract'
  };
  final Map<String, String>? _editCommitmentViewAppBarTitle = {
    'English': 'Edit commitment',
    'Dutch': 'Wijzig commitment'
  };
  final Map<String, String>? _resetPasswordViewAppBarTitle = {
    'English': 'Reset password',
    'Dutch': 'Reset wachtwoord'
  };
  final Map<String, String>? _editProfileViewAppBarTitle = {
    'English': 'Edit profile',
    'Dutch': 'Wijzig profiel'
  };
  final Map<String, String>? _signInViewAppBarTitle = {
    'English': 'Sign in',
    'Dutch': 'Log in'
  };
  final Map<String, String>? _signUpViewAppBarTitle = {
    'English': 'Sign up',
    'Dutch': 'Registreer'
  };

  // Dropdown Lists
  final Map<String, List<String>> _mainViewLanguageDropdownList = {
    'English': ['English', 'Dutch'],
    'Dutch': ['Engels', 'Nederlands'],
  };
  final Map<String, List<String>> _addEditCommitmentProofDropdownList = {
    'English': ['Bank statement', 'Transaction'],
    'Dutch': ['Bankafschrift', 'Transactie'],
  };
  final Map<String, List<String>> _addEditCommitmentResolutionDropdownList = {
    'English': ['Payment', 'Blacklist'],
    'Dutch': ['Betaling', 'Zwarte lijst'],
  };

  // Buttons
  final Map<String, String>? _newContractViewButtonText = {
    'English': 'Save contract',
    'Dutch': 'Contract opslaan'
  };
  final Map<String, String>? _newCommitmentViewButtonText = {
    'English': 'Save commitment',
    'Dutch': 'Commitment opslaan'
  };
  final Map<String, String>? _editContractViewButtonText = {
    'English': 'Save changes',
    'Dutch': 'Wijzigingn opslaan'
  };
  final Map<String, String>? _editCommitmentViewButtonText = {
    'English': 'Save changes',
    'Dutch': 'Wijzigingn opslaan'
  };
  final Map<String, String>? _resetPasswordViewButtonText = {
    'English': 'Email reset link',
    'Dutch': 'Email reset link'
  };
  final Map<String, String>? _editProfileViewButtonText = {
    'English': 'Save changes',
    'Dutch': 'Wijzingen opslaan'
  };
  final Map<String, String>? _editContractViewDeleteContractButtonText = {
    'English': 'Delete contract',
    'Dutch': 'Contract verwijderen'
  };
  final Map<String, String>? _signInViewButtonText = {
    'English': 'Sign in',
    'Dutch': 'Log in'
  };
  final Map<String, String>? _signUpViewButtonText = {
    'English': 'Sign up',
    'Dutch': 'Registreer'
  };
  final Map<String, String>? _mainViewSettingsLogoutButtonText = {
    'English': 'Log out',
    'Dutch': 'Uitloggen'
  };
  final Map<String, String>? _mainViewResendEmailVerificationButtonText = {
    'English': 'Resend',
    'Dutch': 'Opnieuw'
  };

  // Placeholders
  final Map<String, String>? _newContractViewContractTitlePlaceholder = {
    'English': 'Contract title',
    'Dutch': 'Titel van het contract'
  };
  final Map<String, String>? _newCommitmentViewCommitmentPlaceholder = {
    'English': 'I promise to..',
    'Dutch': 'Ik beloof om ..'
  };
  final Map<String, String>? _editContractViewContractTitlePlaceholder = {
    'English': 'Contract title',
    'Dutch': 'Titel van het contract'
  };
  final Map<String, String>? _editCommitmentViewCommitmentPlaceholder = {
    'English': 'Commitment',
    'Dutch': 'Commitment'
  };
  final Map<String, String>? _resetPasswordViewEmailPlaceholder = {
    'English': 'Email',
    'Dutch': 'Email'
  };
  final Map<String, String>? _editProfileViewUsernamePlaceholder = {
    'English': 'Username',
    'Dutch': 'Gebruikersnaam'
  };
  final Map<String, String>? _editProfileViewEmailPlaceholder = {
    'English': 'Email',
    'Dutch': 'Email'
  };
  final Map<String, String>? _signUpViewUsernamePlaceholder = {
    'English': 'Username',
    'Dutch': 'Gebruikersnaam'
  };
  final Map<String, String>? _signInUpViewEmailPlaceholder = {
    'English': 'Email',
    'Dutch': 'Email'
  };
  final Map<String, String>? _signInUpViewPasswordPlaceholder = {
    'English': 'Password',
    'Dutch': 'Wachtwoord'
  };
  final Map<String, String>? _addCommitmentCounterpartyPlaceholder = {
    'English': 'Choose counterparty',
    'Dutch': 'Kies tegenpartij'
  };
  final Map<String, String>? _addCommitmentProofPlaceholder = {
    'English': 'Choose proof mechanism for fulfillment',
    'Dutch': 'Kies de bewijsvorm voor nakoming'
  };
  final Map<String, String>? _addCommitmentResolutionPlaceholder = {
    'English': 'Choose resolution mechanism if non-compliant',
    'Dutch': 'Kies de resolutievorm bij niet na-koming'
  };

  // Error Messages
  final Map<String, String>? _newContractViewContractTitleErrorMessage = {
    'English': 'Please provide a valid contract title',
    'Dutch': 'De ingegeven contract titel is incorrect'
  };
  final Map<String, String>? _newCommitmentViewCommitmentErrorMessage = {
    'English': 'Please provide a valid commitment',
    'Dutch': 'Het ingegeven commitment is incorrect'
  };
  final Map<String, String>? _editContractViewContractTitleErrorMessage = {
    'English': 'Please provide a valid contract title',
    'Dutch': 'De ingegeven contract title is incorrect'
  };
  final Map<String, String>? _editCommitmentViewCommitmentErrorMessage = {
    'English': 'Please provide a valid commitment',
    'Dutch': 'Het ingegeven commitment is incorrect'
  };
  final Map<String, String>? _resetPasswordViewEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Dutch': 'Het ingegeven email adres is incorrect'
  };
  final Map<String, String>? _editProfileViewUsernameErrorMessage = {
    'English': 'Please provide a valid username',
    'Dutch': 'De ingegeven gebruikersnaam is incorrect'
  };
  final Map<String, String>? _signUpViewUsernameErrorMessage = {
    'English': 'Please provide a valid username',
    'Dutch': 'Het ingegeven wachtwoord is incorrect'
  };
  final Map<String, String>? _signInUpViewEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Dutch': 'De ingegeven gebruikersnaam is incorrect'
  };
  final Map<String, String>? _signInUpViewPasswordErrorMessage = {
    'English': 'testEN',
    'Dutch': 'Er zijn nog geen commitments gemaakt'
  };
  final Map<String, String>? _mainViewNoContractsErrorMessage = {
    'English': 'There are no contracts yet',
    'Dutch': 'Er zijn nog geen contracten'
  };
  final Map<String, String>? _mainViewNoCommitmentsErrorMessage = {
    'English': 'There are no commitments yet',
    'Dutch': 'Er zijn nog geen commitments gemaakt'
  };
  final Map<String, String>? _mainViewNoNotificationsErrorMessage = {
    'English': 'There are no notifications yet',
    'Dutch': 'Er zijn nog geen notificaties'
  };
  final Map<String, String>? _genericAuthErrorMessage = {
    'English': 'Email address or password is incorrect',
    'Dutch': 'Email adres of wachtwoord is incorrect'
  };
  final Map<String, String>? _genericFirebaseErrorMessage = {
    'English': 'Something went wrong. Please try again',
    'Dutch': 'Er is iets verkeerd gegaan. Probeert u het s.v.p. opnieuw'
  };

  // Links
  final Map<String, String>? _signInViewResetPasswordLink = {
    'English': 'I forgot my password',
    'Dutch': 'Ik ben mijn wachtwoord vergeten'
  };
  final Map<String, String>? _signInViewSignUpUsingEmailLink = {
    'English': 'Sign up using email',
    'Dutch': 'Registreer met een email adres'
  };
  final Map<String, String>? _signInViewgoBackToSignInLink = {
    'English': 'Go back to sign in',
    'Dutch': 'Ga terug naar log in'
  };
  final Map<String, String>? _mainViewDismissebleEditCommitmentLink = {
    'English': 'Edit commitment',
    'Dutch': 'Wijzig commitment'
  };
  final Map<String, String>? _mainViewDismissebleDeleteCommitmentLink = {
    'English': 'Delete commitment',
    'Dutch': 'Verwijder commitment'
  };
  final Map<String, String>? _mainViewDismissebleMarkNotificationReadLink = {
    'English': 'Mark as read',
    'Dutch': 'Markeren als gelezen'
  };

  // Labels
  final Map<String, String>? _mainViewSettingEditProfileLabel = {
    'English': 'Edit profile',
    'Dutch': 'Wijzig profiel'
  };
  final Map<String, String>? _mainViewSettingsLanguageLabel = {
    'English': 'Language',
    'Dutch': 'Taal'
  };
  final Map<String, String>? _mainViewSettingsThemeLabel = {
    'English': 'Dark theme',
    'Dutch': 'Donker thema'
  };
  final Map<String, String>? _mainViewSettingsBiometricsLabel = {
    'English': 'Biometric unlock',
    'Dutch': 'Unlock met biometrie'
  };
  final Map<String, String>? _mainViewSettingsAnalyticsLabel = {
    'English': 'Share analytics',
    'Dutch': 'Deel gebruiksgegevens'
  };
  final Map<String, String>? _mainViewSelfLabel = {
    'English': 'you',
    'Dutch': 'jijzelf'
  };
  final Map<String, String>? _mainViewUnverifiedEmailLabel = {
    'English': 'Verify your email',
    'Dutch': 'Bevestig je email adres'
  };

  // Headers
  final Map<String, String>? _mainViewNotificationHeader = {
    'English': 'Notifications',
    'Dutch': 'Notificaties'
  };

  // Push notifications titles
  final Map<String, String>? _activateContractNotificationTitle = {
    'English': 'Contract activated',
    'Dutch': 'Contract geactiveerd'
  };

  // Push notifications bodies
  final Map<String, String>? _activateContractNotificationBody = {
    'English': 'Click to add commitment to the contract',
    'Dutch': 'Contract geactiveerd'
  };

  // Email titles
  final Map<String, String>? _welcomeEmailTitle = {
    'English': 'Welcome to Commit',
    'Dutch': 'Welkom bij Commit'
  };
  final Map<String, String>? _confirmAccountEmailTitle = {
    'English': 'Confirm your email address',
    'Dutch': 'Bevestig je email address'
  };
  final Map<String, String>? _resetPasswordEmailTitle = {
    'English': 'Reset your password',
    'Dutch': 'Wijzig je wachtwoord'
  };
  final Map<String, String>? _addContractEmailTitle = {
    'English': 'You have been added to a new contract',
    'Dutch': 'Je bent toegevoegd aan een contract'
  };

  // Email bodies
  final Map<String, String>? _welcomeEmailBody = {
    'English': 'You have made the right decision to commit',
    'Dutch': 'Je hebt het juiste besluit genomen om je te commiteren'
  };
  final Map<String, String>? _verifyEmailEmailBody = {
    'English': 'Please confirm your email address by clicking on the link',
    'Dutch': 'Bevestig je email adres via onderstaande link'
  };
  final Map<String, String>? _resetPasswordEmailBody = {
    'English': 'Please click the link to reset your password',
    'Dutch': 'Reset je wachtwoord via de link'
  };
  final Map<String, String>? _addContractEmailBody = {
    'English': 'You have been added as a participant in a new contract',
    'Dutch': 'Je bent toegevoegd aan een contract'
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
  String? signInViewAppBarTitle;
  String? signUpViewAppBarTitle;

  // Dropdown lists
  List<String>? mainViewlanguageDropdownList;
  List<String>? addEditCommitmentProofDropdownList;
  List<String>? addEditCommitmentResolutionDropdownList;

  // Buttons
  String? newContractViewButtonText;
  String? newCommitmentViewButtonText;
  String? editContractViewButtonText;
  String? editCommitmentViewButtonText;
  String? resetPasswordViewButtonText;
  String? editProfileViewButtonText;
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
  String? editProfileViewEmailPlaceholder;
  String? signUpViewUsernamePlaceholder;
  String? signInUpViewEmailPlaceholder;
  String? signInUpViewPasswordPlaceholder;
  String? addCommitmentCounterpartyPlaceholder;
  String? addCommitmentProofPlaceholder;
  String? addCommitmentResolutionPlaceholder;

  // Error Messages
  String? newContractViewContractTitleErrorMessage;
  String? newCommitmentViewCommitmentErrorMessage;
  String? editContractViewContractTitleErrorMessage;
  String? editCommitmentViewCommitmentErrorMessage;
  String? resetPasswordViewEmailErrorMessage;
  String? editProfileViewUsernameErrorMessage;
  String? signUpViewUsernameErrorMessage;
  String? signInUpViewEmailErrorMessage;
  String? signInUpViewPasswordErrorMessage;
  String? mainViewNoContractsErrorMessage;
  String? mainViewNoCommitmentsErrorMessage;
  String? mainViewNoNotificationsErrorMessage;
  String? genericAuthErrorMessage;
  String? genericFirebaseErrorMessage;

  // Links
  String? signInViewResetPasswordLink;
  String? signInViewSignUpUsingEmailLink;
  String? signInViewgoBackToSignInLink;
  String? mainViewDismissebleEditCommitmentLink;
  String? mainViewDismissebleDeleteCommitmentLink;
  String? mainViewDismissebleMarkNotificationReadLink;

  // Labels
  String? mainViewSettingEditProfileLabel;
  String? mainViewSettingsLanguageLabel;
  String? mainViewSettingsThemeLabel;
  String? mainViewSettingsBiometricsLabel;
  String? mainViewSettingsAnalyticsLabel;
  String? mainViewSelfLabel;
  String? mainViewUnverifiedEmailLabel;

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

  // Email bodies
  String? welcomeEmailBody;
  String? verifyEmailEmailBody;
  String? resetPasswordEmailBody;
  String? addContractEmailBody;

  /// Function to switch the language immediately
  void switchLanguage(_language) {
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
    signInViewAppBarTitle = _signInViewAppBarTitle?[_language].toString();
    signUpViewAppBarTitle = _signUpViewAppBarTitle?[_language].toString();
    // DropdownLists
    mainViewlanguageDropdownList = _mainViewLanguageDropdownList[_language];
    addEditCommitmentResolutionDropdownList =
        _addEditCommitmentResolutionDropdownList[_language];
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
    editProfileViewEmailPlaceholder =
        _editProfileViewEmailPlaceholder?[_language].toString();
    signUpViewUsernamePlaceholder =
        _signUpViewUsernamePlaceholder?[_language].toString();
    signInUpViewEmailPlaceholder =
        _signInUpViewEmailPlaceholder?[_language].toString();
    signInUpViewPasswordPlaceholder =
        _signInUpViewPasswordPlaceholder?[_language].toString();
    addCommitmentCounterpartyPlaceholder =
        _addCommitmentCounterpartyPlaceholder?[_language].toString();
    addCommitmentProofPlaceholder =
        _addCommitmentProofPlaceholder?[_language].toString();
    addCommitmentResolutionPlaceholder =
        _addCommitmentResolutionPlaceholder?[_language].toString();
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
    mainViewNoContractsErrorMessage =
        _mainViewNoContractsErrorMessage?[_language].toString();
    mainViewNoCommitmentsErrorMessage =
        _mainViewNoCommitmentsErrorMessage?[_language].toString();
    mainViewNoNotificationsErrorMessage =
        _mainViewNoNotificationsErrorMessage?[_language].toString();
    genericAuthErrorMessage = _genericAuthErrorMessage?[_language].toString();
    genericFirebaseErrorMessage =
        _genericFirebaseErrorMessage?[_language].toString();
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
    mainViewSettingsLanguageLabel =
        _mainViewSettingsLanguageLabel?[_language].toString();
    mainViewSettingsThemeLabel =
        _mainViewSettingsThemeLabel?[_language].toString();
    mainViewSettingsBiometricsLabel =
        _mainViewSettingsBiometricsLabel?[_language].toString();
    mainViewSettingsAnalyticsLabel =
        _mainViewSettingsAnalyticsLabel?[_language].toString();
    mainViewSelfLabel = _mainViewSelfLabel?[_language].toString();
    mainViewUnverifiedEmailLabel =
        _mainViewUnverifiedEmailLabel?[_language].toString();
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
    // Email bodies
    welcomeEmailBody = _welcomeEmailBody?[_language].toString();
    verifyEmailEmailBody = _verifyEmailEmailBody?[_language].toString();
    resetPasswordEmailBody = _resetPasswordEmailBody?[_language].toString();
    addContractEmailBody = _addContractEmailBody?[_language].toString();
  }
}
