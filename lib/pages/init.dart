import 'dart:async';

import 'package:fitchoo/pages/base/home.dart';
import 'package:fitchoo/pages/initial/login.dart';
import 'package:fitchoo/pages/initial/privacy.dart';
import 'package:fitchoo/pages/initial/setHeight.dart';
import 'package:fitchoo/pages/initial/terms.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InitPage extends StatefulWidget {

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  List _deviceInfo = <dynamic>[];
//  String autoLoginId = '';
  static final DeviceInfoPlugin plugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    Hive.initFlutter();
    initPlatform(_deviceInfo);
    if(Platform.isIOS){
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
//    autoLogIn();
  }

//  void autoLogIn() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    final String userId = prefs.getString('username');
//
//    UserState $user = Provider.of<UserState>(context, listen: false);
//    if (userId != null) {
//      setState(() {
//        $user.login();
//        autoLoginId = userId;
//      });
//      return;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _rootBody(size, context)
    );
  }

  Widget _rootBody(Size size, BuildContext context) {
    return Stack(
      children: <Widget> [
        Positioned.fill(
        child: Image(
          image: AssetImage('assets/initBack.png'),
          fit : BoxFit.fill,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:100),
              child: Image.asset('assets/fitchoo_logo.png' ,width: size.width * 0.6,),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                Padding(padding: EdgeInsets.all(30)),
                _yellowButton(size),
                Padding(padding: EdgeInsets.all(5)),
                _greenButton(size),
                Padding(padding: EdgeInsets.all(5)),
                if(Platform.isIOS)_appleButton(size),
                Padding(padding: EdgeInsets.all(5)),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(10)),
                    Expanded(
                        child: Divider(
                            color: Colors.white
                        )
                    ),
                    Padding(padding: EdgeInsets.all(18)),
                    Text("또는", style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700, color:Colors.white)),
                    Padding(padding: EdgeInsets.all(18)),
                    Expanded(
                        child: Divider(
                            color: Colors.white
                        )
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                  ]
                ),
                Padding(padding: EdgeInsets.all(10)),
                _redButton(size, context),
                Padding(padding: EdgeInsets.all(10)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('위의 버튼을 누르면 ',style: TextStyle(color:Colors.white),),
                        InkWell(
                          onTap:() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => PrivacyPage()));
                          },
                          child: Text('개인정보 처리방침 ',style: TextStyle(color:Colors.white,decoration: TextDecoration.underline),)
                        ),
                        Text(' 및 ',style: TextStyle(color:Colors.white),),
                        InkWell(
                          onTap:() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => TermsPage()));
                          },
                          child: Text('이용약관',style: TextStyle(color:Colors.white,decoration: TextDecoration.underline),)
                        ),
                        Text('을',style: TextStyle(color:Colors.white),),
                      ],
                    ),
                    Text('읽고 동의한 것으로 간주합니다.',style: TextStyle(color:Colors.white),)
                  ],
                )
              ],
            )
          ],
        ),
      ]
    );
  }

  Widget _redButton(Size size, BuildContext context) {
    return SizedBox(
        width: size.width * 0.9,
        height: 60,
        child: FlatButton(
          child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:5),
                  child: Image.asset('assets/f_logo.png', fit: BoxFit.fitWidth, width:18),
                ),
                Padding(padding: EdgeInsets.only(left: size.width * 0.15)),
                Text("핏츄계정으로 시작하기", style: TextStyle(fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),),
              ]
          ),
          color: Color(0XFFec3e39),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          splashColor: Colors.redAccent,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AuthPage()));
          },
        )
    );
  }

  Widget _greenButton(Size size) {
    return SizedBox(
        width: size.width * 0.9,
        height: 60,
        child: FlatButton(
          child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:2),
                  child: Image.asset('assets/naver_icon.png', fit: BoxFit.fitWidth, width:23),
                ),
                Padding(padding: EdgeInsets.only(left: size.width * 0.15)),
                Text("네이버 계정으로 시작하기", style: TextStyle(fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),),
              ]
          ),
          color: Color(0xFF1EC800),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          splashColor: Colors.greenAccent,
          onPressed: () {
            _naverLogin().then((result) async{
              if(result.account.email == '' || result.account.email ==null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                    new CupertinoAlertDialog(
                      content: new Text("이미 가입된 계정입니다.",style: TextStyle(fontSize:16)),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context, 'Cheesecake');
                          },
                          isDefaultAction: true,
                          child: Text("닫기",style: TextStyle(fontSize:12),),
                        )
                      ],
                    )
                );
              }else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => setHeightPage()));
                UserState $user = Provider.of<UserState>(context, listen: false);
                $user.setUserSNSType('naver');
                if(Platform.isAndroid ){
                  $user.setUserAppType('android');
                }else if(Platform.isIOS) {
                  $user.setUserAppType('ios');
                }
                $user.setUserSNSId(result.account.id);
                $user.setUserEmail(result.account.email);
                $user.setUserPassword('');
                $user.userLogIn();
                
                var box = await Hive.openBox('userInfo');
                box.put('snsType', 'naver');
                box.put('userEmail', result.account.email);
                box.put('password', '');
                box.put('snsId', result.account.id);
                box.put('appType', $user.appType);
                box.put('pushKey', '');
                box.put('deviceInfo', $user.deviceInfo);
                box.put('options', 'push');
                box.put('accessToken', $user.accessToken);
                var box2 = Hive.box('userInfo');
                print('userInfo in Hive: $box2');
                await box.close();

                Timer(Duration(seconds: 1), () async{
                  if($user.accessToken == null || $user.accessToken == '') {
                  }
                  else{
                    $user.login();
                  }
                });
              }
            });
          },
        )
    );
  }

  Widget _yellowButton(Size size) {
    return SizedBox(
        width: size.width * 0.9,
        height: 60,
        child: FlatButton(
          child: new Row(
              children: <Widget>[
                Image.asset('assets/kakao_icon.png', fit: BoxFit.fitWidth, width:25),
                Padding(padding: EdgeInsets.only(left: size.width * 0.15)),
                Text("카카오계정으로 시작하기", style: TextStyle(fontSize: 17,
                    color: Color(0XFF3c1e1e),
                    fontWeight: FontWeight.normal),),
              ]
          ),
          color: Color(0xFFf7e318),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          splashColor: Colors.yellowAccent,
          onPressed: () {
            _kakaoLogin().then((result) async{
              if(result.account.userEmail == '' || result.account.userEmail ==null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                    new CupertinoAlertDialog(
                      content: new Text("이미 가입된 계정입니다.",style: TextStyle(fontSize:16)),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context, 'Cheesecake');
                          },
                          isDefaultAction: true,
                          child: Text("닫기",style: TextStyle(fontSize:12),),
                        )
                      ],
                    )
                );
              }else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => setHeightPage()));
                UserState $user = Provider.of<UserState>(context, listen: false);
                $user.setUserSNSType('kakao');
                if(Platform.isAndroid ){
                  $user.setUserAppType('android');
                }else if(Platform.isIOS) {
                  $user.setUserAppType('ios');
                }
                $user.setUserSNSId(result.account.userID);
                $user.setUserEmail(result.account.userEmail);
                $user.setUserPassword('');
                $user.userLogIn();

                var box = await Hive.openBox('userInfo');
                box.put('snsType', 'naver');
                box.put('userEmail', result.account.userEmail);
                box.put('password', '');
                box.put('snsId', result.account.userID);
                box.put('appType', $user.appType);
                box.put('pushKey', '');
                box.put('deviceInfo', $user.deviceInfo);
                box.put('options', 'push');
                box.put('accessToken', $user.accessToken);
                var box2 = Hive.box('userInfo');
                print('userInfo in Hive: $box2');
                await box.close();

                Timer(Duration(seconds: 1), () async{
                  if($user.accessToken == null || $user.accessToken == '') {
                  }
                  else{
                    $user.login();
                  }
                });
              }
            });
          },
        )
    );
  }

  Widget _appleButton(Size size) {
    return SizedBox(
        width: size.width * 0.9,
        height: 60,
        child: FlatButton(
          child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:3),
                  child: Image.asset('assets/apple_icon.png', fit: BoxFit.fitWidth, width:23),
                ),
                Padding(padding: EdgeInsets.only(left: size.width * 0.15)),
                Text("애플 계정으로 시작하기", style: TextStyle(fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),),
              ]
          ),
          color: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          splashColor: Colors.white,
          onPressed: () async{
            if(await AppleSignIn.isAvailable()) {
              final AuthorizationResult result = await
              AppleSignIn.performRequests([
                AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
              ]);
              switch (result.status) {
                case AuthorizationStatus.authorized:
                  print("애플로그인성공함: $result");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => setHeightPage()));
                  UserState $user = Provider.of<UserState>(context, listen: false);
                  $user.setUserSNSType('apple');
                  $user.setUserAppType('ios');
                  $user.setUserSNSId('apple');
                  $user.setUserEmail(result.credential.email);
                  $user.setUserPassword('');
                  $user.userLogIn();

                  var box = await Hive.openBox('userInfo');
                  box.put('snsType', 'naver');
                  box.put('userEmail', result.credential.email);
                  box.put('password', '');
                  box.put('snsId', 'apple');
                  box.put('appType', $user.appType);
                  box.put('pushKey', '');
                  box.put('deviceInfo', $user.deviceInfo);
                  box.put('options', 'push');
                  box.put('accessToken', $user.accessToken);
                  var box2 = Hive.box('userInfo');
                  print('userInfo in Hive: $box2');
                  await box.close();

                  Timer(Duration(seconds: 1), () async{
                    if($user.accessToken == null || $user.accessToken == '') {
                    }
                    else{
                      $user.login();
                    }
                  });
                  break;
                case AuthorizationStatus.error:
                  print("Sign in failed: ${result.error.localizedDescription}");
                  break;
                case AuthorizationStatus.cancelled:
                  print('User cancelled');
                  break;
              }
            }else{
              print('Apple SignIn is not available for your device');
            }
          },
        )
    );
  }

  Future<KakaoLoginResult> _kakaoLogin() async {
    FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
  final KakaoLoginResult result = await kakaoSignIn.logIn();
  switch (result.status) {
    case KakaoLoginStatus.loggedIn:
      print('LoggedIn by the user.\n'
          '- UserID is ${result.account.userID}\n'
          '- UserEmail is ${result.account.userEmail} ');
      return result;
      break;
    case KakaoLoginStatus.loggedOut:
      print('LoggedOut by the user.');
      break;
    case KakaoLoginStatus.error:
      print('This is Kakao error message : ${result.errorMessage}');
      break;
  }
  }

 Future<NaverLoginResult> _naverLogin() async{
 final NaverLoginResult result = await FlutterNaverLogin.logIn();
 final String naverEmail = result.account.email;
   print('네이버 이르으으으음------${naverEmail}');
   return result;
 }

  Future<void> initPlatform(_deviceInfo) async {
    if (Platform.isAndroid) {
      setState(() async {
        _deviceInfo = getAndroidDevice(await plugin.androidInfo);
        UserState $user = Provider.of<UserState>(context, listen: false);
        $user.setUserDeviceInfo(_deviceInfo);
      });
    }
    if (Platform.isIOS) {
      setState(() async {
        _deviceInfo = getIosDevice(await plugin.iosInfo);
        print(_deviceInfo);
      });
    }
  }
}

getIosDevice(IosDeviceInfo data) {
  return [
    data.name,
    data.systemName,
    data.systemVersion,
    data.model,
    data.localizedModel,
    data.identifierForVendor,
    data.isPhysicalDevice,
    data.utsname.sysname,
    data.utsname.nodename,
    data.utsname.release,
    data.utsname.version,
    data.utsname.machine,
  ];
}

getAndroidDevice(AndroidDeviceInfo device) {
  return [
    '[164]',
    device.brand,
    device.model,
    'android ver: ${device.version.release}',
    'sdk: ${device.version.sdkInt}'
  ];
}