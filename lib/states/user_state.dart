import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

const baseUrl = 'https://rest.fitchoo.kr';


class UserState with ChangeNotifier {
//  -----------------------------------
//  State

  bool _loogedIn = false;
  bool _signUpMes = false;
  String _accessToken = '';
  String _userId = '';
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
//  set

  UserState() {
    this._loogedIn = false;
    this._signUpMes = false;
    this._accessToken = '';
    this._userId = '';
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
//  get

  bool get loggedIn {
    return _loogedIn;
  }

  bool get signUpMes {
    return _signUpMes;
  }

  String get accessToken {
    return _accessToken;
  }

  String get userId {
    return _userId;
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

  var dio = Dio();

  signUp() async {
    Response response;
    try{
      response = await dio.post("$baseUrl/users/signup",
          data: {
            "snsType": _snsType,
            "email": _userEmail,
            "passwd": _userPassword,
            "snsId": _snsId,
            "appType": _appType,
            "pushKey": _pushKey,
            "deviceInfo": _deviceInfo,
            "options": _options,
          });
      if(response.statusCode == 200) {
        print(response.data['result']);
        this._userId = jsonDecode(response.data['result']['userId']);
        this._signUpMes = true;
      }else {
        this._signUpMes = false;
      }
    }catch(e) {
      print(e);
    }
    notifyListeners();
  }

  userLogIn() async {
    Dio dio = new Dio();
    Response response;
    print('accessToken1------'+_accessToken);
    try{
      response = await dio.post("$baseUrl/users/signin",
          data: {
            "snsType": _snsType,
            "email": _userEmail,
            "passwd": _userPassword,
            "snsId": _snsId,
            "appType": _appType,
            "pushKey": _pushKey,
            "deviceInfo": _deviceInfo,
            "options": _options,
          });
      print('first+${response.data}');
      if(response.data['status'] == 200) {
        print('ㅇㅋ데이터받아옴--------${response.data['result']}');
        print('ㅇㅋ데이터받아옴2--------${response.data['result']['authToken']}');
//        this._accessToken = response.data['result']['authToken'];
        this.setAccessToken(response.data['result']['authToken']);

        print('accessToken2-------$_accessToken');
        this._signUpMes = true;
      }else {
        print('로그인 에러-------${response.data}');
        this._signUpMes = false;
      }
    }catch(e) {
      print('login error--------$e');
    }
    notifyListeners();
  }

  userLogOut() async {
    Dio dio = new Dio();
    await dio.delete("$baseUrl/users");
    notifyListeners();
  }

  login() {
    this._loogedIn = true;
    notifyListeners();
  }

  logout() {
    this._loogedIn = false;
    notifyListeners();
  }

  setAccessToken(i) {
    this._accessToken = i;
    notifyListeners();
  }

  setUserHeight(i) async {
    Dio dio = new Dio();
    print('accessTokenForHeight------'+_accessToken);
    await dio.put("$baseUrl/users/height/$i",
        options: Options(
          headers: {
            "Authorization" : _accessToken,
          }));
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