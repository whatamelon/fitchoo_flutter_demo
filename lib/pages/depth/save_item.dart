import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitchoo/pages/shopView.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RItemList {
  String ritemId = '';
  String risHeart = '';
  String rcat1 = '';
  String rcat2 = '';
  String risNew = '';
  String rname = '';
  String rprice = '';
  String rlinkUrl = '';
  String rimgFile = '';
  String rinfo = '';
  String rshopId = '';
  String rheight = '';
  String rmodelId = '';

  RItemList(
      {this.ritemId,
        this.risHeart,
        this.rcat1,
        this.rcat2,
        this.risNew,
        this.rname,
        this.rprice,
        this.rlinkUrl,
        this.rimgFile,
        this.rinfo,
        this.rshopId,
        this.rheight,
        this.rmodelId});

  factory RItemList.fromJson(Map<String, dynamic> json) {
    return RItemList(
      ritemId: json["itemId"],
      risHeart: json["isHeart"],
      rcat1: json["cat1"],
      rcat2: json["cat2"],
      risNew: json["isNew"],
      rname: json["name"],
      rprice: json["price"],
      rlinkUrl: json["linkUrl"],
      rimgFile: json["imgFile"],
      rinfo: json["info"],
      rshopId: json["shopId"],
      rheight: json["height"],
      rmodelId: json["modelId"],
    );
  }
}

class SaveItemPage extends StatefulWidget {
  @override
  _SaveItemPageState createState() => _SaveItemPageState();
}


class _SaveItemPageState extends State<SaveItemPage> {

  @override
  void initState() {
    print('찜상품!!!');
    super.initState();
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    UserState $user = Provider.of<UserState>(context, listen: false);
    $item.getSaveList($user.accessToken, $user.appInfo);
  }


  @override
  void dispose() {
    super.dispose();
  }
  List<String> _viewData = ['','','',''];
  Map<String, String> newMap = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text('찜한 싱품', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        centerTitle: true,
        elevation: 1,
      ),
      body: _buildBody(),
    );
  }

 Widget _buildBody() {
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    QurateState $qurate = Provider.of<QurateState>(context);
    UserState $user = Provider.of<UserState>(context);
    ItemState $item = Provider.of<ItemState>(context);
    return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: $item.sitemList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 0,
              crossAxisSpacing: 3,
              childAspectRatio: 0.5),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async{

                listToMap($item.sitemList[index]);
                final pref = await SharedPreferences.getInstance();
                var recentItemList =  pref.getStringList('recentItemList');
                print('리센트리스트 보러갑니다앙____$recentItemList');

                if(recentItemList == null) {
                  print('list가 읍어요');
                  pref.setStringList('recentItemList', []);
                  var recentItemList =  pref.getStringList('recentItemList');
                  recentItemList.insert(0, jsonEncode(newMap));
                  pref.setStringList('recentItemList', recentItemList);

                } else {

                  List<RItemList> _recent2 = [];
                  List _timeList = [];

                  for(var i = 0; i<recentItemList.length; i++) {
                    print(jsonDecode(recentItemList[i]));
                    _timeList.add(jsonDecode(recentItemList[i]));
                  }
                  print('timeList____$_timeList');

                  _recent2 = _timeList.map<RItemList>((json) => RItemList.fromJson(json)).toList();
                  print(_recent2);

                  print('list가 있지요');
                  bool _isIncluded = false;
                  int _includeIndex = 0;
                  for(int i = 0; i < recentItemList.length; i++) {
                    if(_recent2[i].ritemId == $item.sitemList[index].sitemId) {
                      print(_recent2[i].ritemId);
                      print($item.sitemList[index].sitemId);
                      print('몇번째냐 $i');
                      _includeIndex = i;
                      _isIncluded = true;
                      break;
                    }
                  }

                  if(!_isIncluded) {
                    print('이건 안왔을거고...');
                    if(recentItemList.length == 30) {
                      recentItemList.removeLast();
                    }
                    recentItemList.insert(0, jsonEncode(newMap));
                  } else{
                    print('이건데...');
                    print(recentItemList);
                    recentItemList.removeAt(_includeIndex);
                    print(recentItemList);
                    recentItemList.insert(0, jsonEncode(newMap));
                  }

                  print(recentItemList);

                  pref.setStringList('recentItemList', recentItemList);
                }

                this._viewData[0] = $item.sitemList[index].slinkUrl;
                this._viewData[1] = $item.sitemList[index].sitemId;
                this._viewData[2] = $item.sitemList[index].sisHeart == 't' ?  't':'f';
                _showWebview();
              },
              child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.none,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:CachedNetworkImage(
                              fadeInCurve: Curves.fastOutSlowIn,
                              fadeInDuration: Duration(seconds: 1),
                              fit: BoxFit.cover,
                              width:120,
                              height:160,
                              imageUrl: "$img_url${$item.sitemList[index].simgFile}",
                              placeholder: (context, url) => Container(
                                  width: 120,
                                  height:160,
                                  color:Color(0XFFececec)
                              ),
                              errorWidget: (context, url, error) => Container(
                                  width: 120,
                                  height: 160,
                                  child: Center(child: Icon(Icons.error))
                              ),
                            ),
                          ),
                          $item.sitemList[index].sisNew == 't' ?
                          Positioned(
                            top: 5,
                            left: 5,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(3))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    6, 3, 6, 3),
                                child: Text(
                                  'N',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ):
                          Container(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                      ),
                      Text(
                        _fixPrice($item.sitemList[index].sprice),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        $item.sitemList[index].sname,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  )),
            );
          },
        ),
    );
 }

  _fixPrice(i) {
    int _index = 0;
    if (i.length == 11) {
      _index = 3;
      i = i.substring(0, 6);
    } else if (i.length == 10) {
      _index = 2;
      i = i.substring(0, 5);
    } else if (i.length == 9) {
      _index = 1;
      i = i.substring(0, 4);
    } else {
      return i;
    }
    return i.substring(0, _index) + "," + i.substring(_index);
  }

  void _showWebview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return ShopViewPage(viewData: this._viewData);
        }));
  }


  void listToMap(x) {
    newMap['ritemId'] = x.sitemId;
    newMap['risHeart'] = x.sisHeart;
    newMap['rcat1'] = x.scat1;
    newMap['rcat2'] = x.scat2;
    newMap['risNew'] = x.sisNew;
    newMap['rname'] = x.sname;
    newMap['rprice'] = x.sprice;
    newMap['rlinkUrl'] = x.slinkUrl;
    newMap['rimgFile'] = x.simgFile;
    newMap['rinfo'] = x.sinfo;
    newMap['rshopId'] = x.sshopId;
    newMap['rheight'] = x.sheight;
    newMap['rmodelId'] = x.smodelId;
  }
}
