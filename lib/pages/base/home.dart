import 'dart:async';
import 'dart:convert';

import 'package:fitchoo/pages/depth/quration_id.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

//class Newmap {
//  String rqitemId;
//  String rqcode;
//  String rclickCnt;
//  String rquserName;
//  String rimgFaceFile;
//  String rimgItemFile;
//  String ritemupDate;
//  String rtitle;
//  String rbody;
//
//  Newmap({this.rqitemId, this.rqcode,
//    this.rclickCnt, this.rquserName,
//    this.rimgFaceFile, this.rimgItemFile,
//    this.ritemupDate, this.rtitle, this.rbody});
//}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = new ScrollController();
  Map<String, String> newMap = {};
  List _recentList = [];

  @override
  void initState() {
    super.initState();
    _openBox();
    UserState $user = Provider.of<UserState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    $qurate.getQurateList($user.accessToken);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        $qurate.setQOffset($qurate.qOffset + 10);
        $qurate.getQurateList($user.accessToken);
      } else {}
    });
  }

  Future _openBox() async{
    final prefs = await SharedPreferences.getInstance();

    _recentList = prefs.getStringList('recentList');
    return _recentList;
  }

  @override
  void dispose() {
    Hive.close();
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
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.favorite_border), iconSize: 22, onPressed: () {}),
      ],
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
                  '새로운 큐레이션',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemExtent: 220,
                  itemBuilder: (context, index) {
                    return _buildnewCards(
                        $qurate, img_url, index, $user, $item);
                  },
                ),
              ),
              Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: $qurate.qitemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Hero(
                        tag: 'i${$qurate.qitemList[index].iimgItemFile}',
                        child: new Material(
                          color: Colors.transparent,
                          child: new InkWell(
                              splashColor: Colors.white,
                              onTap: () async {
                                $qurate.switchHero('i');

//                                listToMap($qurate, $qurate.qitemList[index]);
//                                final pref = await SharedPreferences.getInstance();
//                                var recentList =  pref.getStringList('recentList');
//                                if(recentList == null) {
//                                  pref.setStringList('recentList', []);
//                                }
//
//                                bool _isIncluded = false;
//                                for(var i in recentList) {
//                                  if(i.contains($qurate.qitemList[index].iqitemId)) {
//                                    _isIncluded = true;
//                                    break;
//                                  }
//                                }
//
//                                if(!_isIncluded) {
//                                  if(recentList.length == 10) {
//                                    recentList.removeLast();
//                                  }
//                                  else {
//                                    recentList.removeWhere((newMap) => newMap[0] == $qurate.qitemList[index].iqitemId);
//                                  }
//                                  recentList.insert(0, jsonEncode(newMap));
//                                }

                                $qurate.setQItemid($qurate.qitemList[index].iqitemId);
                                $qurate.setImgItemFile($qurate.qitemList[index].iimgItemFile);
                                $qurate.setImgFaceFile($qurate.qitemList[index].iimgFaceFile);
                                $qurate.setQUsername($qurate.qitemList[index].iquserName);
                                $qurate.setQTitle($qurate.qitemList[index].ititle);
                                $qurate.setQBody($qurate.qitemList[index].ibody);
                                $qurate.setUpdatetiem($qurate.qitemList[index].iitemupDate);
                                await $qurate.getQurateInfo($user.accessToken);
                                $item.setQid($qurate.qitemList[index].iqitemId);
                                await $item.getItemList($user.accessToken, $user.userHeight);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => QurationIdPage()));
                                print('홈나갔어?');
                              },
                              child: _buildItemCard($qurate, img_url, index, size)),
                        ),
                      );
                    }),
              )
            ],
          ),
        ]);
  }

  Widget _buildnewCards($qurate, img_url, int index, $user, $item) {
    return Hero(
      tag: 'n${$qurate.qnewList[index].nimgItemFile}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () async{
            $qurate.switchHero('n');

//            listToMap($qurate, $qurate.qnewList[index]);
//            var qbox = await Hive.openBox('qurateInfo');
//            if(qbox.get('recentList') == null) {
//              qbox.put('recentList', []);
//            }
//            var getBox = qbox.get('recentList');
//            getBox.insert(0, newMap);
//            print('qinfo in Hive: ${qbox.get('recentList')}');
//            await qbox.close();

            $qurate.setQItemid($qurate.qnewList[index].nqitemId);
            $qurate.setImgItemFile($qurate.qnewList[index].nimgItemFile);
            $qurate.setImgFaceFile($qurate.qnewList[index].nimgFaceFile);
            $qurate.setQUsername($qurate.qnewList[index].nquserName);
            $qurate.setQTitle($qurate.qnewList[index].ntitle);
            $qurate.setQBody($qurate.qnewList[index].nbody);
            $qurate.setUpdatetiem($qurate.qnewList[index].nitemupDate);
            await $qurate.getQurateInfo($user.accessToken);
            $item.setQid($qurate.qnewList[index].nqitemId);
            await $item.getItemList($user.accessToken, $user.userHeight);
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
                              '$img_url${$qurate.qnewList[index].nimgItemFile}')),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    '${$qurate.qnewList[index].ntitle}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard($qurate, img_url, index, size) {
    return Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FadeInImage.memoryNetwork(
                fit: BoxFit.fitWidth,
                width: 300,
                height: 225,
                placeholder: kTransparentImage,
                image: '$img_url${$qurate.qitemList[index].iimgItemFile}'),
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
                                  '$img_url${$qurate.qitemList[index].iimgFaceFile}',
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
                                          Text(' 상품수 234개', style: TextStyle(color:Color(0XFF777777), fontSize: 14),),
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

//  void listToMap($qurate, x) {
//    if ($qurate.qSwitchHero == 'i') {
//      newMap['rqitemId'] = x.iqitemId;
//      newMap['rqcode'] = x.iqcode;
//      newMap['rclickCnt'] = x.iclickCnt;
//      newMap['rquserName'] = x.iquserName;
//      newMap['rimgFaceFile'] = x.iimgFaceFile;
//      newMap['rimgItemFile'] = x.iimgItemFile;
//      newMap['ritemupDate'] = x.iitemupDate;
//      newMap['rtitle'] = x.ititle;
//      newMap['rbody'] = x.ibody;
//    } else if ($qurate.qSwitchHero == 'p') {
//      newMap['rqitemId'] = x.pqitemId;
//      newMap['rqcode'] = x.pqcode;
//      newMap['rclickCnt'] = x.pclickCnt;
//      newMap['rquserName'] = x.pquserName;
//      newMap['rimgFaceFile'] = x.pimgFaceFile;
//      newMap['rimgItemFile'] = x.pimgItemFile;
//      newMap['ritemupDate'] = x.pitemupDate;
//      newMap['rtitle'] = x.ptitle;
//      newMap['rbody'] = x.pbody;
//    } else if ($qurate.qSwitchHero == 'n') {
//      newMap['rqitemId'] = x.nqitemId;
//      newMap['rqcode'] = x.nqcode;
//      newMap['rclickCnt'] = x.nclickCnt;
//      newMap['rquserName'] = x.nquserName;
//      newMap['rimgFaceFile'] = x.nimgFaceFile;
//      newMap['rimgItemFile'] = x.nimgItemFile;
//      newMap['ritemupDate'] = x.nitemupDate;
//      newMap['rtitle'] = x.ntitle;
//      newMap['rbody'] = x.nbody;
//    } else {
//      newMap['rqitemId'] = x['rqitemId'];
//      newMap['rqcode'] = x['rqcode'];
//      newMap['rclickCnt'] = x['rclickCnt'];
//      newMap['rquserName'] = x['rquserName'];
//      newMap['rimgFaceFile'] = x['rimgFaceFile'];
//      newMap['rimgItemFile'] = x['rimgItemFile'];
//      newMap['ritemupDate'] = x['ritemupDate'];
//      newMap['rtitle'] = x['rtitle'];
//      newMap['rbody'] = x['rbody'];
//    }
//  }

//  Widget _buildRecentCards($qurate, img_url, int index, $user, $item, box) {
//    return Hero(
//      tag:'r${box[index]['rimgItemFile']}',
//      child: Material(
//          color: Colors.transparent,
//          child: InkWell(
//            splashColor: Colors.white,
//            onTap: () async{
//              $qurate.switchHero('r');
//
//              print(box[index]);
//              listToMap($qurate, box[index]);
//              var qbox = await Hive.openBox('qurateInfo');
//              var getBox = qbox.get('recentList');
//              getBox.insert(0, newMap);
//              print('qinfo in Hive: ${qbox.get('recentList')}');
//              await qbox.close();
//
//              $qurate.setQItemid(box[index]['rqitemId']);
//              $qurate.setImgItemFile(box[index]['rimgItemFile']);
//              $qurate.setImgFaceFile(box[index]['rimgFaceFile']);
//              $qurate.setQUsername(box[index]['rquserName']);
//              $qurate.setQTitle(box[index]['rtitle']);
//              $qurate.setQBody(box[index]['rbody']);
//              await $qurate.getQurateInfo($user.accessToken);
//              $item.setQid(box[index]['rqitemId']);
//              await $item.getItemList($user.accessToken, $user.userHeight);
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => QurationIdPage()));
//            },
//            child: Container(
//              margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
//              child: Card(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    ClipRRect(
//                        borderRadius: BorderRadius.circular(8),
//                        child: FadeInImage.memoryNetwork(
//                            fit: BoxFit.cover,
//                            width: 170,
//                            height: 130,
//                            placeholder: kTransparentImage,
//                            image:
//                            '$img_url${box[index]['rimgItemFile']}')),
//                    Padding(
//                      padding: EdgeInsets.only(top: 8),
//                    ),
//                    Text(
//                      '${box[index]['rtitle']}',
//                      style: TextStyle(fontSize: 12),
//                    ),
//                  ],
//                ),
//                elevation: 0,
//              ),
//            ),
//          ),
//        ),
//    );
//  }
}
