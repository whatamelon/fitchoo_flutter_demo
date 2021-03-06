import 'dart:convert';
import 'package:fitchoo/pages/depth/mark_qu.dart';
import 'package:fitchoo/pages/depth/quration_id.dart';
import 'package:fitchoo/pages/depth/recentItem.dart';
import 'package:fitchoo/pages/depth/recent_qu.dart';
import 'package:fitchoo/pages/depth/save_item.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class QrecentList {
  String rqcontId = '';
  String rtitle = '';
  String rimgLinkTitle = '';
  String rclickCnt = '';
  String ritemCnt = '';
  String ritemupDate = '';
  String rquserId = '';
  String rquserName = '';
  String rquserImgLink = '';

  QrecentList({
    this.rqcontId,
    this.rtitle,
    this.rimgLinkTitle,
    this.rclickCnt,
    this.ritemCnt,
    this.ritemupDate,
    this.rquserId,
    this.rquserName,
    this.rquserImgLink,
  });

  factory QrecentList.fromJson(Map<String, dynamic> json) {
    return QrecentList(
        rqcontId: json["rqcontId"],
        rtitle: json["rtitle"],
        rimgLinkTitle: json["rimgLinkTitle"],
        rclickCnt: json["rclickCnt"],
        ritemCnt: json["ritemCnt"],
        ritemupDate: json["ritemupDate"],
        rquserId: json["rquserId"],
        rquserName: json["rquserName"],
        rquserImgLink: json["rquserImgLink"]);
  }
}

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Map<String, String> newMap = {};
  List<QrecentList> _recent2;
  List _timeList = [];

  @override
  void initState() {
    print('스토어어어');
    _recent2 = [];
    _openbox();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<QrecentList>> _openbox() async{
    final prefs = await SharedPreferences.getInstance();
    var les = prefs.getStringList('recentList');

    for(var i = 0; i<les.length; i++) {
      print(jsonDecode(les[i]));
      _timeList.add(jsonDecode(les[i]));
    }
    print('timeList____$_timeList');
    setState(() {
      _recent2 = _timeList.map<QrecentList>((json) => QrecentList.fromJson(json)).toList();
    });
    print(_recent2);
  }

  @override
  Widget build(BuildContext context) {
    UserState $user = Provider.of<UserState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('보관함', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _recent2.length == 0 ?
          Container():
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text('최근 본 큐레이션'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return RecentQuPage(recentList: this._recent2);
                      }));
                },
              ),Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _recent2.length == 10 ? 10 : _recent2.length,
                  itemExtent: 220,
                  itemBuilder: (context, index) {
                    return _buildRecentCards($qurate, img_url, index, $user, $item);
                  },
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('즐겨찾기한 큐레이션'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MarkQurationPage();
                  }));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('찜한 상품'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SaveItemPage();
                  }));
            },
          ),
          ListTile(
            leading: Icon(Icons.remove_red_eye),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('최근 본 상품'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return RecentItemPage();
                  }));
            },
          ),
        ],
      ),
    );
  }


  Widget _buildRecentCards($qurate, img_url, int index, $user, $item) {
    return InkWell(
          splashColor: Colors.white,
          onTap: () async{
            $qurate.switchHero('r');

            listToMap($qurate, _recent2[index]);
            final pref = await SharedPreferences.getInstance();
            var recentQList =  pref.getStringList('recentList');
            print('리센트리스트 보러갑니다앙____$recentQList');

            if(recentQList == null) {
              print('list가 읍어요');
              pref.setStringList('recentList', []);
              recentQList.insert(0, jsonEncode(newMap));
              pref.setStringList('recentList', recentQList);

            } else {

              List<QrecentList> _recent2 = [];
              List _timeList = [];

              for(var i = 0; i<recentQList.length; i++) {
                print(jsonDecode(recentQList[i]));
                _timeList.add(jsonDecode(recentQList[i]));
              }
              print('timeList____$_timeList');

              _recent2 = _timeList.map<QrecentList>((json) => QrecentList.fromJson(json)).toList();
              print(_recent2);

              print('list가 있지요');
              int _includeIndex = 0;
              for(int i = 0; i < recentQList.length; i++) {
                if(_recent2[i].rqcontId == _recent2[index].rqcontId) {
                  print(_recent2[i].rqcontId);
                  print(_recent2[index].rqcontId);
                  print('몇번째냐 $i');
                  _includeIndex = i;
                  break;
                }
              }

              recentQList.removeAt(_includeIndex);
              print(recentQList);
              recentQList.insert(0, jsonEncode(newMap));
              print(recentQList);

              pref.setStringList('recentList', recentQList);
            }
            print($qurate.qitemList[index].iqcontId);

            await $qurate.getQurateInfo($user.accessToken, _recent2[index].rqcontId, $user.appInfo);
            await $item.getQItemList($user.accessToken, $user.userHeight, _recent2[index].rqcontId, $user.appInfo);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => QurationIdPage()));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FadeInImage.memoryNetwork(
                          fit: BoxFit.cover,
                          width: 170,
                          height: 130,
                          placeholder: kTransparentImage,
                          image:
                          '$img_url${_recent2[index].rimgLinkTitle}')),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    '${_recent2[index].rtitle}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              elevation: 0,
            ),
          ),
      );
  }

  void listToMap($qurate, x) {
    newMap['rqcontId'] = x.rqcontId;
    newMap['rtitle'] = x.rtitle;
    newMap['rimgLinkTitle'] = x.rimgLinkTitle;
    newMap['rclickCnt'] = x.rclickCnt;
    newMap['ritemCnt'] = x.ritemCnt;
    newMap['ritemupDate'] = x.ritemupDate;
    newMap['rquserId'] = x.rquserId;
    newMap['rquserName'] = x.rquserName;
    newMap['rquserImgLink'] = x.rquserImgLink;
  }
}
