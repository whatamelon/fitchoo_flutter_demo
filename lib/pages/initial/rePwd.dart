import 'package:fitchoo/pages/init.dart';
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
                                padding: EdgeInsets.fromLTRB(size.width * 0.07, 100 ,0, 0),
                                child: Text('비밀번호 재설정', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
                              ),
                              Container(
                                child: _inputForm(size),
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

 Widget _authButton(Size size) =>
     Positioned(
       left: size.width * 0.07,
       right: size.width * 0.07,
       bottom: 20,
       child: Container(
         width: size.width*0.9,
         height: size.width*0.12,
         child: RaisedButton(
           child: Text("임시 비밀번호 발급받기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
           color: Colors.red,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(5)),
           onPressed: () async{
             setState(() async{
                 if(_rePwdController.text == ''){
                   this._observer = '이메일을 입력해주세요.';
                 }
                 else {
                   UserState $user = Provider.of<UserState>(context, listen: false);
                   $user.userTemppw(_rePwdController.text);
                       Navigator.pushReplacement(context,
                           MaterialPageRoute(builder: (context) => InitPage()));
                 }
               });
           }
         ),
       ));

 Widget _inputForm(Size size) {
   return Padding(
     padding: EdgeInsets.fromLTRB(size.width*0.05, 60, size.width*0.05, size.width*0.05),
     child: Padding(
       padding: const EdgeInsets.only(
         left: 12,
         right: 12,
         top: 100,
         bottom: 120,
       ),
       child: Form(
         key: _formKey,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             TextFormField(
               controller: _rePwdController,
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
           ],
         ),
       ),
     ),
   );
 }
}
