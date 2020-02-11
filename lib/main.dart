import 'package:fitchoo/pages/init.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final userState = UserState();

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFffffff);
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (context) => userState),
        ],
      child : MaterialApp(
      theme: ThemeData(
        primaryColor: PrimaryColor,
      ),
      home: InitPage(),
    ));
  }
}
