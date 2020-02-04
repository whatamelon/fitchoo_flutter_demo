import 'package:flutter/material.dart';
import 'package:fitchoo/pages/base/home.dart';
import 'package:fitchoo/pages/base/items.dart';
import 'package:fitchoo/pages/base/mypage.dart';
import 'package:fitchoo/pages/base/models.dart';

class TabPage extends StatefulWidget {

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon : Icon(Icons.home), title: Text('홈')),
      BottomNavigationBarItem(icon : Icon(Icons.dashboard), title: Text('상품보기')),
      BottomNavigationBarItem(icon : Icon(Icons.format_align_left), title: Text('모델찾기')),
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
        ItemsPage(),
        ModelsPage(),
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

