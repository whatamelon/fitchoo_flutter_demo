import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _url = 'https://google.com';
  final _key = UniqueKey();
  _HomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
              child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: _url))
        ],
      ));
  }

  Widget _buildAppBar() {
    return AppBar (
      title: Image.asset('assets/black_logo.png', width: 120,),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.favorite_border),
            iconSize: 22,
            onPressed: () {}
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 10, 0),
          child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {}
          ),
        ),
      ],
    );
  }
}
