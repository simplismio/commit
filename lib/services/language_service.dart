import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static List<String> languages = ['English', 'Dutch'];
  final String key = "language";

  late String _language;
  late Map<String, dynamic> translations;

  String? mainScreenAppBarTitle;
  String? newContractScreenAppBarTitle;
  String? newCommitmentScreenAppBarTitle;
  String? editContractScreenAppBarTitle;
  String? editCommitmentScreenAppBarTitle;
  String? resetPasswordScreenAppBarTitle;
  String? signInScreenAppBarTitle;
  String? signUpScreenAppBarTitle;

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
        mainScreenAppBarTitle = 'Contracts';
        newContractScreenAppBarTitle = 'New Contract';
        newCommitmentScreenAppBarTitle = 'New Commitment';
        editContractScreenAppBarTitle = 'Edit Contract';
        editCommitmentScreenAppBarTitle = 'Edit Commitment';
        resetPasswordScreenAppBarTitle = 'Reset Password';
        signInScreenAppBarTitle = 'Sign In';
        signUpScreenAppBarTitle = 'Sign Up';
        break;
      case 'Dutch':
        mainScreenAppBarTitle = 'Contracten';
        newContractScreenAppBarTitle = 'Nieuw Contract';
        newCommitmentScreenAppBarTitle = 'Nieuw Commitment';
        editContractScreenAppBarTitle = 'Wijzig Contract';
        editCommitmentScreenAppBarTitle = 'Wijzig Commitment';
        resetPasswordScreenAppBarTitle = 'Wachtwoord Reset';
        signInScreenAppBarTitle = 'Log In';
        signUpScreenAppBarTitle = 'Registreer';
        break;
      default:
        mainScreenAppBarTitle = 'Contracts';
        newContractScreenAppBarTitle = 'New Contract';
        newCommitmentScreenAppBarTitle = 'New Commitment';
        editContractScreenAppBarTitle = 'Edit Contract';
        editCommitmentScreenAppBarTitle = 'Edit Commitment';
        resetPasswordScreenAppBarTitle = 'Reset Password';
        signInScreenAppBarTitle = 'Sign In';
        signUpScreenAppBarTitle = 'Sign Up';
    }
  }
}
