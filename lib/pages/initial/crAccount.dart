import 'dart:async';
import 'dart:io';
import 'package:fitchoo/pages/initial/setHeight.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrAccountPage extends StatefulWidget {
  @override
  _CrAccountPageState createState() => _CrAccountPageState();
}

class _CrAccountPageState extends State<CrAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  String _observer = '';
  bool check = true;
  String _wh = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () { Navigator.pop(context);}),
          title: Text('회원가입', style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, letterSpacing: -0.22),),
          centerTitle: true,
          elevation: 1,
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
                              padding: EdgeInsets.fromLTRB(14.w, 20.h, 14.w ,30.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('이메일만 있으면', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
                                  Text('순식간에 가입 끝!', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
                                  Padding(
                                    padding: const EdgeInsets.only(top:10.0),
                                    child: Text('간편하게 가입하고 서비스를 시작해보세요.',
                                      style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),)
                                ],
                              ),
                            ),
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
    UserState $user = Provider.of<UserState>(context, listen: false);
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
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
            children: <Widget>[TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(14.5.w, 15.h, 14.5.w, 16.h),
                      labelText: "이메일",
                      labelStyle: TextStyle( color: Color(0XFF8a8a8a),fontSize: ScreenUtil().setSp(14)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintStyle: TextStyle(
                          color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(14)
                      ),
                      helperText: _wh == 'id' ? _helpText($user.signStr):'',
                      helperStyle: TextStyle(
                          color: Color(0XFFec3e39), fontSize: ScreenUtil().setSp(12)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                          borderRadius: BorderRadius.circular(5))
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "이메일을 적어주세요.";
                    } else {
                      return null;
                    }
                  },
                ),
              Container(
                  height:10.h
              ),TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(14.5.w, 15.h, 14.5.w, 16.h),
                      labelText: "비밀번호(8~20)자리",
                      labelStyle: TextStyle( color: Color(0XFF8a8a8a),fontSize: ScreenUtil().setSp(14)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintStyle: TextStyle(
                          color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(14)
                      ),
                      helperText: _wh == 'pw' ? _helpText($user.signStr):'',
                      helperStyle: TextStyle(
                          color: Color(0XFFec3e39), fontSize: ScreenUtil().setSp(12)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                          borderRadius: BorderRadius.circular(5))
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
                  height:10.h
              ),TextFormField(
                  obscureText: true,
                  controller: _passwordController2,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(14.5.w, 15.h, 14.5.w, 16.h),
                      labelText: "비밀번호 확인",
                      labelStyle: TextStyle( color: Color(0XFF8a8a8a),fontSize: ScreenUtil().setSp(14)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintStyle: TextStyle(
                          color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(14)
                      ),
                      helperText: _wh == 'pw2' ? _helpText($user.signStr):'',
                      helperStyle: TextStyle(
                          color: Color(0XFFec3e39), fontSize: ScreenUtil().setSp(12)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                          borderRadius: BorderRadius.circular(5))
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _authButton(Size size) => Padding(
    padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w ,0),
    child: Container(
      width: size.width*1,
      height: 49.h,
      child: RaisedButton(
        elevation: 0,
        child:
        Text("시작하기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14))),
        color: new Color(0XFFec3e39),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                setState(() async{
                  print('1');
                    final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);
                    if(!emailValid) {
                      this._wh = 'id';
                      this._observer = '이메일 형식이 아닙니다.';
                    }else if(_passwordController.text =='') {
                      this._wh = 'pw';
                      this._observer = '비밀번호를 입력해주세요.';
                    }else if(_passwordController.text.length < 8 || _passwordController.text.length >20) {
                      this._wh = 'pw';
                      this._observer = '비밀번호가 8자리 이하, 20자리 이상입니다.';
                    }else if(_passwordController.text != _passwordController2.text) {
                      this._wh = 'pw2';
                      this._observer = '비밀번호가 일치하지 않습니다.';
                    }else if (_passwordController2.text == '') {
                      this._wh = 'pw2';
                      this._observer = '비밀번호번호 확인을 입력해주세요.';
                    }
                    else {
                      print('2');
                      UserState $user = Provider.of<UserState>(context, listen: false);
                      $user.setUserSNSType('local');
                      $user.setUserEmail(_emailController.text);
                      $user.setUserPassword(_passwordController.text);
                      bool signUpres = await $user.signUp();
                        if (signUpres) {
                          $user.userLogIn();
                          print('3');

                          final pref = await SharedPreferences.getInstance();
                          var loginInfo =  pref.getStringList('userLoginInfo');
                          if(loginInfo == null) {
                            pref.setStringList('userInfo', []);
                          }
                          List<String> userInfoBox = [];
                          userInfoBox.insert(0,'local');
                          userInfoBox.insert(1,_emailController.text);
                          userInfoBox.insert(2,_passwordController.text);
                          userInfoBox.insert(3,'');
                          userInfoBox.insert(4,'true');

                          pref.setStringList('userLoginInfo', userInfoBox);

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (context) => setHeightPage()));
                        } else {
                          setState(() {
                            print($user.signStr);
                            this._observer = $user.signStr;
                          });
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

  _helpText(String signStr) {
    return this._observer;
  }

}

