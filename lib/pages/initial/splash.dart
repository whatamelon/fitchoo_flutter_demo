import 'dart:async';
import 'package:fitchoo/pages/base/home.dart';
import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:airplane_mode_detection/airplane_mode_detection.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _autoLogin = false;
  @override
  void initState() {
    super.initState();
    loadData();
    detectAir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: new BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFeb3349), const Color(0xFFf45c43)])),
      child: new Center(
        child: Image.asset('assets/white_logo.png', width: 200,),
      ),
      ),
    );
  }

  Future<Timer> loadData() async {
    await Hive.initFlutter();
    UserState $user = Provider.of<UserState>(context, listen: false);
    var box = await Hive.openBox('userInfo');
    if(box != null) {
      String aToken = box.get('accessToken');
      if(aToken == '' || aToken == null) {
      }else {
        String snsType = box.get('snsType');
        String userEmail = box.get('userEmail');
        String password = box.get('password');
        String snsId = box.get('snsId');
        String appType = box.get('appType');
        $user.setUserSNSType(snsType);
        $user.setUserAppType(appType);
        $user.setUserSNSId(snsId);
        $user.setUserEmail(userEmail);
        $user.setUserPassword(password);
        $user.userLogIn();
        box.put('accessToken', $user.accessToken);
        var box2 = Hive.box('userInfo');
        print('userInfo in Hive: $box2');
        await box.close();

        setState(() {
          _autoLogin = true;
        });
      }
    } else {

    }
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    if(_autoLogin) {
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
}
