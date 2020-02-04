import 'package:flutter/material.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("아이템리스트페이지입니다.", style: TextStyle(color: Colors.blue),)),
    );
  }
}
