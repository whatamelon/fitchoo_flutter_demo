import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
//  -----------------------------------
//  State

  bool _loogedIn = false;
  String _userHeight = '';
  String _userEmail = '';
  String _userPassword = '';
  String _snsType = '';
  String _snsId = '';
  String _appType = '';
  String _deviceInfo = '';
  String _pushKey = '';
  String _options = '';

//  -----------------------------------
//  Getter

  UserState() {
    this._loogedIn = false;
    this._userHeight = '';
    this._userEmail = '';
    this._userPassword = '';
    this._snsType = '';
    this._snsId = '';
    this._appType = '';
    this._deviceInfo = '';
    this._pushKey = '';
    this._options = '';
  }

//  -----------------------------------
//  Mutation

  bool get loggedIn {
    return _loogedIn;
  }

  String get userHeight {
    return _userHeight;
  }

  String get userEmail {
    return _userEmail;
  }

  String get userPassword {
    return _userPassword;
  }

  String get snsType {
    return _snsType;
  }

  String get snsId {
    return _snsId;
  }

  String get appType {
    return _appType;
  }

  String get pushKey {
    return _pushKey;
  }

  String get deviceInfo {
    return _deviceInfo;
  }

  String get options {
    return _options;
  }

//  -----------------------------------
//  Action

  login() {
    this._loogedIn = true;
    notifyListeners();
  }

  logout() {
    this._loogedIn = false;
    notifyListeners();
  }

  setUserHeight(i) {
    this._userHeight = i;
    notifyListeners();
  }

  setUserEmail(i) {
    this._userEmail = i;
    notifyListeners();
  }

  setUserPassword(i) {
    this._userPassword = i;
    notifyListeners();
  }

  setUserSNSType(i) {
    this._snsType = i;
    notifyListeners();
  }

  setUserSNSId(i) {
    this._snsId = i;
    notifyListeners();
  }

  setUserAppType(i) {
    this._appType = i;
    notifyListeners();
  }

  setUserDeviceInfo(i) {
    this._deviceInfo = i;
    notifyListeners();
  }

  setUserPushKey(i) {
    this._pushKey = i;
    notifyListeners();
  }

  setUserOptions(i) {
    this._options = i;
    notifyListeners();
  }
}