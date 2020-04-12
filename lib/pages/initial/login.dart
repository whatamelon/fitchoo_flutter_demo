import 'dart:async';
import 'dart:io';
import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/initial/crAccount.dart';
import 'package:fitchoo/pages/initial/fogetPwd.dart';
import 'package:fitchoo/pages/initial/setHeight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _observer = '';
  String _wh = '';
  bool check = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () { Navigator.pop(context);}),
        title: Text('로그인', style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, letterSpacing: -0.22),),
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
                                Text('서비스 이용을 위해', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
                                Text('로그인해주세요.', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Text('가입했던 이메일과 비밀번호를 입력해주세요.',
                                    style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),
                                )
                              ],
                            ),
                          ),
                        ),
//                        Padding(
//                          padding: EdgeInsets.only(top: 10),
//                        ),
                        _inputForm(size),
                        _authButton(size),
                      ],
                    )
              ),
            );
        }
      ));
  }


  Widget _inputForm(Size size) {
    UserState $user = Provider.of<UserState>(context, listen: false);
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  TextFormField(
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
                height:16.h
              ),
                TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(14.5.w, 15.h, 14.5.w, 16.h),
                        labelText: "비밀번호(8~20자리)",
                        labelStyle: TextStyle(
                            color: Color(0XFF8a8a8a)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Text('비밀번호 재설정', style: TextStyle(fontSize: ScreenUtil().setSp(12),fontWeight: FontWeight.w600)),
                        onTap: _forgetPwd,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 3.h, 10.w,1.h),
                        child: Container(
                          height: 15.h,
                          width: 1.w,
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        child: Text('회원가입', style: TextStyle(fontSize: ScreenUtil().setSp(12),fontWeight: FontWeight.w600)),
                        onTap: _goToCrAccount,
                      ),
                    ],
                  ),
                ]
               )
            ],
          ),
        ),
    );
  }

  Widget _authButton(Size size) => Padding(
    padding: EdgeInsets.fromLTRB(14.w, 22.h, 14.w ,0),
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
              onPressed: () async{
                  final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);
                    if(!emailValid) {
                      this._wh = 'id';
                      this._observer = '이메일 형식이 아닙니다.';
                    }
                    else if(_emailController.text == ''){
                      this._wh = 'id';
                      this._observer = '이메일을 입력해주세요.';
                    }else if(_passwordController.text == ''){
                      this._wh = 'pw';
                      this._observer = '비밀번호를 입력해주세요.';
                    }
                    else {
                      UserState $user = Provider.of<UserState>(context, listen: false);
                      $user.setUserSNSType('local');
                      $user.setUserEmail(_emailController.text);
                      $user.setUserPassword(_passwordController.text);
                      bool loginState = await $user.userLogIn();

                      print('로그인합니다.');

                      if(loginState) {
                        print('이거 된거맞음?.');
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

                        $user.login();
                        if($user.userHeight == 0) {
                          print('키 없음.');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => setHeightPage()));
                        } else {
                          print('탭으로갑니당.');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => TabPage()));
                        }
                      } else {
                        setState(() {
                          this._observer = $user.signStr;
                        });
                      }

                    }
                print('${_emailController.text}');
                print('${_passwordController.text}');
              },
            ),
          ),
  );


  void _forgetPwd() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgetPwdPage()));
  }

  void _goToCrAccount() {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => CrAccountPage()));
  }

  _helpText(String signStr) {
    return this._observer;
  }
}


