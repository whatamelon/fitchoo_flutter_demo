import 'package:flutter/material.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';

import '../init.dart';

class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final $user = Provider.of<UserState>(context);
    return Scaffold(appBar: _buildAppBar(), body: _buildBody($user));
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Image.asset(
        'assets/black_logo.png',
        width: 120,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.favorite_border), iconSize: 22, onPressed: () {}),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 10, 0),
          child: IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildBody($user) {
    final lists = [
      {
        'title': '키',
        'code': '1',
      },
      {
        'title': '내가 팔로우한 모델',
        'code': '2',
      },
      {
        'title': '찜',
        'code': '3',
      },
      {
        'title': '비밀번호 변경',
        'code': '4',
      },
      {
        'title': '이용 문의',
        'code': '5',
      },
      {
        'title': '이용 약관',
        'code': '6',
      },
      {
        'title': '개인 정보 취급 방침',
        'code': '7',
      },
      {
        'title': '모델 등록 문의',
        'code': '8',
      },
      {
        'title': '알림 설정',
        'code': '9',
      },
      {
        'title': '로그아웃',
        'code': '10',
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
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: lists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: Container(
                                height: 45,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${lists[index]["title"]}')
                                    ]
                                ),
                              ),
                            ),
                            onTap: () {
                              print('${lists[index]['code']}');
                              if (lists[index]['code'] == '10') {
                                if($user.snsType == 'kakao') {
                                  _kakaoLogout();
                                } else if($user.snsType == 'naver') {
                                  _naverLogout();
                                } else {
                                  $user.userLogOut();
                                }
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => InitPage()));
                                $user.logout();
                              }
                            }
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        if (index == 3 || index == 7) {
                          return Divider(
                            height: 20,
                            color: Color(0xffececec),
                            thickness: 10,
                          );
                        }
                        else {
                          return Divider(
                            color: Color(0xffececec),
                            thickness: 1,
                          );
                        }
                      }
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10)
                  ),
                  Container(
                    height: 40,
                    color: Color(0xffececec),
                  )
                ],
              )
          )
      );
  }

  Future<void> _kakaoLogout() async {
    FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
    final KakaoLoginResult result = await kakaoSignIn.logOut();
  }

  Future<void> _naverLogout() async {
    FlutterNaverLogin.logOut();
  }
}
