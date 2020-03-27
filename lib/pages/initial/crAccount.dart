import 'dart:async';
import 'dart:io';

import 'package:fitchoo/pages/initial/setHeight.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class CrAccountPage extends StatefulWidget {
  @override
  _CrAccountPageState createState() => _CrAccountPageState();
}

class _CrAccountPageState extends State<CrAccountPage> {
  Box userInfo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  String _observer = '';
  bool check = false;

  @override
  void initState() {
    super.initState();
    Hive.initFlutter();
//    autoLogIn();
  }
//  String autoLoginId = '';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('회원가입', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return
                SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(size.width*0.05, 60, 0 ,20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('이메일만 있으면', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                  Text('순식간에 가입 끝!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.only(top:10.0),
                                    child: Text('간편하게 가입하고 서비스를 시작해보세요.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Color(0XFF8a8a8a)),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Container(
                            child: _inputForm2(size),
                          ),
                          _authButton(size),
                        ],
                      )
                  ),
                );
            }
        ));
  }

  Widget _inputForm2(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width*0.05, 10, size.width*0.05, 0),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "이메일",
                    labelStyle: TextStyle(
                        color: Color(0XFF8a8a8a)
                    ),
                    hintText: "이메일",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF8a8a8a)),
                        borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF8a8a8a)),
                        borderRadius: BorderRadius.circular(8.0))
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "이메일을 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top:20)
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: "비밀번호(8~20자리)",
                    labelStyle: TextStyle(
                        color: Color(0XFF8a8a8a)
                    ),
                    hintText: "비밀번호(8~20자리)",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF8a8a8a)),
                        borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF8a8a8a)),
                        borderRadius: BorderRadius.circular(8.0))
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "비밀번호를 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top:20)
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController2,
                decoration: InputDecoration(
                    labelText: "비밀번호 확인",
                    labelStyle: TextStyle(
                        color: Color(0XFF8a8a8a)
                    ),
                    hintText: "비밀번호 확인",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF8a8a8a)),
                        borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF8a8a8a)),
                        borderRadius: BorderRadius.circular(8.0))
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "비밀번호를 적어주세요.";
                  } else if(_passwordController != _passwordController2) {
                    return "비밀번호가 일치하지 않습니다.";
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0 ,5),
                child: Text('${_observer}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color:Colors.red),),
              ),
              Row(
                children: <Widget>[
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: SizedBox(
                      width:Checkbox.width*1.5,
                      height:Checkbox.width*1.5,
                      child: Container(
                        decoration: new BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: new BorderRadius.circular(50),
                        ),
                        child: Theme(
                          data:ThemeData(
                            unselectedWidgetColor: Colors.transparent,
                          ),
                          child: Transform.scale(
                            scale:1.5,
                            child: Checkbox(
                              activeColor: new Color(0XFFec3e39),
                              checkColor: Colors.white,
                              value: check,
                              onChanged: (bool newValue) {
                                setState(() {
                                  check = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:5),
                    child: Text("자동로그인", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _authButton(Size size) => Padding(
    padding: EdgeInsets.fromLTRB(size.width*0.05, 20, size.width*0.05 ,5),
    child: Container(
      width: size.width*1,
      height: size.width*0.14,
            child: RaisedButton(
              child: Text("시작하기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
              color: new Color(0XFFec3e39),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                setState(() async{
                  print('1');
                    final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);
                    if(!emailValid) {
                      this._observer = '이메일 형식이 아닙니다.';
                    }else if(_passwordController.text =='') {
                      this._observer = '비밀번호를 입력해주세요.';
                    }else if(_passwordController.text.length < 8 || _passwordController.text.length >20) {
                      this._observer = '비밀번호가 8자리 이하, 20자리 이상입니다.';
                    }else if(_passwordController.text != _passwordController2.text) {
                      this._observer = '비밀번호가 일치하지 않습니다.';
                    }else if (_passwordController2.text == '') {
                      this._observer = '비밀번호번호 확인을 입력해주세요.';
                    }else if(_passwordController2.text.length < 8 || _passwordController2.text.length >20) {
                      this._observer = '비밀번호확인이 8자리 이하, 20자리 이상입니다.';
                    }
                    else {
                      print('2');
                      UserState $user = Provider.of<UserState>(context, listen: false);
                      $user.setUserSNSType('local');
                      if(Platform.isAndroid ){
                        $user.setUserAppType('android3');
                      }else if(Platform.isIOS) {
                        $user.setUserAppType('ios');
                      }
                      $user.setUserEmail(_emailController.text);
                      $user.setUserPassword(_passwordController.text);
                      $user.signUp();
                      Timer(Duration(seconds: 1), () async{
                        if ($user.signUpMes) {
                          $user.userLogIn();
                          print('3');

                          var box = await Hive.openBox('userInfo');
                          box.put('snsType', 'local');
                          box.put('userEmail', _emailController.text);
                          box.put('password', _passwordController.text);
                          box.put('snsId', '');
                          box.put('appType', $user.appType);
                          box.put('pushKey', '');
                          box.put('deviceInfo', $user.deviceInfo);
                          box.put(
                              'options', check == true ? 'push' : 'default');
                          box.put('accessToken', $user.accessToken);
                          var box2 = Hive.box('userInfo');
                          print('userInfo in Hive: $box2');
                          await box.close();

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (context) => setHeightPage()));
                        } else {
                          this._observer = '회원가입에 실패했습니다.';
                        }
                      });
                    }
                });
                print('${_emailController.text}');
                print('${_passwordController.text}');
                print('${_passwordController2.text}');
              },
            ),
          ),
  );

}

