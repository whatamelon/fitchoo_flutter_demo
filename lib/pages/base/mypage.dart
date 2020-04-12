import 'package:fitchoo/pages/depth/contact.dart';
import 'package:fitchoo/pages/depth/heightChange.dart';
import 'package:fitchoo/pages/initial/RePwd.dart';
import 'package:fitchoo/pages/webView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../init.dart';

class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<String> _viewData = ['', ''];
  List myList = [];
  final lists = [
    {'title': '이용 문의', 'code': '1', 'icon': Icons.live_help},
    {'title': '이용 약관', 'code': '2', 'icon': Icons.list},
    {'title': '개인 정보 취급 방침', 'code': '3', 'icon': Icons.verified_user},
    {'title': '알림 설정', 'code': '4', 'icon': Icons.notifications},
    {'title': '비밀번호 재설정', 'code': '5', 'icon': Icons.lock},
    {'title': '로그아웃', 'code': '6', 'icon': Icons.exit_to_app},
  ];
  final lists2 = [
    {'title': '이용 문의', 'code': '1', 'icon': Icons.live_help},
    {'title': '이용 약관', 'code': '2', 'icon': Icons.list},
    {'title': '개인 정보 취급 방침', 'code': '3', 'icon': Icons.verified_user},
    {'title': '알림 설정', 'code': '4', 'icon': Icons.notifications},
    {'title': '로그아웃', 'code': '6', 'icon': Icons.exit_to_app},
  ];
  bool _isSwitched = false;
  String _userPush = '';
  String _valued = '';
  @override
  void initState() {
    super.initState();
    UserState $user = Provider.of<UserState>(context, listen: false);
    if($user.pushKey == 'true') {
      _isSwitched = true;
    } else {
      _isSwitched = false;
    }
    if($user.snsType == 'local') {
      myList = lists;
    } else{
      myList = lists2;
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final $user = Provider.of<UserState>(context);
    return Scaffold(appBar: _buildAppBar(), body: _buildBody($user));
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('마이', style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600),)
    );
  }

  Widget _buildBody($user) {
    return
      Scaffold(
          body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 28.h, 14.w, 30.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.account_circle, size: 46.5.w, color: Color(0XFFbbbbbb),),
                            Padding(
                              padding: EdgeInsets.only(left:14.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text($user.userEmail, style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600)),
                                  Text('${_socialLogin($user.snsType)} 계정으로 로그인', style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0XFF8a8a8a))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width:89.w,
                          height:34.h,
//                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w ),
                          decoration: BoxDecoration(
                              border: Border.all(width:1, color: Color(0XFFececec)),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => HeightChangePage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('키 ${$user.userHeight} cm' ,style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600)),
                                Icon(Icons.create, size:14.9.w)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: myList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(14.w, 15, 19.w, 15),
                            child: InkWell(
                              onTap: () {
                                switch (myList[index]['code']) {
                                  case '1' :
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => ContactPage()));
                                    break;
                                  case '2' :
                                    setState(() {
                                      this._viewData[0] = '이용약관';
                                      this._viewData[1] = 'https://fitchoo.kr/terms.html';
                                      goWebview();
                                    });
                                    break;
                                  case '3' :
                                    setState(() {
                                      this._viewData[0] = '개인정보 처리방침';
                                      this._viewData[1] = 'https://fitchoo.kr/privacy.html';
                                      goWebview();
                                    });
                                    break;
                                  case '4' :
                                    break;
                                  case '5' :
                                    _goRePwd();
                                    break;
                                  case '6' :
                                    _logOut($user);
                                    break;
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                          myList[index]['icon'],
                                          size: 24.w,
                                          color: Color(0XFFbbbbbb)),
                                      Padding(padding: EdgeInsets.only(left:15.w),
                                        child: Text('${myList[index]['title']}', style: TextStyle(fontSize: ScreenUtil().setSp(14),),),
                                      ),
                                    ],
                                  ),
                                  myList[index]['code'] == '4' ?
                                  Switch(
                                    value: _isSwitched,
                                    onChanged: (value) async{
                                      if(value == false) {
                                        _valued = 'n';
                                        final pref = await SharedPreferences.getInstance();
                                        var loginInfo =  pref.getStringList('userLoginInfo');
                                        loginInfo[4] = 'false';
                                        pref.setStringList('userLoginInfo', loginInfo);
                                        print(loginInfo);
                                        $user.setUserPushKey('false');
                                      } else {
                                        $user.setUserPushKey('true');
                                        final pref = await SharedPreferences.getInstance();
                                        var loginInfo =  pref.getStringList('userLoginInfo');
                                        loginInfo[4] = 'true';
                                        pref.setStringList('userLoginInfo', loginInfo);
                                        print(loginInfo);
                                        _valued = 'y';
                                      }
                                      setState(() {
                                        print('valued --- $_valued');
                                        _changeNoti($user, _valued);
                                        _isSwitched = value;
                                      });
                                    },
                                    activeTrackColor: Color(0XFFFF7171),
                                    activeColor: Colors.red,
                                  ):
                                  Container(),
                                ],
                              ),
                            ),
                          );
                      }
                  )
                ],
              )
          )
      );
  }

  void goWebview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return webViewPage(viewData: this._viewData);
        }));
  }
  
  void _logOut($user) {
    setState(() async{
      final pref = await SharedPreferences.getInstance();
      var loginInfo =  pref.getStringList('userLoginInfo');
      loginInfo.clear();
      pref.setStringList('userLoginInfo', loginInfo);
        if($user.snsType == 'kakao') {
          _kakaoLogout();
        } else if($user.snsType == 'naver') {
          _naverLogout();
        } else {
        }
        $user.userLogOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => InitPage()));
        $user.logout();
      
    });
  }

  Future<void> _kakaoLogout() async {
    FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
    final KakaoLoginResult result = await kakaoSignIn.logOut();
  }

  Future<void> _naverLogout() async {
    FlutterNaverLogin.logOut();
  }

  String _socialLogin(s) {
    switch(s) {
      case 'local' :
        return '핏츄';
      break;
      case 'naver' :
        return '네이버';
        break;
      case 'kakao' :
        return '카카오';
        break;
      case 'apple' :
        return '애플';
        break;
    }
  }

  void _goRePwd() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RePwdPage()));
  }

  void _changeNoti($user, value) {
    $user.changeNoti(value);
  }

}
