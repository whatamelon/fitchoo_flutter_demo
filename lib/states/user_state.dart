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
  String _appInfo = '';
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
    this._appInfo = '';
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

  String get appInfo {
    return _appInfo;
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

  Future<bool> signUp() async {
    Response response;
    try{
      response = await dio.post("$baseUrl/users/100/signup",
          data: {
            "snsType": _snsType,
            "email": _userEmail,
            "passwd": _userPassword,
            "snsId": _snsId,
            "pushKey": _pushKey,
            "options": _options,
          },
          options: Options(headers: {"User-Agent": _appInfo}));
      if(response.data['status'] == 200) {
        print('회원가입리쥴트${response.data['result']}');
        var st = jsonDecode(response.data['result']['userId']);
        this._userId = "$st";
        this._signUpMes = true;
        this.setAccessToken(response.data['result']['authToken']);
      } else if (response.data['status'] == 511) {
        this._signStr = '다른 이메일을 사용해주세요';
        this._signUpMes = false;
      } else if (response.data['status'] == 512) {
        this._signStr = '가입에 실패했습니다.';
        this._signUpMes = false;
      }
      else {
        this._signStr = '가입에 실패했습니다.';
        this._signUpMes = false;
      }
    }catch(e) {
      this._signUpMes = false;
      print('cr error--------$e');
    }
    notifyListeners();
    return this._signUpMes;
  }

  Future<bool> userLogIn() async {
    Dio dio = new Dio();
    Response response;
    var data = {
      "snsType": _snsType,
      "email": _userEmail,
      "passwd": _userPassword,
      "snsId": _snsId,
      "pushKey": _pushKey,
      "options": _options,
    };
    print('accessToken1------$_accessToken');
    print('send data+ $data');
    print(_appInfo);
    try{
      response = await dio.post("$baseUrl/users/100/signin",
          data: {
            "snsType": _snsType,
            "email": _userEmail,
            "passwd": _userPassword,
            "snsId": _snsId,
            "pushKey": _pushKey,
            "options": _options,
          },
          options: Options(headers: {"User-Agent": _appInfo}));
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
    } catch(e) {
      this._signUpMes = false;
      print('login error--------$e');
    }
    notifyListeners();
    return this._signUpMes;
  }

  userTemppw(i) async{
    Response response;
    try{
      response = await dio.put("$baseUrl/users/100/temppw",
          data: {
            "email": i,
            "passwd": '',
            "passwd2": '',
          },
          options: Options(headers: {"User-Agent": _appInfo}));
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

  changePw(i ,j) async{
    Response response;
    try{
      response = await dio.put("$baseUrl/users/100/pw",
          data: {
            "email": '',
            "passwd": i,
            "passwd2": j,
          },
          options: Options(headers: {"Authorization": _accessToken,"User-Agent": _appInfo}));
      print(i);
      if(response.statusCode == 200) {
        print(response.data['result']);
        this._signStr = '비밀번호가 변경되었습니다.';
        this._signUpMes = true;
      }else if (response.data['status'] == 500) {
        this._signStr = '비밀번호 변경에 실패했습니다.';
        this._signUpMes = false;
      }else if (response.data['status'] == 404) {
        this._signStr = '해당되는 사용자 정보가 없습니다.';
        this._signUpMes = false;
      }else if (response.data['status'] == 503) {
        this._signStr = '현재 비밀번호가 틀렸습니다.';
        this._signUpMes = false;
      }else {
        print(response.data['result']);
      }
    }catch(e) {
      print(e);
    }
    notifyListeners();
  }

  changeNoti(i) async{
    Response response;
    try{
      response = await dio.put("$baseUrl/users/100/push/$i",
          options: Options(headers: {"Authorization": _accessToken,"User-Agent": _appInfo}));
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
    await dio.delete("$baseUrl/users/100");
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
    await dio.post("$baseUrl/users/100/signre/$options",
        options: Options(
            headers: {
              "Authorization" : _accessToken,"User-Agent": _appInfo
            }));
    notifyListeners();
  }

  setUserHeight(i) async {
    Dio dio = new Dio();
    print('accessTokenForHeight------'+_accessToken);
    try{
      await dio.put("$baseUrl/users/100/height/$i",
          options: Options(
              headers: {
                "Authorization" : _accessToken,"User-Agent": _appInfo
              }));
      this._userHeight = i;
    } catch(e) {
      print('이거임?');
    }
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

  setUserAppInfo(i) {
    this._appInfo = i;
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