import 'package:fitchoo/pages/base/home.dart';
import 'package:fitchoo/pages/tab.dart';
import 'package:fitchoo/pages/webView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class setHeightPage extends StatefulWidget {
  @override
  _setHeightPageState createState() => _setHeightPageState();
}

class _setHeightPageState extends State<setHeightPage> {
  TextEditingController _heightController;

  void initState() {
    super.initState();
    Hive.initFlutter();
    _heightController = TextEditingController();
  }

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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('내 키를 입력해주세요.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),),
                          Padding(
                            padding: const EdgeInsets.only(top:10),
                            child: Text('나와 비슷한 키의 쇼핑몰 모델을 추천해드려요.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.grey),),
                          ),
                          SizedBox(
                            height: size.height * 0.06,
                            width: size.width * 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(120, 100, 120, 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _heightInput(),
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: Text('cm', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                                )
                              ],
                            ),
                          ),
                          _submitHeightButton(size)
                        ],
                      )
                  ),
                );
            }
        ));
  }

 Widget _heightInput() =>
     Flexible(
       child: TextField(
         keyboardType: TextInputType.number,
         inputFormatters: <TextInputFormatter>[
           WhitelistingTextInputFormatter.digitsOnly,
           LengthLimitingTextInputFormatter(3),
         ],
         textAlign: TextAlign.center,
         controller: _heightController,
         style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
         decoration: new InputDecoration(
             contentPadding: EdgeInsets.all(5),
             focusedBorder: UnderlineInputBorder(
               borderSide: BorderSide(color: Colors.black, width:6),
             ),
         ),
       ),
     );

 Widget _submitHeightButton(Size size) =>
     Container(
       width: size.width*0.9,
       height: size.width*0.12,
       child: RaisedButton(
           child: (_heightController.text.length < 3) ?
           Text("내 키를 입력해주세요", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 15))
           : Text("시작하기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
          color: (_heightController.text.length < 3) ?
          Colors.black : Colors.red,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(5)),
           onPressed: () async{
             var box = await Hive.openBox('userInfo');
             box.put('userHeight', _heightController.text);
             var box2 = Hive.box('userInfo');
             print('userInfo in Hive: $box2');
             await box.close();
             UserState $user = Provider.of<UserState>(context, listen: false);
             $user.setUserHeight(_heightController.text);
             Navigator.pushReplacement(context,
                 MaterialPageRoute(builder: (context) => TabPage()));
       }),
     );


}
