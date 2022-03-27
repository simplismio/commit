import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static List<String> languages = ['English', 'Dutch'];
  final String key = "language";

  late String _language;
  late Map<String, dynamic> translations;

  // AppBar titles
  String? mainScreenAppBarTitle;
  String? newContractScreenAppBarTitle;
  String? newCommitmentScreenAppBarTitle;
  String? editContractScreenAppBarTitle;
  String? editCommitmentScreenAppBarTitle;
  String? resetPasswordScreenAppBarTitle;
  String? signInScreenAppBarTitle;
  String? signUpScreenAppBarTitle;
  // Buttons
  String? newContractScreenButtonText;
  String? newCommitmentScreenButtonText;
  String? editContractScreenButtonText;
  String? editCommitmentScreenButtonText;
  String? resetPasswordScreenButtonText;
  String? editContractScreenDeleteContractButtonText;
  String? signInScreenButtonText;
  String? signUpScreenButtonText;
  // Placeholders
  String? newContractScreenContractTitlePlaceholder;
  String? newCommitmentScreenCommitmentPlaceholder;
  String? editContractScreenContractTitlePlaceholder;
  String? editCommitmentScreenCommitmentPlaceholder;
  String? resetPasswordScreenEmailPlaceholder;
  String? signUpScreenUsernamePlaceholder;
  String? signInUpScreenEmailPlaceholder;
  String? signInUpScreenPasswordPlaceholder;
  // Error Messages
  String? newContractScreenContractTitleErrorMessage;
  String? newCommitmentScreenCommitmentErrorMessage;
  String? editContractScreenContractTitleErrorMessage;
  String? editCommitmentScreenCommitmentErrorMessage;
  String? resetPasswordScreenEmailErrorMessage;
  String? signUpScreenUsernameErrorMessage;
  String? signInUpScreenEmailErrorMessage;
  String? signInUpScreenPasswordErrorMessage;
  String? mainScreenNoContractsErrorMessage;
  String? mainScreenNoCommitmentsErrorMessage;
  String? genericAuthErrorMessage;
  String? genericFirebaseErrorMessage;
  // Links
  String? signInScreenResetPasswordLink;
  String? signInScreenSignUpUsingEmailLink;
  String? signInScreengoBackToSignInLink;
  String? mainScreenDismissebleEditCommitmentLink;
  String? mainScreenDismissebleDeleteCommitmentLink;

  LanguageService() {
    _language = 'English';
    _loadFromPrefs();
  }

  String get language => _language;

  setLanguage(_value) {
    _language = _value;
    _saveToPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _language = _pref.getString(key) ?? 'English';
    _switchLanguage(_language);
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setString(key, _language);
    _switchLanguage(_language);
    notifyListeners();
  }

  void _switchLanguage(_language) {
    switch (_language) {
      case 'English':
        // AppBar Titles
        mainScreenAppBarTitle = 'Contracts';
        newContractScreenAppBarTitle = 'New contract';
        newCommitmentScreenAppBarTitle = 'New commitment';
        editContractScreenAppBarTitle = 'Edit contract';
        editCommitmentScreenAppBarTitle = 'Edit commitment';
        resetPasswordScreenAppBarTitle = 'Reset password';
        signInScreenAppBarTitle = 'Sign in';
        signUpScreenAppBarTitle = 'Sign up';
        // Buttons
        newContractScreenButtonText = 'Save contract';
        newCommitmentScreenButtonText = 'Save commitments';
        editContractScreenButtonText = 'Edit contract';
        editCommitmentScreenButtonText = 'Edit commitment';
        resetPasswordScreenButtonText = 'Email reset link';
        editContractScreenDeleteContractButtonText = 'Delete contract';
        signInScreenButtonText = 'Sign in';
        signUpScreenButtonText = 'Sign up';
        // Placeholder
        newContractScreenContractTitlePlaceholder = 'Contract title';
        newCommitmentScreenCommitmentPlaceholder = 'Commitment';
        editContractScreenContractTitlePlaceholder = 'Contract title';
        editCommitmentScreenCommitmentPlaceholder = 'Commitment';
        resetPasswordScreenEmailPlaceholder = 'Email address';
        signUpScreenUsernamePlaceholder = 'Username';
        signInUpScreenEmailPlaceholder = 'Email address';
        signInUpScreenPasswordPlaceholder = 'Password';
        // Error Messages
        newContractScreenContractTitleErrorMessage =
            'Please provide a valid contract title';
        newCommitmentScreenCommitmentErrorMessage =
            'Please provide a valid commitment';
        editContractScreenContractTitleErrorMessage =
            'Please provide a valid contract title';
        editCommitmentScreenCommitmentErrorMessage =
            'Please provide a valid commitment';
        resetPasswordScreenEmailErrorMessage =
            'Please provide a valid email address';
        signUpScreenUsernameErrorMessage = 'Please provide a valid username';
        signInUpScreenEmailErrorMessage =
            'Please provide a valid email address';
        signInUpScreenPasswordErrorMessage = 'Please provide a valid password';
        mainScreenNoContractsErrorMessage = 'There are no contracts yet';
        mainScreenNoCommitmentsErrorMessage = 'There are no commitments yet';
        genericAuthErrorMessage = 'Email address or password is incorrect';
        genericFirebaseErrorMessage = 'Something went wrong. Please try again';
        // Links
        signInScreenResetPasswordLink = 'I forgot my password';
        signInScreenSignUpUsingEmailLink = 'Sign up using email';
        signInScreengoBackToSignInLink = 'Go back to sign in';
        mainScreenDismissebleEditCommitmentLink = 'Edit commitment';
        mainScreenDismissebleDeleteCommitmentLink = 'Delete commitment';
        break;
      case 'Dutch':
        // AppBar Titles
        mainScreenAppBarTitle = 'Contracten';
        newContractScreenAppBarTitle = 'Nieuw contract';
        newCommitmentScreenAppBarTitle = 'Nieuw commitment';
        editContractScreenAppBarTitle = 'Wijzig contract';
        editCommitmentScreenAppBarTitle = 'Wijzig commitment';
        resetPasswordScreenAppBarTitle = 'Wachtwoord reset';
        signInScreenAppBarTitle = 'Log in';
        signUpScreenAppBarTitle = 'Registreer';
        // Buttons
        newContractScreenButtonText = 'Contract opslaan';
        newCommitmentScreenButtonText = 'Commitment opslaan';
        editContractScreenButtonText = 'Wijzig contract';
        editCommitmentScreenButtonText = 'Wijzig commitment';
        resetPasswordScreenButtonText = 'Email reset link';
        editContractScreenDeleteContractButtonText = 'Verwijder contract';
        signInScreenButtonText = 'Log In';
        signUpScreenButtonText = 'Registreer';
        // Placeholders
        newContractScreenContractTitlePlaceholder = 'Contract Titel';
        newCommitmentScreenCommitmentPlaceholder = 'Commitment';
        editContractScreenContractTitlePlaceholder = 'Contract Titel';
        editCommitmentScreenCommitmentPlaceholder = 'Commitment';
        resetPasswordScreenEmailPlaceholder = 'Email';
        signUpScreenUsernamePlaceholder = 'Gebruikersnaam';
        signInUpScreenEmailPlaceholder = 'Email';
        signInUpScreenPasswordPlaceholder = 'Wachtwoord';
        // Error Messages
        newContractScreenContractTitleErrorMessage =
            'De ingegeven contract titel is incorrect';
        newCommitmentScreenCommitmentErrorMessage =
            'Het ingegeven commitment is incorrect';
        editContractScreenContractTitleErrorMessage =
            'De ingegeven contract title is incorrect';
        editCommitmentScreenCommitmentErrorMessage =
            'Het ingegeven commitment is incorrect';
        resetPasswordScreenEmailErrorMessage =
            'Het ingegeven email adres is incorrect';
        signUpScreenUsernameErrorMessage =
            'De ingegeven gebruikersnaam is incorrect';
        signInUpScreenEmailErrorMessage =
            'Het ingegeven email adres is incorrect';
        signInUpScreenPasswordErrorMessage =
            'Het ingegeven wachtwoord is incorrect';
        mainScreenNoContractsErrorMessage =
            'Er zijn nog geen contracten opgesteld';
        mainScreenNoCommitmentsErrorMessage =
            'Er zijn nog geen commitments gemaakt';
        genericAuthErrorMessage = 'Email adres of wachtwoord is incorrect';
        genericFirebaseErrorMessage =
            'Er is iets verkeerd gegaan. Probeert u het s.v.p. opnieuw';
        // Links
        signInScreenResetPasswordLink = 'Ik ben mijn wachtwoord vergeten';
        signInScreenSignUpUsingEmailLink = 'Registreer met een email adres';
        signInScreengoBackToSignInLink = 'Ga terug naar log in';
        mainScreenDismissebleEditCommitmentLink = 'Wijzig commitment';
        mainScreenDismissebleDeleteCommitmentLink = 'Verwijder commitment';
        break;
      default:
        // AppBar Titles
        mainScreenAppBarTitle = 'Contracts';
        newContractScreenAppBarTitle = 'New contract';
        newCommitmentScreenAppBarTitle = 'New commitment';
        editContractScreenAppBarTitle = 'Edit contract';
        editCommitmentScreenAppBarTitle = 'Edit commitment';
        resetPasswordScreenAppBarTitle = 'Reset password';
        editContractScreenDeleteContractButtonText = 'Delete contract';
        signInScreenAppBarTitle = 'Sign in';
        signUpScreenAppBarTitle = 'Sign up';
        // Buttons
        newContractScreenButtonText = 'Save contract';
        newCommitmentScreenButtonText = 'Save commitments';
        editContractScreenButtonText = 'Edit contract';
        editCommitmentScreenButtonText = 'Edit commitment';
        resetPasswordScreenButtonText = 'Email reset link';
        signInScreenButtonText = 'Sign in';
        signUpScreenButtonText = 'Sign up';
        // Placeholder
        newContractScreenContractTitlePlaceholder = 'Contract title';
        newCommitmentScreenCommitmentPlaceholder = 'Commitment';
        editContractScreenContractTitlePlaceholder = 'Contract title';
        editCommitmentScreenCommitmentPlaceholder = 'Commitment';
        resetPasswordScreenEmailPlaceholder = 'Email address';
        signUpScreenUsernamePlaceholder = 'Username';
        signInUpScreenEmailPlaceholder = 'Email address';
        signInUpScreenPasswordPlaceholder = 'Password';
        // Error Messages
        newContractScreenContractTitleErrorMessage =
            'Please provide a valid contract title';
        newCommitmentScreenCommitmentErrorMessage =
            'Please provide a valid commitment';
        editContractScreenContractTitleErrorMessage =
            'Please provide a valid contract title';
        editCommitmentScreenCommitmentErrorMessage =
            'Please provide a valid commitment';
        resetPasswordScreenEmailErrorMessage =
            'Please provide a valid email address';
        signUpScreenUsernameErrorMessage = 'Please provide a valid username';
        signInUpScreenEmailErrorMessage =
            'Please provide a valid email address';
        signInUpScreenPasswordErrorMessage = 'Please provide a valid password';
        mainScreenNoContractsErrorMessage = 'There are no contracts yet';
        mainScreenNoCommitmentsErrorMessage = 'There are no commitments yet';
        genericAuthErrorMessage = 'Email address or password is incorrect';
        genericFirebaseErrorMessage = 'Something went wrong. Please try again';
        // Links
        signInScreenResetPasswordLink = 'I forgot my password';
        signInScreenSignUpUsingEmailLink = 'Sign up using email';
        signInScreengoBackToSignInLink = 'Go back to sign in';
        mainScreenDismissebleEditCommitmentLink = 'Edit commitment';
        mainScreenDismissebleDeleteCommitmentLink = 'Delete commitment';
    }
  }
}
