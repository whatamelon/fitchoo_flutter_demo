import 'dart:async';
import 'dart:convert';

import 'package:fitchoo/pages/depth/quration_id.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildHomeBody($qurate, img_url, $user, $item),
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

  Widget _buildHomeBody($qurate, img_url, $user, $item) {
    return ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
//              _recentList.length == 0 ?
//              Padding(
//                padding: EdgeInsets.only(top:1),
//              ) :
//               Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
//                      child: Text(
//                        '최근 본 큐레이션',
//                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.symmetric(vertical: 5),
//                      height: 200.0,
//                      child: ListView.builder(
//                        scrollDirection: Axis.horizontal,
//                        itemCount: _recentList.length,
//                        itemExtent: 220,
//                        itemBuilder: (context, index) {
//                          return _buildRecentCards($qurate, img_url, index, $user, $item, _recentList);
//                        },
//                      ),
//                    ),
//                  ],
//                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  '인기 큐레이션',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemExtent: 220,
                  itemBuilder: (context, index) {
                    return _buildPopCards(
                        $qurate, img_url, index, $user, $item);
                  },
                ),
              ),
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

                                listToMap($qurate, $qurate.qitemList[index]);
                                final pref = await SharedPreferences.getInstance();
                                var recentList =  pref.getStringList('recentList');
                                if(recentList == null) {
                                  pref.setStringList('recentList', []);
                                }

//                                String rawJson = jsonEncode(newMap);
//                                Map<String, String> rawMap = jsonDecode(recentList);
//                                List short = recentList.where((i) => i['rqitemId'] == $qurate.qitemList[index].iqitemId).toList();
//                                var newRecentList = json.decode(recentList) as Map;
//                                Map<String, String> result = Map.from
//                                Map<int, Newmap> result = {};
//                                for(Newmap news in )

//                                Map toMap() => {
//                                 'rqitemId': $qurate.qitemList[index].iqitemId,
//                                 'rquserName': $qurate.qitemList[index].iquserName,
//                                 'rimgFaceFile': $qurate.qitemList[index].iimgFaceFile,
//                                 'rimgItemFile': $qurate.qitemList[index].iimgItemFile,
//                                 'ritemupDate': $qurate.qitemList[index].iitemupDate,
//                                 'rtitle': $qurate.qitemList[index].ititle,
//                                 'rbody': $qurate.qitemList[index].ibody
//                                };
//                                String json = jsonEncode(toMap());

                                bool _isIncluded = false;
                                for(var i in recentList) {
                                  if(i.contains($qurate.qitemList[index].iqitemId)) {
                                    _isIncluded = true;
                                    break;
                                  }
                                }

                                if(!_isIncluded) {
                                  if(recentList.length == 10) {
                                    recentList.removeLast();
                                  }
                                  else {
                                    recentList.removeWhere((newMap) => newMap[0] == $qurate.qitemList[index].iqitemId);
                                  }
                                  recentList.insert(0, jsonEncode(newMap));
                                }

                                $qurate.setQItemid($qurate.qitemList[index].iqitemId);
                                $qurate.setImgItemFile($qurate.qitemList[index].iimgItemFile);
                                $qurate.setImgFaceFile($qurate.qitemList[index].iimgFaceFile);
                                $qurate.setQUsername($qurate.qitemList[index].iquserName);
                                $qurate.setQTitle($qurate.qitemList[index].ititle);
                                $qurate.setQBody($qurate.qitemList[index].ibody);
                                await $qurate.getQurateInfo($user.accessToken);
                                $item.setQid($qurate.qitemList[index].iqitemId);
                                await $item.getItemList($user.accessToken, $user.userHeight);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => QurationIdPage()));
                                print('홈나갔어?');
                              },
                              child: _buildItemCard($qurate, img_url, index)),
                        ),
                      );
                    }),
              )
            ],
          ),
        ]);
  }

  Widget _buildPopCards($qurate, img_url, index, $user, $item) {
    return Hero(
      tag: 'p${$qurate.qpopList[index].pimgItemFile}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () async {
            $qurate.switchHero('p');

            listToMap($qurate, $qurate.qpopList[index]);
            var qbox = await Hive.openBox('qurateInfo');
            if(qbox.get('recentList') == null) {
              qbox.put('recentList', []);
            }
            var getBox = qbox.get('recentList');
            getBox.insert(0, newMap);
            print('qinfo in Hive: ${qbox.get('recentList')}');
            await qbox.close();

            $qurate.setQItemid($qurate.qpopList[index].pqitemId);
            $qurate.setImgItemFile($qurate.qpopList[index].pimgItemFile);
            $qurate.setImgFaceFile($qurate.qpopList[index].pimgFaceFile);
            $qurate.setQUsername($qurate.qpopList[index].pquserName);
            $qurate.setQTitle($qurate.qpopList[index].ptitle);
            $qurate.setQBody($qurate.qpopList[index].pbody);
            await $qurate.getQurateInfo($user.accessToken);
            $item.setQid($qurate.qpopList[index].pqitemId);
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
                              '$img_url${$qurate.qpopList[index].pimgItemFile}')),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    '${$qurate.qpopList[index].ptitle}',
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

  Widget _buildnewCards($qurate, img_url, int index, $user, $item) {
    return Hero(
      tag: 'n${$qurate.qnewList[index].nimgItemFile}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () async{
            $qurate.switchHero('n');

            listToMap($qurate, $qurate.qnewList[index]);
            var qbox = await Hive.openBox('qurateInfo');
            if(qbox.get('recentList') == null) {
              qbox.put('recentList', []);
            }
            var getBox = qbox.get('recentList');
            getBox.insert(0, newMap);
            print('qinfo in Hive: ${qbox.get('recentList')}');
            await qbox.close();

            $qurate.setQItemid($qurate.qnewList[index].nqitemId);
            $qurate.setImgItemFile($qurate.qnewList[index].nimgItemFile);
            $qurate.setImgFaceFile($qurate.qnewList[index].nimgFaceFile);
            $qurate.setQUsername($qurate.qnewList[index].nquserName);
            $qurate.setQTitle($qurate.qnewList[index].ntitle);
            $qurate.setQBody($qurate.qnewList[index].nbody);
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

  Widget _buildItemCard($qurate, img_url, index) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
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
                              children: <Widget>[
                                Text(
                                  'Curated by',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  $qurate.qitemList[index].iquserName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '상품업데이트 4시간전',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black26),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    $qurate.qitemList[index].ititle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    $qurate.qitemList[index].ibody,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void listToMap($qurate, x) {
    if ($qurate.qSwitchHero == 'i') {
      newMap['rqitemId'] = x.iqitemId;
      newMap['rqcode'] = x.iqcode;
      newMap['rclickCnt'] = x.iclickCnt;
      newMap['rquserName'] = x.iquserName;
      newMap['rimgFaceFile'] = x.iimgFaceFile;
      newMap['rimgItemFile'] = x.iimgItemFile;
      newMap['ritemupDate'] = x.iitemupDate;
      newMap['rtitle'] = x.ititle;
      newMap['rbody'] = x.ibody;
    } else if ($qurate.qSwitchHero == 'p') {
      newMap['rqitemId'] = x.pqitemId;
      newMap['rqcode'] = x.pqcode;
      newMap['rclickCnt'] = x.pclickCnt;
      newMap['rquserName'] = x.pquserName;
      newMap['rimgFaceFile'] = x.pimgFaceFile;
      newMap['rimgItemFile'] = x.pimgItemFile;
      newMap['ritemupDate'] = x.pitemupDate;
      newMap['rtitle'] = x.ptitle;
      newMap['rbody'] = x.pbody;
    } else if ($qurate.qSwitchHero == 'n') {
      newMap['rqitemId'] = x.nqitemId;
      newMap['rqcode'] = x.nqcode;
      newMap['rclickCnt'] = x.nclickCnt;
      newMap['rquserName'] = x.nquserName;
      newMap['rimgFaceFile'] = x.nimgFaceFile;
      newMap['rimgItemFile'] = x.nimgItemFile;
      newMap['ritemupDate'] = x.nitemupDate;
      newMap['rtitle'] = x.ntitle;
      newMap['rbody'] = x.nbody;
    } else {
      newMap['rqitemId'] = x['rqitemId'];
      newMap['rqcode'] = x['rqcode'];
      newMap['rclickCnt'] = x['rclickCnt'];
      newMap['rquserName'] = x['rquserName'];
      newMap['rimgFaceFile'] = x['rimgFaceFile'];
      newMap['rimgItemFile'] = x['rimgItemFile'];
      newMap['ritemupDate'] = x['ritemupDate'];
      newMap['rtitle'] = x['rtitle'];
      newMap['rbody'] = x['rbody'];
    }
  }

  Widget _buildRecentCards($qurate, img_url, int index, $user, $item, box) {
    return Hero(
      tag:'r${box[index]['rimgItemFile']}',
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white,
            onTap: () async{
              $qurate.switchHero('r');

              print(box[index]);
              listToMap($qurate, box[index]);
              var qbox = await Hive.openBox('qurateInfo');
              var getBox = qbox.get('recentList');
              getBox.insert(0, newMap);
              print('qinfo in Hive: ${qbox.get('recentList')}');
              await qbox.close();

              $qurate.setQItemid(box[index]['rqitemId']);
              $qurate.setImgItemFile(box[index]['rimgItemFile']);
              $qurate.setImgFaceFile(box[index]['rimgFaceFile']);
              $qurate.setQUsername(box[index]['rquserName']);
              $qurate.setQTitle(box[index]['rtitle']);
              $qurate.setQBody(box[index]['rbody']);
              await $qurate.getQurateInfo($user.accessToken);
              $item.setQid(box[index]['rqitemId']);
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
                            '$img_url${box[index]['rimgItemFile']}')),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    Text(
                      '${box[index]['rtitle']}',
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
}
