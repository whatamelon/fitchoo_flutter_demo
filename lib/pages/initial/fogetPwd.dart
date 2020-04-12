import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/initial/login.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ForgetPwdPage extends StatefulWidget {
  @override
  _ForgetPwdPageState createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _rePwdController = TextEditingController();
  String _observer = '';
  bool _submit = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () { Navigator.pop(context);}),
          title: Text('비밀번호 재설정', style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, letterSpacing: -0.22),),
          centerTitle: true,
          elevation: 1,
        ),
        body : SingleChildScrollView(
            child:
            _submit ?
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('메일이 발송되었습니다.', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
                      child: Text('이메일 계정에서 임시 비밀번호를 확인해주세요.',
                        style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),),
                    _authButton(size),
                  ],
                ),
              ),
            ):
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(size.width*0.05, 0, 0 ,5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('임시 비밀번호를 가입하신', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
                        Text('이메일로 발송합니다.', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: Text('가입하신 이메일 주소를 입력해주세요.',style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: _inputForm(size),
                ),
                _authButton(size),
              ],
        )
      ));
    }

 Widget _authButton(Size size) =>
     Padding(
       padding: EdgeInsets.fromLTRB(14.w, 0.h, 14.w ,0),
       child: Container(
         width: size.width*1,
         height: 49.h,
         child: RaisedButton(
             elevation: 0,
             child:
             _submit ?
             Text("로그인하러 가기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14))):
             Text("임시 비밀번호 발급받기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14))),
             color: new Color(0XFFec3e39),
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(5)),
             onPressed: () async{
               setState(() {
                   if(_rePwdController.text == ''){
                     this._observer = '이메일을 입력해주세요.';
                   }
                   else if(!this._submit) {
                     this._submit = true;
                   } else {
                     UserState $user = Provider.of<UserState>(context, listen: false);
                     $user.userTemppw(_rePwdController.text);
//                     Navigator.pushReplacement(context,
//                         MaterialPageRoute(builder: (context) => AuthPage()));

                     Navigator.pop(context);
                   }
                 });
             }
           ),
         ),
     );

 Widget _inputForm(Size size) {
   UserState $user = Provider.of<UserState>(context, listen: false);
   return Padding(
     padding: EdgeInsets.fromLTRB(size.width*0.05, 10, size.width*0.05, 10),
     child: Form(
         key: _formKey,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[TextFormField(
                 controller: _rePwdController,
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
                     helperText: _helpText($user.signStr),
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
           ],
         ),
       ),
   );
 }

  _helpText(String signStr) {
   return this._observer;
  }
}
