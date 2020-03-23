import 'dart:io';
import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/initial/rePwd.dart';
import 'package:fitchoo/pages/initial/setHeight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  String _observer = '';
  bool check = false;
  bool _islogin = true;
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
      body : LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 60),
                        ),
                        Stack(
                          children: <Widget>[
                            Positioned(
                                top:0,
                                left: 20,
                                child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:100),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                        child: Text('로그인',
                                            style: _islogin
                                                ? TextStyle(fontWeight: FontWeight.bold, fontSize: 36)
                                                : TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.grey)
                                        ),
                                        onTap: _toggleCreateAccount
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Container(color: Colors.black, height:35, width:5),
                                    ),
                                    InkWell(
                                        child: Text('회원가입',
                                            style: _islogin
                                            ? TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.grey)
                                            : TextStyle(fontWeight: FontWeight.bold, fontSize: 36)
                                        ),
                                        onTap: _toggleLogin
                                    ),
                                  ]
                              ),
                            ),
                                Container(
                                  child: (_islogin) ?
                                  _inputForm(size) :
                                  _inputForm2(size),
                                ),
                            Positioned(
                                left: size.width * 0.07,
                                right: size.width * 0.07,
                                bottom:100,
                                child: Text('${_observer}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color:Colors.red),)
                            ),
                            _authButton(size),
                          ],
                        ),
                      ],
                    )
              ),
            );
        }
      ));
  }


  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width*0.05, 60, size.width*0.05, size.width*0.05),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 160,
          bottom: 120,
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
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "이메일을 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "비밀번호(8~20자리)",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "비밀번호를 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              Container(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: check,
                        onChanged: (bool newValue) {
                          setState(() {
                            check = newValue;
                          });
                        },
                      ),
                      Text("자동로그인"),
                    ],
                  ),
                  InkWell(
                      child: Text('비밀번호를 잊으셨나요?'),
                      onTap: _forgetPwd,
                  ),
                ]
               )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputForm2(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width*0.05, 60, size.width*0.05, size.width*0.05),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 160,
          bottom: 120,
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
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "이메일을 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "비밀번호(8~20자리)",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "비밀번호를 적어주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _passwordController2,
                decoration: InputDecoration(
                  labelText: "비밀번호확인",
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
              Container(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _authButton(Size size) =>
      Positioned(
        left: size.width * 0.07,
        right: size.width * 0.07,
        bottom: 20,
        child: Container(
          width: size.width*0.9,
          height: size.width*0.12,
          child: RaisedButton(
            child: (_islogin) ?
            Text("로그인", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18))
            : Text("회원가입", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onPressed: () async{
              setState(() async{
                if(_islogin) {
                  if(_emailController.text == ''){
                    this._observer = '이메일을 입력해주세요.';
                  }else if(_passwordController.text == ''){
                    this._observer = '비밀번호를 입력해주세요.';
                  }
                  else {
                    UserState $user = Provider.of<UserState>(context, listen: false);
                    $user.setUserSNSType('local');
                    if(Platform.isAndroid ){
                      $user.setUserAppType('android');
                    }else if(Platform.isIOS) {
                      $user.setUserAppType('ios');
                    }
                    $user.setUserEmail(_emailController.text);
                    $user.setUserPassword(_passwordController.text);
                    $user.userLogIn();
                    if($user.accessToken == null) {
                      this._observer = '이미 존재하는 이메일입니다.';
                    }else {
                      var box = await Hive.openBox('userInfo');
                      box.put('snsType', 'local');
                      box.put('userEmail', _emailController.text);
                      box.put('password', _passwordController.text);
                      box.put('snsId', '');
                      box.put('appType', $user.appType);
                      box.put('pushKey', '');
                      box.put('deviceInfo', $user.deviceInfo);
                      box.put('options', check == true ? 'push':'default');
                      box.put('accessToken', $user.accessToken);
                      var box2 = Hive.box('userInfo');
                      print('userInfo in Hive: $box2');
                      await box.close();

                      $user.login();
                      if($user.userHeight != null || $user .userHeight != 0) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => TabPage()));
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => setHeightPage()));
                      }
                    }
                  }
                }
                else{
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
                    UserState $user = Provider.of<UserState>(context, listen: false);
                    $user.setUserSNSType('local');
                    if(Platform.isAndroid ){
                      $user.setUserAppType('android3');
                    }else if(Platform.isIOS) {
                      $user.setUserAppType('ios3');
                    }
                    $user.setUserEmail(_emailController.text);
                    $user.setUserPassword(_passwordController.text);
                    $user.signUp();
                    if($user.signUpMes) {
                      $user.userLogIn();

                      var box = await Hive.openBox('userInfo');
                      box.put('snsType', 'local');
                      box.put('userEmail', _emailController.text);
                      box.put('password', _passwordController.text);
                      box.put('snsId', '');
                      box.put('appType', $user.appType);
                      box.put('pushKey', '');
                      box.put('deviceInfo', $user.deviceInfo);
                      box.put('options', 'push');
                      box.put('accessToken', $user.accessToken);
                      var box2 = Hive.box('userInfo');
                      print('userInfo in Hive: $box2');
                      await box.close();

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => setHeightPage()));
                    }else {
                      this._observer = '회원가입에 실패했습니다.';
                    }
                  }
                }
              });
              print('${_emailController.text}');
              print('${_passwordController.text}');
              print('${_passwordController2.text}');
            },
          ),
        ),
      );


  void _toggleLogin() {
    setState(() {
      this._islogin = false;
      this._observer = '';
      this._emailController.text = '';
      this._passwordController.text = '';
      this._passwordController2.text = '';
    });
  }

  void _toggleCreateAccount() {
    setState(() {
      this._islogin = true;
      this._observer = '';
      this._emailController.text = '';
      this._passwordController.text = '';
      this._passwordController2.text = '';
    });
  }


  void _forgetPwd() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => RePwdPage()));
  }
}


