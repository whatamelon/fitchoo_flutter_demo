import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webViewPage extends StatefulWidget {
  final String url;

  webViewPage({Key key, this.url}) : super(key: key);
  @override
  _webViewPageState createState() => _webViewPageState();
}

class _webViewPageState extends State<webViewPage> {
  WebViewController _webViewController;

  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            left:true,
            top:true,
            right:true,
            bottom: true,
            minimum: const EdgeInsets.only(top:10),
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
                                      key: _key,
                                      initialUrl: widget.url,
//                                      javascriptChannels: Set.from([
//                                        JavascriptChannel(
//                                            name: 'setHeight',
//                                            onMessageReceived: (JavascriptMessage result) {
//                                              print(result.message);
//                                              UserState $user = Provider.of<UserState>(context, listen: false);
//                                              $user.setUserHeight(result.message);
//                                            })
//                                      ]),
                                      onWebViewCreated: (WebViewController webViewController) async{
                                        print("start  :   ${widget.url}");
                                        _webViewController = webViewController;
                                      },
                                      onPageFinished:(String url) async{
                                        print("finish   :  ${widget.url}");
//                                        UserState $user = Provider.of<UserState>(context, listen: false);
//                                        final res1 =  _webViewController.loadUrl('javascript:callbackAppType(\'android3\')');
//                                        final res2 =  _webViewController.loadUrl('javascript:callbackAuthToken(\'${$user.accessToken}\')');
//                                        final res3 =  _webViewController.loadUrl('javascript:callbackHeight(\'${$user.userHeight}\')');
//                                        print('Result for webView network finish1    :    $res1');
//                                        print('Result for webView network finish2    :    $res2');
//                                        print('Result for webView network finish3    :    $res3');
                                      },
                                    ),
          ),
        ),
    );
  }
}
