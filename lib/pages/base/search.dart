import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildSearchBody(),
    );
  }

 Widget _buildAppbar() {
    return AppBar(
      title: Text('searchPage'),
    );
 }

 Widget _buildSearchBody() {
    return Container(
      child: Text('서치페이지'),
    );
 }
}
