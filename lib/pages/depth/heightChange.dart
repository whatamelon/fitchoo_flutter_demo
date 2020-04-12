import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeightChangePage extends StatefulWidget {
  @override
  _HeightChangePageState createState() => _HeightChangePageState();
}

class _HeightChangePageState extends State<HeightChangePage> {

  TextEditingController _heightController;

  void initState() {
    super.initState();
    _heightController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    UserState $user = Provider.of<UserState>(context, listen: false);
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('키', style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, letterSpacing: -0.22),),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close, size: 30,), onPressed: () { Navigator.pop(context);})
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top:20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('내 키를 입력해주세요.', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
              Padding(
                padding: EdgeInsets.only(top:5.h),
                child: Text('내 키의 큐레이션과 상품 추천을 위해 활용됩니다.', style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),
              ),
             Padding(
               padding: EdgeInsets.fromLTRB(135.w, 60.h, 95.w, 30.h),
               child: Row(
                 children: <Widget>[
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
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top:10),
                     child: Text('cm', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                   )
                 ],
               ),
             ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 40.h, 14.w ,5),
                child: Container(
                  width: size.width*1,
                  height: 55.h,
                  child: RaisedButton(
                      elevation: 0,
                      child:
                      Text("수정", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14))),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () async{
                        final pref = await SharedPreferences.getInstance();
                        var loginInfo =  pref.getStringList('userLoginInfo');
                        loginInfo[5] = _heightController.text;
                        pref.setStringList('userLoginInfo', loginInfo);
                        $user.setUserHeight(_heightController.text);
                      }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
