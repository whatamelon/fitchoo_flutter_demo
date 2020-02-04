import 'package:flutter/material.dart';

class ModelsPage extends StatefulWidget {
  @override
  _ModelsPageState createState() => _ModelsPageState();
}

class _ModelsPageState extends State<ModelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("모델리스트페이지입니다.", style: TextStyle(color: Colors.blue),)),
    );
  }

  Widget _buildAppBar() {
    return AppBar (
      title: Image.asset('assets/black_logo.png'),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.favorite_border),
            onPressed: () {}
            ),
        new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {}
        ),
      ],
    );
  }
}
