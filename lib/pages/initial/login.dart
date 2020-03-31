import 'dart:async';
import 'dart:io';
import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/initial/crAccount.dart';
import 'package:fitchoo/pages/initial/rePwd.dart';
import 'package:fitchoo/pages/initial/setHeight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fitchoo/pages/tab.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  Box userInfo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _observer = '';
  bool check = true;
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
        title: Text('로그인', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                            padding: EdgeInsets.fromLTRB(size.width*0.05, 20, 0 ,20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('서비스 이용을 위해', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                Text('로그인해주세요.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: const EdgeInsets.only(top:10.0),
                                  child: Text('가입했던 이메일과 비밀번호를 입력해주세요.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Color(0XFF8a8a8a)),),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Container(
                          child: _inputForm(size)
                        ),
                        _authButton(size),
                      ],
                    )
              ),
            );
        }
      ));
  }


  Widget _inputForm(Size size) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height:size.width*0.14,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
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
              ),
              Padding(
                padding: EdgeInsets.only(top:size.height*0.04)
              ),
              SizedBox(
                height: size.width*0.14,
                child: TextFormField(
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
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0 ,5),
                child: Text('${_observer}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color:Colors.red),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Text('비밀번호 재설정', style: TextStyle(fontSize: 16)),
                        onTap: _forgetPwd,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                        child: Container(
                          height: 15,
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        child: Text('회원가입', style: TextStyle(fontSize: 16)),
                        onTap: _goToCrAccount,
                      ),
                    ],
                  ),
                ]
               )
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
            height: size.width*0.13,
            child: RaisedButton(
              child:
              Text("시작하기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
              color: new Color(0XFFec3e39),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                setState(() {
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

                      Timer(Duration(seconds: 1), () async{
                        if($user.accessToken == null) {
                          setState(() {
                            this._observer = $user.signStr;
                          });
                        }
                        else if ($user.accessToken == ''){
                          setState(() {
                            this._observer = $user.signStr;
                          });
                        }
                        else {
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
                      });
                    }
                });
                print('${_emailController.text}');
                print('${_passwordController.text}');
              },
            ),
          ),
  );


  void _forgetPwd() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RePwdPage()));
  }

  void _goToCrAccount() {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => CrAccountPage()));
  }
}


