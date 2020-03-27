import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('이용문의', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 10, 0),
            child: IconButton(icon: Icon(Icons.close), onPressed: () {
              Navigator.pop(context);
            }),
          ),
        ],
      ),
      body: _contactBody(size),
    );
  }

 Widget _contactBody(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:40),
          child: Text('서비스 이용에 대해', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        ),
        Text('궁금한 점이 있으세요?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

        Padding(
          padding: const EdgeInsets.only(top:10),
          child: Text('어떤 내용이든 괜찮습니다.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:Color(0XFF8a8a8a)),),
        ),
        Text('FITCHOO 인스타그램 DM을 보내주세요.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:Color(0XFF8a8a8a)),),
        Text('빠른 시간 내에 답변을 드리겠습니다.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:Color(0XFF8a8a8a)),),
        
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
          child: Image.asset('assets/color_insta.png', width: 50, height: 50),
        ),
        Text('@fitchoo_style', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),

        Padding(
          padding: EdgeInsets.fromLTRB(size.width*0.05, 20, size.width*0.05 ,5),
          child: Container(
            width: size.width*0.9,
            height: 60,
            child: RaisedButton(
              elevation: 0,
                child:
                Text("FITCHOO 인스타그램 바로가기", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {

                }
            ),
          ),
        )
      ],
    );
 }
  
}
