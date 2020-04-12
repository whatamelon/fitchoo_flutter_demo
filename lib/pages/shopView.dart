import 'package:fitchoo/states/item_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShopViewPage extends StatefulWidget {
  final List viewData;

  ShopViewPage({Key key, this.viewData}) : super(key: key);
  @override
  _ShopViewPageState createState() => _ShopViewPageState();
}

class _ShopViewPageState extends State<ShopViewPage> {
  int _bottomSelectedIndex = 2;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon : Icon(Icons.close), title: Padding(padding: EdgeInsets.all(0))),
      BottomNavigationBarItem(icon : Icon(Icons.arrow_back_ios), title: Padding(padding: EdgeInsets.all(0))),
      BottomNavigationBarItem(icon : Icon(Icons.arrow_forward_ios), title: Padding(padding: EdgeInsets.all(0))),
      BottomNavigationBarItem(
        icon : widget.viewData[2] == 't' ?
          Icon(Icons.favorite, color: Colors.red,):
          Icon(Icons.favorite_border, color: Colors.red,),
       title: Padding(padding: EdgeInsets.all(0))),
    ];
  }

  WebViewController _ShopViewController;
  final _shopKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    UserState $user = Provider.of<UserState>(context);
    ItemState $item = Provider.of<ItemState>(context);
    return Scaffold(
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
            key: _shopKey,
            initialUrl: widget.viewData[0],
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
              print("start  :   ${widget.viewData[0]}");
              _ShopViewController = webViewController;
            },
            onPageFinished:(String url) async{
              print("finish   :  ${widget.viewData[0]}");
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
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _bottomSelectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        bottomTapped(index, $user, $item);
      },
      items: buildBottomNavBarItems(),
    ),
    );
  }

  void bottomTapped(int index, $user, $item) async{
    switch(index) {
      case 0 :
        Navigator.pop(context);
      break;
      case 1 :
        if(await _ShopViewController.canGoBack()) {
          await _ShopViewController.goBack();
          return;
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('더 이상 뒤로 갈 수 없습니다.')),);
          return;
        }
      break;
      case 2 :
        if(await _ShopViewController.canGoBack()) {
          await _ShopViewController.goBack();
          return;
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('더 이상 앞으로 갈 수 없습니다.')),);
          return;
        }
      break;
      case 3:
        setState(() {
          if(widget.viewData[2] == 't') {
            $item.removeSavedProduct($user.accessToken, widget.viewData[1], $user.appInfo);
            widget.viewData[2] = 'f';
          } else {
            $item.addSavedProduct($user.accessToken, widget.viewData[1], $user.appInfo);
            widget.viewData[2] = 't';
          }
        });
      break;
    }
  }
}
