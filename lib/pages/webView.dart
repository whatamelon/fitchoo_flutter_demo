import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webViewPage extends StatefulWidget {
  final List viewData;

  webViewPage({Key key, this.viewData}) : super(key: key);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
//        centerTitle: true,
//        title: Text(widget.viewData[0], style: TextStyle(fontSize: 24,),),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(Icons.close, size: 30,)
              ),
            ),
          ),
        ],
      ),
        body:Align(
          alignment: Alignment.center,
          child: SafeArea(
            left:true,
            top:true,
            right:true,
            bottom: true,
//            minimum: const EdgeInsets.only(top:10),
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
                                      key: _key,
                                      initialUrl: widget.viewData[1],
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
                                        print("start  :   ${widget.viewData[1]}");
                                        _webViewController = webViewController;
                                      },
                                      onPageFinished:(String url) async{
                                        print("finish   :  ${widget.viewData[1]}");
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
