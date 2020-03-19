import 'package:fitchoo/pages/init.dart';
import 'package:fitchoo/pages/base/home.dart';
import 'package:fitchoo/pages/initial/splash.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final userState = UserState();
  final qurateState = QurateState();
  final itemState = ItemState();

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFffffff);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => userState),
          ChangeNotifierProvider(create: (context) => qurateState),
          ChangeNotifierProvider(create: (context) => itemState)
        ],
      child : MaterialApp(
      theme: ThemeData(
        primaryColor: PrimaryColor,
      ),
      home: SplashPage(),
    ));
  }
}
