import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/initial/login.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RePwdPage extends StatefulWidget {
  @override
  _RePwdPageState createState() => _RePwdPageState();
}

class _RePwdPageState extends State<RePwdPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _rePwdController = TextEditingController();
  String _observer = '';
  bool _submit = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('비밀번호 재설정', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
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
                    Text('메일이 발송되었습니다.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
                      child: Text('이메일 계정에서 임시 비밀번호를 확인해주세요.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Color(0XFF8a8a8a))),
                    ),
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
                        Text('임시 비밀번호를 가입하신', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                        Text('이메일로 발송합니다.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: Text('가입하신 이메일 주소를 입력해주세요.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0XFF8a8a8a)),),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: _inputForm(size),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(size.width*0.05, 0, 0,20),
                  child: Text('${_observer}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color:Colors.red),),
                ),
                _authButton(size),
              ],
        )
      ));
    }

 Widget _authButton(Size size) =>
     Padding(
       padding: EdgeInsets.fromLTRB(size.width*0.05, 0, size.width*0.05 ,20),
       child: Container(
           width: size.width*1,
           height: size.width*0.14,
           child: RaisedButton(
             child:
             _submit ?
             Text("로그인하러 가기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18)):
             Text("임시 비밀번호 발급받기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
             color: new Color(0XFFec3e39),
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8)),
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
   return Padding(
     padding: EdgeInsets.fromLTRB(size.width*0.05, 10, size.width*0.05, 10),
     child: Padding(
       padding: const EdgeInsets.only(
         left: 0,
         right: 0,
         top: 20,
         bottom: 5,
       ),
       child: Form(
         key: _formKey,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             SizedBox(
               height: size.width*0.14,
               child: TextFormField(
                 controller: _rePwdController,
                 decoration: InputDecoration(
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
           ],
         ),
       ),
     ),
   );
 }
}
