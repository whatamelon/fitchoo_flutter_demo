import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitchoo/pages/depth/quration_id.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path_provider/path_provider.dart';

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
        rqcontId: json["qcontId"],
        rtitle: json["title"],
        rimgLinkTitle: json["imgLinkTitle"],
        rclickCnt: json["clickCnt"],
        ritemCnt: json["itemCnt"],
        ritemupDate: json["itemupDate"],
        rquserId: json["quserId"],
        rquserName: json["quserName"],
        rquserImgLink: json["quserImgLink"]);
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = new ScrollController();
  Map<String, String> newMap = {};

  @override
  void initState() {
    super.initState();
    UserState $user = Provider.of<UserState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    $qurate.getQurateList($user.accessToken, $user.appInfo);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        $qurate.setQOffset($qurate.qOffset + 10);
        $qurate.getQurateList($user.accessToken, $user.appInfo);
      } else {}
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
    final $user = Provider.of<UserState>(context);
    final $item = Provider.of<ItemState>(context);
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildHomeBody($qurate, img_url, $user, $item, size),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Image.asset(
        'assets/black_logo.png',
        width: 120,
      ),
    );
  }

  Widget _buildHomeBody($qurate, img_url, $user, $item, size) {
    return ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  '오늘의 큐레이션',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: $qurate.qnewList.length == 10 ? 10 : $qurate.qnewList.length,
                  itemExtent: 220,
                  itemBuilder: (context, index) {
                    return _buildnewCards(
                        $qurate, img_url, index, $user, $item);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  '큐레이터',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {

                      },
                      child: Image.asset(
                        'assets/qurators/6.png',
                        fit: BoxFit.cover,
                        width: size.width*0.9,
                      ),
                    ),
                    Image.asset(
                      'assets/qurators/7.png',
                      fit: BoxFit.cover,
                      width: size.width*0.9,
                    ),
                    Image.asset(
                      'assets/qurators/8.png',
                      fit: BoxFit.cover,
                      width: size.width*0.9,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  '둘러보기',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: $qurate.qitemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return  _buildItemCard($qurate, img_url, index, size, $user, $item);
                    }),
              )
            ],
          ),
        ]);
  }

  Widget _buildnewCards($qurate, img_url, int index, $user, $item) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Card(
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: () async {
            $qurate.switchHero('n');

            listToMap($qurate, $qurate.qnewList[index]);
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
              bool _isIncluded = false;
              int _includeIndex = 0;
              for(int i = 0; i < recentQList.length; i++) {
                if(_recent2[i].rqcontId == $qurate.qnewList[index].nqcontId) {
                  print(_recent2[i].rqcontId);
                  print($qurate.qnewList[index].nqcontId);
                  print('몇번째냐 $i');
                  _includeIndex = i;
                  _isIncluded = true;
                  break;
                }
              }

              if(!_isIncluded) {
                print('이건 안왔을거고...');
                if(recentQList.length == 10) {
                  recentQList.removeLast();
                }
                recentQList.insert(0, jsonEncode(newMap));
              } else{
                print('이건데...');
                print(recentQList);
                recentQList.removeAt(_includeIndex);
                print(recentQList);
                recentQList.insert(0, jsonEncode(newMap));
              }

              print(recentQList);

              pref.setStringList('recentList', recentQList);
            }

            $qurate.setQItemid($qurate.qnewList[index].nqcontId);
            await $qurate.getQurateInfo($user.accessToken, $qurate.qnewList[index].nqcontId, $user.appInfo);
            await $item.getQItemList($user.accessToken, $user.userHeight, $qurate.qnewList[index].nqcontId, $user.appInfo);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => QurationIdPage()));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CachedNetworkImage(
                fadeInCurve: Curves.fastOutSlowIn,
                fadeInDuration: Duration(seconds: 1),
                fit: BoxFit.cover,
                width:170,
                height:130,
                imageUrl: "$img_url${$qurate.qnewList[index].nimgLinkTitle}",
                placeholder: (context, url) => Container(
                    width: 170,
                    height:130,
                    color:Color(0XFFececec)
                ),
                errorWidget: (context, url, error) => Container(
                    width: 170,
                    height: 130,
                    child: Center(child: Icon(Icons.error))
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
              ),
              Text(
                '${$qurate.qnewList[index].ntitle}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildItemCard($qurate, img_url, index, size, $user, $item) {
    return Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: () async {
            $qurate.switchHero('i');
            listToMap($qurate, $qurate.qitemList[index]);
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
              bool _isIncluded = false;
              int _includeIndex = 0;
              for(int i = 0; i < recentQList.length; i++) {
                if(_recent2[i].rqcontId == $qurate.qitemList[index].iqcontId) {
                  print(_recent2[i].rqcontId);
                  print($qurate.qitemList[index].iqcontId);
                  print('몇번째냐 $i');
                  _includeIndex = i;
                  _isIncluded = true;
                  break;
                }
              }

              if(!_isIncluded) {
                print('이건 안왔을거고...');
                if(recentQList.length == 10) {
                  recentQList.removeLast();
                }
                recentQList.insert(0, jsonEncode(newMap));
              } else{
                print('이건데...');
                print(recentQList);
                recentQList.removeAt(_includeIndex);
                print(recentQList);
                recentQList.insert(0, jsonEncode(newMap));
              }

              print(recentQList);

              pref.setStringList('recentList', recentQList);
            }
          print($qurate.qitemList[index].iqcontId);

            await $qurate.getQurateInfo($user.accessToken, $qurate.qitemList[index].iqcontId, $user.appInfo);
            await $item.getQItemList($user.accessToken, $user.userHeight, $qurate.qitemList[index].iqcontId, $user.appInfo);
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => QurationIdPage()));
            print('홈나갔어?');
          },
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CachedNetworkImage(
                  fadeInCurve: Curves.fastOutSlowIn,
                  fadeInDuration: Duration(seconds: 1),
                  fit: BoxFit.cover,
                  width:300,
                  height:225,
                  imageUrl: "$img_url${$qurate.qitemList[index].iimgLinkTitle}",
                  placeholder: (context, url) => Container(
                      width: 300,
                      height:225,
                      color:Color(0XFFececec)
                  ),
                  errorWidget: (context, url, error) => Container(
                      width: 300,
                      height: 225,
                      child: Center(child: Icon(Icons.error))
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 18, 12, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: ClipOval(
                                  child: Image.network(
                                    '$img_url${$qurate.qitemList[index].iquserImgLink}',
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    width:size.width*0.7,
                                    child: Text(
                                        $qurate.qitemList[index].ititle,
                                        textAlign: TextAlign.justify,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:3),
                                    child: Container(
                                      width:size.width*0.7,
                                      child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          verticalDirection: VerticalDirection.down,
                                          spacing: 4,
                                          runSpacing: 2,
                                          children: <Widget>[
                                            Text('${$qurate.qitemList[index].iquserName} ', style: TextStyle(color:Color(0XFF777777), fontSize: 14),),
                                            Text(' ${String.fromCharCode(0x2022)} '),
                                            Text(' 조회수 ${_modiCnt($qurate.qitemList[index].iclickCnt)} ', style: TextStyle(color:Color(0XFF777777), fontSize: 14),),
                                            Text(' ${String.fromCharCode(0x2022)} '),
                                            Text(' 상품수 ${$qurate.qitemList[index].iitemCnt}개', style: TextStyle(color:Color(0XFF777777), fontSize: 14),),
                                          ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _modiCnt(i) {
    int _index = 0;
    if (i.length == 6) {
      _index = 3;
      i = i.substring(0, 6);
    } else if (i.length == 5) {
      _index = 2;
      i = i.substring(0, 5);
    } else if (i.length == 4) {
      _index = 1;
      i = i.substring(0, 4);
    } else {
      return i;
    }
    return i.substring(0, _index) + "," + i.substring(_index);
  }

  String timeModi(t) {
    var test = Jiffy(t).fromNow();
    if(test.contains('day')) {
      if(test.contains('days')) {
        return '${test.substring(0,2)}일전';
      } else {
        return '1 일전';
      }
    } else if(test.contains('hour')) {
      if(test.contains('hours')) {
        return '${test.substring(0,2)}시간전';
      } else {
        return '1 시간전';
      }
    } else if(test.contains('minute')) {
      if(test.contains('minutes')) {
        return '${test.substring(0,2)}분전';
      } else {
        return '1 분전';
      }
    }
    return test;
  }

  void listToMap($qurate, x) {
    if ($qurate.qSwitchHero == 'i') {
      newMap['rqcontId'] = x.iqcontId;
      newMap['rtitle'] = x.ititle;
      newMap['rimgLinkTitle'] = x.iimgLinkTitle;
      newMap['rclickCnt'] = x.iclickCnt;
      newMap['ritemCnt'] = x.iitemCnt;
      newMap['ritemupDate'] = x.iitemupDate;
      newMap['rquserId'] = x.iquserId;
      newMap['rquserName'] = x.iquserName;
      newMap['rquserImgLink'] = x.iquserImgLink;
    } else if ($qurate.qSwitchHero == 'n') {
      newMap['rqcontId'] = x.nqcontId;
      newMap['rtitle'] = x.ntitle;
      newMap['rimgLinkTitle'] = x.nimgLinkTitle;
      newMap['rclickCnt'] = x.nclickCnt;
      newMap['ritemCnt'] = x.nitemCnt;
      newMap['ritemupDate'] = x.nitemupDate;
      newMap['rquserId'] = x.nquserId;
      newMap['rquserName'] = x.nquserName;
      newMap['rquserImgLink'] = x.nquserImgLink;
    } else {
      newMap['rqcontId'] = x['rqcontId'];
      newMap['rtitle'] = x['rtitle'];
      newMap['rimgLinkTitle'] = x['rimgLinkTitle'];
      newMap['rclickCnt'] = x['rclickCnt'];
      newMap['ritemCnt'] = x['ritemCnt'];
      newMap['ritemupDate'] = x['ritemupDate'];
      newMap['rquserId'] = x['rquserId'];
      newMap['rquserName'] = x['rquserName'];
      newMap['rquserImgLink'] = x['rquserImgLink'];
    }
  }

}
