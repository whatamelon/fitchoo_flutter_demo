import 'package:fitchoo/pages/webView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<String> _viewData = ['', ''];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () { Navigator.pop(context);}),
        title: Text('이용문의', style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, letterSpacing: -0.22),),
        centerTitle: true,
        elevation: 1,
      ),
      body: _contactBody(size),
    );
  }

 Widget _contactBody(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(height: 21.h,),
        Text('서비스 이용에 대해', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
        Text('궁금한 점이 있으세요?', style: TextStyle(fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w900),),
        Container(height: 10.h,),
        Text('어떤 내용이든 괜찮습니다.', style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),
        Text('FITCHOO 인스타그램 DM을 보내주세요.', style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),
        Text('빠른 시간 내에 답변을 드리겠습니다.', style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0XFF8a8a8a), letterSpacing: -0.12),),
        Container(height: 30.h,),
        Image.asset('assets/color_insta.png', width: 50.w, height: 50.h),
        Container(height: 10.h,),
        Text('@fitchoo_style', style: TextStyle(fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w600),),

        Padding(
          padding: EdgeInsets.fromLTRB(14.w, 40.h, 14.w ,5),
          child: Container(
            width: size.width*1,
            height: 55.h,
            child: RaisedButton(
              elevation: 0,
                child:
                Text("FITCHOO 인스타그램 바로가기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14))),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  setState(() {
                    this._viewData[0] = '핏츄 인스타';
                    this._viewData[1] = 'https://www.instagram.com/fitchoo_style/';
                    goWebview();
                  });
                }
            ),
          ),
        )
      ],
    );
 }

  void goWebview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return webViewPage(viewData: this._viewData);
        }));
  }
  
}
