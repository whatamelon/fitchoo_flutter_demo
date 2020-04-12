import 'dart:async';
import 'package:fitchoo/pages/initial/login.dart';
import 'package:fitchoo/pages/initial/setHeight.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:fitchoo/pages/webView.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InitPage extends StatefulWidget {

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  List _deviceInfo = <dynamic>[];
  static final DeviceInfoPlugin plugin = DeviceInfoPlugin();
  List<String> _viewData = ['', ''];

  @override
  void initState() {
    super.initState();
    initPlatform(_deviceInfo);
    if(Platform.isIOS){
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/initBack.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
            body: _rootBody(size, context)
        ),
      ],
    );
  }

  Widget _rootBody(Size size, BuildContext context) {
    return
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:115.h),
                child: Center(child: Image.asset('assets/fitchoo_logo.png', width: 210.w, height: 55.h)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(height: 130.h),
                  _yellowButton(size),
                  Container(height: 12.h),
                  _greenButton(size),
                  Container(height: 12.h),
                  Platform.isIOS ?
                      Column(
                        children: <Widget>[
                          _appleButton(size),
                          Container(height: 12.h),
                        ],
                      ): Container(),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(10)),
                      Expanded(
                          child: Divider(
                              color: Colors.white
                          )
                      ),
                      Padding(padding: EdgeInsets.all(15)),
                      Text("또는", style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700, color:Colors.white)),
                      Padding(padding: EdgeInsets.all(15)),
                      Expanded(
                          child: Divider(
                              color: Colors.white
                          )
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                    ]
                  ),
                  Container(height: 10.h),
                  _redButton(size, context),
                  Container(height: 20.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('위의 버튼을 누르면 ',style: TextStyle(color:Colors.white,fontSize: ScreenUtil().setSp(14),),),
                          InkWell(
                            onTap:() {
                              setState(() {
                                this._viewData[0] = '개인정보 처리방침';
                                this._viewData[1] = 'https://fitchoo.kr/privacy.html';
                                goWebview();
                              });
                            },
                            child: Text('개인정보 처리방침 ',style: TextStyle(color:Colors.white,decoration: TextDecoration.underline,fontSize: ScreenUtil().setSp(14),),)
                          ),
                          Text(' 및 ',style: TextStyle(color:Colors.white,fontSize: ScreenUtil().setSp(14),),),
                          InkWell(
                            onTap:() {
                              setState(() {
                                this._viewData[0] = '이용약관';
                                this._viewData[1] = 'https://fitchoo.kr/terms.html';
                                goWebview();
                              });
                            },
                            child: Text('이용약관',style: TextStyle(color:Colors.white,decoration: TextDecoration.underline,fontSize: ScreenUtil().setSp(14),),)
                          ),
                          Text('을',style: TextStyle(color:Colors.white),),
                        ],
                      ),
                      Text('읽고 동의한 것으로 간주합니다.',style: TextStyle(color:Colors.white,fontSize: ScreenUtil().setSp(14),),)
                    ],
                  ),
                  Container(
                    height: 40.h
                  )
                ],
              )
            ],
          ),
        );
  }

  Widget _redButton(Size size, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      child: Container(
          width: size.width * 1,
          height: 50.h,
          child: FlatButton(
            child: new Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left:8.w),
                    child: Image.asset('assets/f_logo.png', width:14.w, height: 30.h),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60.w, 12.5.h, 0, 12.5.h),
                    child: Text("핏츄계정으로 시작하기", style: TextStyle(fontSize: ScreenUtil().setSp(14),
                        color: Colors.white,
                        fontWeight: FontWeight.w500),),
                  ),
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
      ),
    );
  }

  Widget _greenButton(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      child: SizedBox(
          width: size.width * 1,
          height: 50.h,
          child: FlatButton(
            child: new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:2),
                    child: Image.asset('assets/naver_icon.png', fit: BoxFit.fitWidth, width:23),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60.w, 12.5.h, 0, 12.5.h),
                    child: Text("네이버 계정으로 시작하기", style: TextStyle(fontSize: ScreenUtil().setSp(14),
                        color: Colors.white,
                        fontWeight: FontWeight.w500),),
                  ),
                ]
            ),
            color: Color(0xFF2db400),
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
                  UserState $user = Provider.of<UserState>(context, listen: false);
                  $user.setUserSNSType('naver');
                  $user.setUserSNSId(result.account.id);
                  $user.setUserEmail(result.account.email);
                  $user.setUserPassword('');

                  bool logInres = await $user.signUp();

                    if(logInres) {
                      print('3');
                      final pref = await SharedPreferences.getInstance();
                      var loginInfo =  pref.getStringList('userLoginInfo');
                      if(loginInfo == null) {
                        pref.setStringList('userInfo', []);
                        List<String> userInfoBox = [];
                        userInfoBox.insert(0,'apple');
                        userInfoBox.insert(1,result.account.email);
                        userInfoBox.insert(2,'');
                        userInfoBox.insert(3,result.account.id);
                        userInfoBox.insert(4,'true');

                        pref.setStringList('userInfo', userInfoBox);

                        $user.login();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => setHeightPage()));
                      } else {
                        $user.login();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => TabPage()));
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                          new CupertinoAlertDialog(
                            content: new Text($user.signStr,style: TextStyle(fontSize:16)),
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
                    }
                }
              });
            },
          )
      ),
    );
  }

  Widget _yellowButton(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      child: SizedBox(
          width: size.width * 1,
          height: 50.h,
          child: FlatButton(
            child: new Row(
                children: <Widget>[
                  Image.asset('assets/kakao_icon.png', fit: BoxFit.fitWidth, width:25),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60.w, 12.5.h, 0, 12.5.h),
                    child: Text("카카오 계정으로 시작하기", style: TextStyle(fontSize: ScreenUtil().setSp(14),
                        color: Color(0XFF381e1f),
                        fontWeight: FontWeight.w500),),
                  ),
                ]
            ),
            color: Color(0xFFf7e600),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            splashColor: Colors.yellowAccent,
            onPressed: () {
              _kakaoLogin().then((result) async{
                if(result.account.userEmail == '' || result.account.userEmail ==null || result.errorMessage == 'AUTHORIZATION_FAILED') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                      new CupertinoAlertDialog(
                        content: new Text("같은 이메일로 가입된 계정입니다.",style: TextStyle(fontSize:16)),
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
                  UserState $user = Provider.of<UserState>(context, listen: false);
                  $user.setUserSNSType('kakao');
                  $user.setUserSNSId(result.account.userID);
                  $user.setUserEmail(result.account.userEmail);
                  $user.setUserPassword('');

                  bool logInres = await $user.signUp();

                    if(logInres) {
                      print('3');
                      final pref = await SharedPreferences.getInstance();
                      var loginInfo =  pref.getStringList('userLoginInfo');
                      if(loginInfo == null) {
                        pref.setStringList('userInfo', []);
                        List<String> userInfoBox = [];
                        userInfoBox.insert(0,'apple');
                        userInfoBox.insert(1,result.account.userEmail);
                        userInfoBox.insert(2,'');
                        userInfoBox.insert(3,result.account.userID);
                        userInfoBox.insert(4,'true');

                        pref.setStringList('userInfo', userInfoBox);

                        $user.login();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => setHeightPage()));
                      } else {
                        $user.login();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => TabPage()));
                      }
                    }
                    else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                          new CupertinoAlertDialog(
                            content: new Text($user.signStr,style: TextStyle(fontSize:16)),
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
                    }
                }
              });
            },
          )
      ),
    );
  }

  Widget _appleButton(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      child: SizedBox(
          width: size.width * 1,
          height: 50.h,
          child: FlatButton(
            child: new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:3),
                    child: Image.asset('assets/apple_icon.png', fit: BoxFit.fitWidth, width:23),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60.w, 12.5.h, 0, 12.5.h),
                    child: Text("애플 계정으로 시작하기", style: TextStyle(fontSize: ScreenUtil().setSp(14),
                        color: Colors.white,
                        fontWeight: FontWeight.w500),),
                  ),
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
                    UserState $user = Provider.of<UserState>(context, listen: false);
                    $user.setUserSNSType('apple');
                    $user.setUserSNSId(result.credential.user);
                    $user.setUserEmail(result.credential.email);
                    $user.setUserPassword('');

                    bool logInres = await $user.signUp();

                          if (logInres) {
                            print('3');
                            final pref = await SharedPreferences.getInstance();
                            var loginInfo =  pref.getStringList('userLoginInfo');
                            if(loginInfo == null) {
                              pref.setStringList('userInfo', []);
                              List<String> userInfoBox = [];
                              userInfoBox.insert(0,'apple');
                              userInfoBox.insert(1,result.credential.email);
                              userInfoBox.insert(2,'');
                              userInfoBox.insert(3,result.credential.user);
                              userInfoBox.insert(4,'true');

                              pref.setStringList('userInfo', userInfoBox);

                              $user.login();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => setHeightPage()));
                            } else {
                              $user.login();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => TabPage()));
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                new CupertinoAlertDialog(
                                  content: new Text($user.signStr,style: TextStyle(fontSize:16)),
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
                          }
                    break;
                  case AuthorizationStatus.error:
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                        new CupertinoAlertDialog(
                          content: new Text("애플로그인에 실패했습니다. ios13버전 이하이신 경우 다른 로그인을 선택해주세요.",style: TextStyle(fontSize:16)),
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
      ),
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

  void goWebview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return webViewPage(viewData: this._viewData);
        }));
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