import 'dart:async';

import 'package:fitchoo/pages/base/search.dart';
import 'package:fitchoo/pages/base/store.dart';
import 'package:flutter/material.dart';
import 'package:fitchoo/pages/base/home.dart';
import 'package:fitchoo/pages/base/mypage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TabPage extends StatefulWidget {

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  bool _finishApp = false;
  int _bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon : Icon(Icons.home), title: Text('홈')),
      BottomNavigationBarItem(icon : Icon(Icons.search), title: Text('검색')),
      BottomNavigationBarItem(icon : Icon(Icons.inbox), title: Text('보관함')),
      BottomNavigationBarItem(icon : Icon(Icons.account_circle), title: Text('마이')),
    ];
  }

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

   Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomePage(),
        SearchPage(),
        StorePage(),
        MyPage(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
     setState(() {
       _bottomSelectedIndex = index;
       _pageController.jumpToPage(index);
     });
//     if(index+1 == _bottomSelectedIndex || index-1 == _bottomSelectedIndex) {
//       print('바로 옆');
//       _bottomSelectedIndex = index;
//       _pageController.animateToPage(index,duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
//     } else {
//       print('떨어져있음');
//       _bottomSelectedIndex = index;
//       _pageController.jumpToPage(index);
//     }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _backControl(),
        child: Scaffold(
          body: _buildPageView(),
          bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomSelectedIndex,
          selectedItemColor: Color(0xffec3e39),
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,

          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
        ),
    );
  }

  Future<bool>  _backControl() {
     print('?');
     if (_pageController.page.round() == _pageController.initialPage) {
       if(!_finishApp) {
         Fluttertoast.showToast(
             msg: "한 번 더 누르면 종료합니다.",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             backgroundColor: Colors.black,
             textColor: Colors.white,
             fontSize: 16.0
         );
         this._finishApp = true;
         Timer(Duration(seconds: 3), () async{
           setState(() {
             this._finishApp = false;
           });
         });
       } else {
         this._finishApp = false;
         SystemNavigator.pop();
       }
     }
  else {
       this._finishApp = false;
       print('이건 그냥 빽');
       _pageController.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
  }
}

