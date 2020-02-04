import 'package:fitchoo/pages/depth//login.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';

class InitPage extends StatefulWidget {

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: _rootBody(size, context),

    );
  }

  Widget _rootBody(Size size, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/black_logo.png'),
          Text("내 키에 꼭 맞는 모델과 상품",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Padding(padding: EdgeInsets.all(80)),
          _redButton(size, context),
          Padding(padding: EdgeInsets.all(10)),
          Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(20)),
                Expanded(
                    child: Divider(
                        color: Colors.black
                    )
                ),
                Padding(padding: EdgeInsets.all(15)),
                Text("또는", style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
                Padding(padding: EdgeInsets.all(15)),
                Expanded(
                    child: Divider(
                        color: Colors.black
                    )
                ),
                Padding(padding: EdgeInsets.all(20)),
              ]
          ),
          Padding(padding: EdgeInsets.all(10)),
          _greenButton(size),
          Padding(padding: EdgeInsets.all(5)),
          _yellowButton(size),
        ],
      ),
    );
  }

  Widget _redButton(Size size, BuildContext context) {
    return SizedBox(
        width: size.width * 0.8,
        height: 50,
        child: FlatButton(
          child: new Row(
              children: <Widget>[
                Icon(Icons.audiotrack, color: Colors.white),
                Padding(padding: EdgeInsets.only(left: size.width * 0.15)),
                Text("핏츄계정으로 시작하기", style: TextStyle(fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),
              ]
          ),
          color: Colors.red,
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
        width: size.width * 0.8,
        height: 50,
        child: FlatButton(
          child: new Row(
              children: <Widget>[
                Icon(Icons.audiotrack, color: Colors.white),
                Padding(padding: EdgeInsets.only(left: size.width * 0.15)),
                Text("네이버 아이디로 시작하기", style: TextStyle(fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),
              ]
          ),
          color: Colors.green,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          splashColor: Colors.greenAccent,
          onPressed: () {
            _naverLogin().then((result) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TabPage()));
              UserState $user = Provider.of<UserState>(context, listen: false);
              $user.setUserSNSType('naver');
              $user.setUserAppType('android');
              $user.setUserDeviceInfo('[164], samsung, SM-G925S, android ver:7.0, sdk:24');
              $user.setUserSNSId(result.account.id);
              $user.setUserEmail(result.account.email);
              $user.setUserPassword('11111111');
              $user.login();
            });
          },
        )
    );
  }

  Widget _yellowButton(Size size) {
    return SizedBox(
        width: size.width * 0.8,
        height: 50,
        child: FlatButton(
          child: new Row(
              children: <Widget>[
                Icon(Icons.audiotrack, color: Colors.white),
                Padding(padding: EdgeInsets.only(left: size.width * 0.15)),
                Text("카카오계정으로 시작하기", style: TextStyle(fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),
              ]
          ),
          color: Colors.yellow,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          splashColor: Colors.yellowAccent,
          onPressed: () {
            _kakaoLogin().then((result) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TabPage()));
              UserState $user = Provider.of<UserState>(context, listen: false);
              $user.setUserSNSType('naver');
              $user.setUserAppType('android');
              $user.setUserDeviceInfo('[164], samsung, SM-G925S, android ver:7.0, sdk:24');
              $user.setUserSNSId(result.account.userID);
              $user.setUserEmail(result.account.userEmail);
              $user.setUserPassword('11111111');
              $user.login();
            });
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
}