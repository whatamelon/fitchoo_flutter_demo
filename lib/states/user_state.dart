import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

const baseUrl = 'https://rest.fitchoo.kr';

class UserState with ChangeNotifier {
//  -----------------------------------
//  State

  bool _loogedIn = false;
  bool _signUpMes = false;
  String _signStr = '';
  String _accessToken = '';
  String _userId = '';
  int _userHeight = 0;
  String _userEmail = '';
  String _userPassword = '';
  String _snsType = '';
  String _snsId = '';
  String _appType = '';
  List _deviceInfo = [];
  String _pushKey = '';
  String _options = '';

//  -----------------------------------
//  set

  UserState() {
    this._loogedIn = false;
    this._signUpMes = false;
    this._signStr = '';
    this._accessToken = '';
    this._userId = '';
    this._userHeight = 0;
    this._userEmail = '';
    this._userPassword = '';
    this._snsType = '';
    this._snsId = '';
    this._appType = '';
    this._deviceInfo = [];
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

  String get signStr {
    return _signStr;
  }


  String get accessToken {
    return _accessToken;
  }

  String get userId {
    return _userId;
  }

  int get userHeight {
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

  List get deviceInfo {
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
            "deviceInfo": '',
            "options": _options,
          });
      if(response.data['status'] == 200) {
        print('로그인리쥴트${response.data['result']}');
        var st = jsonDecode(response.data['result']['userId']);
        this._userId = "$st";
        this._signUpMes = true;
      } else if (response.data['status'] == 511) {
        this._signStr = '다른 이메일을 사용해주세요';
        this._signUpMes = false;
      } else if (response.data['status'] == 512) {
        this._signStr = '가입에 실패했습니다.';
        this._signUpMes = false;
      }
      else {
        this._signUpMes = false;
      }
    }catch(e) {
      this._signUpMes = false;
      print('cr error--------$e');
    }
    notifyListeners();
  }

  userLogIn() async {
    Dio dio = new Dio();
    Response response;
    var data = {
      "snsType": _snsType,
      "email": _userEmail,
      "passwd": _userPassword,
      "snsId": _snsId,
      "appType": _appType,
      "pushKey": _pushKey,
      "deviceInfo": _deviceInfo,
      "options": _options,
    };
    print('accessToken1------$_accessToken');
    print('send data+ $data');
    try{
      response = await dio.post("$baseUrl/users/signin",
          data: {
            "snsType": _snsType,
            "email": _userEmail,
            "passwd": _userPassword,
            "snsId": _snsId,
            "appType": _appType,
            "pushKey": _pushKey,
            "deviceInfo": '',
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
      } else if (response.data['status'] == 501) {
        this._signStr = '가입되지 않은 사용자 입니다.';
        this._signUpMes = false;
      } else if(response.data['status'] == 502) {
        this._signStr = '가입되지 않은 사용자 입니다.';
        this._signUpMes = false;
      }
      else {
        print('로그인 에러-------${response.data}');
        this._signUpMes = false;
      }
    }catch(e) {
      this._signUpMes = false;
      print('login error--------$e');
    }
    notifyListeners();
  }

  userTemppw(i) async{
    Response response;
    try{
      response = await dio.put("$baseUrl/users/temppw",
          data: {
            "email": i,
            "passwd": '',
            "passwd2": '',
          });
      print(i);
      if(response.statusCode == 200) {
        print(response.data['result']);
      }else {
        print(response.data['result']);
      }
    }catch(e) {
      print(e);
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

  setAccessToken(i) async{
    this._accessToken = i;
    notifyListeners();
  }

  setAutoLogin() async {
    Dio dio = new Dio();
    await dio.post("$baseUrl/users/signre/$_appType/push",
        options: Options(
            headers: {
              "Authorization" : _accessToken,
            }));
    this._options = 'push';
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
    print(i);
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