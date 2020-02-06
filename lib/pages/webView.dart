import 'dart:async';

import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class webViewPage extends StatefulWidget {
  @override
  _webViewPageState createState() => _webViewPageState();
}

class _webViewPageState extends State<webViewPage> {
  WebViewController _controller;

  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    initialUrl: 'https://devfront.fitchoo.kr/home/',
                    javascriptChannels: Set.from([
                      JavascriptChannel(
                          name: 'setHeight',
                          onMessageReceived: (JavascriptMessage result) {
                            print(result.message);
                            UserState $user = Provider.of<UserState>(context, listen: false);
                            $user.setUserHeight(result.message);
                          })
                    ]),
                    onWebViewCreated: (WebViewController controller) {
                      _controller = controller;
                      _onShowUserAgent(controller, context);
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                )
            )
          ],
        ));
  }

  void _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    UserState $user = Provider.of<UserState>(context, listen: false);
    controller.evaluateJavascript(
        'callbackAuthToken.postMessage(${$user.accessToken})');
  }
}
