import 'package:flutter/material.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이용약관', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
