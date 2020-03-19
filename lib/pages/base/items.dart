import 'dart:async';

import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fitchoo/pages/init.dart';


class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    UserState $user = Provider.of<UserState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    $qurate.getQurateList($user.accessToken);
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent - 200) {
//        final $qurate = Provider.of<QurateState>(context);
//        final $user = Provider.of<UserState>(context);
        $qurate.setQOffset($qurate.qOffset + 10);
        $qurate.getQurateList($user.accessToken);
        print('맨밑에 왔');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final $qurate = Provider.of<QurateState>(context);
    List<QitemList> qurations = $qurate.qitemList;
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildHomeBody($qurate, img_url, qurations),
    );
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

  Widget _buildHomeBody($qurate, img_url, qurations) {
    return
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      itemCount: qurations.length,
                      itemBuilder:(BuildContext context, int index) {
                        return Container(
                            constraints: BoxConstraints.tightFor(height: 150.0),
                            child: Image.network(
                              '$img_url${qurations[index].iimgItemFile}',
                              fit: BoxFit.fitWidth,)
                        );
                      }
                  );
  }


  moreQList() {
    final $qurate = Provider.of<QurateState>(context);
    final $user = Provider.of<UserState>(context);
      $qurate.setQOffset($qurate.qOffset + 10);
      $qurate.getQurateList($user.accessToken);
      print('맨밑에 왔');
  }

}
