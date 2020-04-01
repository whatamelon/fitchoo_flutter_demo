import 'package:fitchoo/pages/base/search.dart';
import 'package:fitchoo/pages/base/store.dart';
import 'package:flutter/material.dart';
import 'package:fitchoo/pages/base/home.dart';
import 'package:fitchoo/pages/base/mypage.dart';

class TabPage extends StatefulWidget {

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon : Icon(Icons.home), title: Text('홈')),
      BottomNavigationBarItem(icon : Icon(Icons.search), title: Text('검색')),
      BottomNavigationBarItem(icon : Icon(Icons.inbox), title: Text('보관함')),
      BottomNavigationBarItem(icon : Icon(Icons.account_circle), title: Text('마이')),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
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
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        selectedItemColor: Color(0xffec3e39),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}

