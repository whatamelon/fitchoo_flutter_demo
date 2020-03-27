import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보 처리방침', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
    );
  }
}
