import 'dart:async';
import 'dart:io';

import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RePwdPage extends StatefulWidget {
  @override
  _RePwdPageState createState() => _RePwdPageState();
}

class _RePwdPageState extends State<RePwdPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _thispwController = TextEditingController();
  final TextEditingController _newpwController = TextEditingController();
  final TextEditingController _newpw2Controller= TextEditingController();
  String _wh = '';
  String _observer = '';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    UserState $user = Provider.of<UserState>(context, listen: false);
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () { Navigator.pop(context);}),
        title: Text('비밀번호 변경', style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, letterSpacing: -0.22),),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      obscureText: true,
                      controller: _thispwController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(14.5.w, 15.h, 14.5.w, 16.h),
                          labelText: "현재 비밀번호",
                          labelStyle: TextStyle(color: Color(0XFF8a8a8a)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(14)),
                          helperText: _wh == 'pw' ? _helpText($user.signStr) : '',
                          helperStyle: TextStyle(color: Color(0XFFec3e39), fontSize: ScreenUtil().setSp(12)),
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
                        height: 16.h
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _newpwController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(14.5.w, 15.h, 14.5.w, 16.h),
                          labelText: "새로운 비밀번호(8~20자리)",
                          labelStyle: TextStyle(color: Color(0XFF8a8a8a)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(14)),
                          helperText: _wh == 'pw' ? _helpText($user.signStr) : '',
                          helperStyle: TextStyle(color: Color(0XFFec3e39), fontSize: ScreenUtil().setSp(12)),
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
                        height: 16.h
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _newpw2Controller,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(14.5.w, 15.h, 14.5.w, 16.h),
                          labelText: "비밀번호 확인",
                          labelStyle: TextStyle(color: Color(0XFF8a8a8a)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0XFFececec), width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(14)),
                          helperText: _wh == 'pw' ? _helpText($user.signStr) : '',
                          helperStyle: TextStyle(color: Color(0XFFec3e39), fontSize: ScreenUtil().setSp(12)),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 22.h, 14.w ,0),
                  child: Container(
                    width: size.width*1,
                    height: 49.h,
                    child: RaisedButton(
                      elevation: 0,
                      child:
                      Text("비밀번호 변경", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14))),
                      color: new Color(0XFFec3e39),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        setState(() {
                          final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_thispwController.text);
                          if(!emailValid) {
                            this._wh = 'id';
                            this._observer = '이메일 형식이 아닙니다.';
                          }else if(_newpwController.text =='') {
                            this._wh = 'pw';
                            this._observer = '비밀번호를 입력해주세요.';
                          }else if(_newpwController.text.length < 8 || _newpwController.text.length >20) {
                            this._wh = 'pw';
                            this._observer = '비밀번호가 8자리 이하, 20자리 이상입니다.';
                          }else if(_newpwController.text != _newpw2Controller.text) {
                            this._wh = 'pw2';
                            this._observer = '비밀번호가 일치하지 않습니다.';
                          }else if (_newpw2Controller.text == '') {
                            this._wh = 'pw2';
                            this._observer = '비밀번호번호 확인을 입력해주세요.';
                          }
                          else {
                            UserState $user = Provider.of<UserState>(context, listen: false);
                            $user.changePw(_thispwController.text,_newpwController.text);

                            Timer(Duration(seconds: 1), () async{
                              if($user.signUpMes) {
                                Fluttertoast.showToast(
                                    msg: "비밀번호가 변경되었습니다.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                $user.setUserPassword(_newpwController.text);
                              } else {
                                setState(() {
                                  this._observer = $user.signStr;
                                });
                              }
                            });
                          }
                        });
                      },
                    ),
                  ),
                )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  _helpText(String signStr) {
    return this._observer;
  }
}
