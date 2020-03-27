import 'package:fitchoo/pages/depth/contact.dart';
import 'package:fitchoo/pages/initial/privacy.dart';
import 'package:fitchoo/pages/initial/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../init.dart';

class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
    Hive.initFlutter();
  }
  @override
  Widget build(BuildContext context) {
    final $user = Provider.of<UserState>(context);
    return Scaffold(appBar: _buildAppBar(), body: _buildBody($user));
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('마이', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
    );
  }

  Widget _buildBody($user) {
    final lists = [
    {
      'title': '이용 문의',
      'code': '1',
      'icon': Icons.live_help
    },
    {
      'title': '이용 약관',
      'code': '2',
      'icon': Icons.list
    },
    {
      'title': '개인 정보 취급 방침',
      'code': '3',
      'icon': Icons.verified_user
    },
    {
      'title': '알림 설정',
      'code': '4',
      'icon': Icons.notifications
    },
    {
      'title': '로그아웃',
      'code': '5',
      'icon': Icons.input
    },
  ];
    return
      Scaffold(
          body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(30),
                  ),
                  Center(
                      child: Text(
                        '${$user.userEmail}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      )),
                  Padding(
                    padding: EdgeInsets.all(30),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: lists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(25, 15, 0, 15),
                            child: InkWell(
                              onTap: () {
                                switch (lists[index]['code']) {
                                  case '1' :
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => ContactPage()));
                                    break;
                                  case '2' :
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => TermsPage()));
                                    break;
                                  case '3' :
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => PrivacyPage()));
                                    break;
                                  case '4' :

                                    break;
                                  case '5' :
                                    _logOut($user);
                                    break;
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                      Icon(
                                        lists[index]['icon'],
                                        size: 35,
                                        color: Color(0XFFbbbbbb)),
                                  Padding(padding: const EdgeInsets.only(left:15),
                                    child: Text('${lists[index]['title']}', style: TextStyle(fontSize: 20,),),
                                  )
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
  
  void _logOut($user) {
    setState(() async{
        var box = await Hive.openBox('userInfo');
        box.delete('accessToken');
        var box2 = Hive.box('userInfo');
        print('userInfo in Hive: $box2<dynamic>');
        await box.close();
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
}
