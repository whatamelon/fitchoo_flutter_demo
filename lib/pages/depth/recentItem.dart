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
      ritemId: json["ritemId"],
      risHeart: json["risHeart"],
      rcat1: json["rcat1"],
      rcat2: json["rcat2"],
      risNew: json["risNew"],
      rname: json["rname"],
      rprice: json["rprice"],
      rlinkUrl: json["rlinkUrl"],
      rimgFile: json["rimgFile"],
      rinfo: json["rinfo"],
      rshopId: json["rshopId"],
      rheight: json["rheight"],
      rmodelId: json["rmodelId"],
    );
  }
}

class RecentItemPage extends StatefulWidget {
  @override
  _RecentItemPageState createState() => _RecentItemPageState();
}

class _RecentItemPageState extends State<RecentItemPage> {
  List<String> _viewData = ['','','','','',''];
  Map<String, String> newMap = {};
  List<RItemList> _recentItems;
  List _timeList = [];

  @override
  void initState() {
    print('스토어어어');
    _recentItems = [];
    _openbox();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<List<RItemList>> _openbox() async{
    final prefs = await SharedPreferences.getInstance();
    var les = prefs.getStringList('recentItemList');

    for(var i = 0; i<les.length; i++) {
      print(jsonDecode(les[i]));
      _timeList.add(jsonDecode(les[i]));
    }
    print('timeList____$_timeList');

//    _recent2 = _timeList.map<QrecentList>((json) => QrecentList.fromJson(json)).toList();
    setState(() {
      _recentItems = _timeList.map<RItemList>((json) => RItemList.fromJson(json)).toList();
    });
    print(_recentItems);
  }

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
        title: Text('최근 본 싱품', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
            itemCount: _recentItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 3,
                childAspectRatio: 0.5),
            itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async{

                    listToMap(_recentItems[index]);
                    final pref = await SharedPreferences.getInstance();
                    var recentItemList =  pref.getStringList('recentItemList');
                    print('리센트리스트 보러갑니다앙____$recentItemList');

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
                      int _includeIndex = 0;
                      for(int i = 0; i < recentItemList.length; i++) {
                        if(_recent2[i].ritemId == _recentItems[index].ritemId) {
                          print(_recent2[i].ritemId);
                          print(_recentItems[index].ritemId);
                          print('몇번째냐 $i');
                          _includeIndex = i;
                          break;
                        }
                      }
                        print('이건데...');
                        print(recentItemList);
                        recentItemList.removeAt(_includeIndex);
                        print(recentItemList);
                        recentItemList.insert(0, jsonEncode(newMap));

                      print(recentItemList);

                      pref.setStringList('recentItemList', recentItemList);


                    this._viewData[0] = _recentItems[index].rlinkUrl;
                    this._viewData[1] = _recentItems[index].ritemId;
                    this._viewData[2] = _recentItems[index].risHeart == 't' ?  't':'f';
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
                                  imageUrl: "$img_url${_recentItems[index].rimgFile}",
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
                              _recentItems[index].risNew == 't' ?
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
                            _fixPrice(_recentItems[index].rprice),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _recentItems[index].rname,
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
    newMap['ritemId'] = x.ritemId;
    newMap['risHeart'] = x.risHeart;
    newMap['rcat1'] = x.rcat1;
    newMap['rcat2'] = x.rcat2;
    newMap['risNew'] = x.risNew;
    newMap['rname'] = x.rname;
    newMap['rprice'] = x.rprice;
    newMap['rlinkUrl'] = x.rlinkUrl;
    newMap['rimgFile'] = x.rimgFile;
    newMap['rinfo'] = x.rinfo;
    newMap['rshopId'] = x.rshopId;
    newMap['rheight'] = x.rheight;
    newMap['rmodelId'] = x.rmodelId;
  }
}
