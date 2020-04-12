import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:airplane_mode_detection/airplane_mode_detection.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  List _deviceInfo = <dynamic>[];
  static final DeviceInfoPlugin plugin = DeviceInfoPlugin();
  bool _fadeIn = false;
  bool _autoLogin = false;
  String _appInfo = '';

  @override
  void initState() {
    super.initState();
    initPlatform(_deviceInfo);
    detectAir();

    Timer(Duration(seconds: 1), () async{
      loadData();
      setState(() {
        _fadeIn = true;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: new BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFf45c43), const Color(0xFFeb3349)])),
      child: new Center(
        child: AnimatedOpacity(
            duration: Duration(seconds: 2),
            curve: Curves.easeIn,
            opacity: _fadeIn ? 1.0 : 0.0,
            child: Image.asset('assets/white_logo.png', width: 200,)
        ),
      ),
      ),
    );
  }

  Future<Timer> loadData() async {
    final pref = await SharedPreferences.getInstance();
    var loginInfo =  pref.getStringList('userLoginInfo');
    UserState $user = Provider.of<UserState>(context, listen: false);
    print('이건?');
    if(loginInfo == null) {
      print('로그인안됨');
      return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => InitPage()));
    } else {
      print(loginInfo);
        if(loginInfo.length < 6) {
          return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => InitPage()));
        }
      String snsType = loginInfo[0];
      String userEmail = loginInfo[1];
      String password = loginInfo[2];
      String snsId = loginInfo[3];
      String userHeight = loginInfo[5];
      $user.setUserSNSType(snsType);
      $user.setUserSNSId(snsId);
      $user.setUserEmail(userEmail);
      $user.setUserPassword(password);
      $user.setUserHeight(userHeight);
      bool loginState = await $user.userLogIn();

      if(loginState) {
        print('로그인됐거');
        setState(() {
          _autoLogin = true;
        });
      } else {
        print('로그인안됨');
        return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => InitPage()));
      }
    }
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    if(_autoLogin) {
//      UserState $user = Provider.of<UserState>(context, listen: false);
//      QurateState $qurate = Provider.of<QurateState>(context, listen: false);
//      $qurate.getQurateList($user.accessToken, $user.appInfo);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TabPage()));
    } else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => InitPage()));
    }
  }

  detectAir() async{
    String state = await AirplaneModeDetection.detectAirplaneMode();
    if(state == 'ON') {
      Fluttertoast.showToast(
          msg: "비행기모드가 켜져있습니다. 비행기모드를 끄고 앱을 다시 실행해주세요.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
      new Timer(Duration(seconds: 2), pop);
    } else {
      checkNetwork();
    }
  }

  static Future<void> pop({bool animated}) async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
  }

  checkNetwork() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
    } else if (connectivityResult == ConnectivityResult.wifi) {
    } else {
      Fluttertoast.showToast(
          msg: "인터넷이 연결되지 않으면 사용할 수 없습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
      new Timer(Duration(seconds: 2), pop);
    }
  }

  Future<void> initPlatform(_deviceInfo) async {
    print('info1');
    if (Platform.isAndroid) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String andversionName = packageInfo.version;

        _deviceInfo = getAndroidDevice(await plugin.androidInfo);
        this._appInfo = 'Android/$andversionName (${_deviceInfo[0]}; SDK/${_deviceInfo[1]})';

    }
    if (Platform.isIOS) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String iosversionName = packageInfo.version;

        _deviceInfo = getIosDevice(await plugin.iosInfo);
        this._appInfo = 'IOS/$iosversionName (${_deviceInfo[0]}; SDK/${_deviceInfo[1]})';
    }

    print('info2');
    final pref = await SharedPreferences.getInstance();
    var appInfo =  pref.getString('appInfo');
    if(appInfo == null) {
      pref.setString('appInfo', '');
      appInfo = this._appInfo;
      pref.setString('appInfo', appInfo);
    } else {
      appInfo = this._appInfo;
      pref.setString('appInfo', appInfo);
    }
    print(appInfo);
    print(this._appInfo);
    print('info3');

    UserState $user = Provider.of<UserState>(context, listen: false);
    $user.setUserAppInfo(this._appInfo);

    print('info4');
  }
}

getIosDevice(IosDeviceInfo data) {
  return [
    data.name,
    data.systemVersion,
  ];
}

getAndroidDevice(AndroidDeviceInfo device) {
  return [
    device.model,
    device.version.sdkInt
  ];
}