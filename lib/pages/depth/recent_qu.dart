import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitchoo/pages/depth/quration_id.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class RecentQuPage extends StatefulWidget {
  final List recentList;
  RecentQuPage({Key key, this.recentList}) : super(key: key);
  @override
  _RecentQuPageState createState() => _RecentQuPageState();
}

class _RecentQuPageState extends State<RecentQuPage> {
  List<QrecentList> _recent2;
  List _timeList = [];
  Map<String, String> newMap = {};

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

//    _recent2 = _timeList.map<QrecentList>((json) => QrecentList.fromJson(json)).toList();
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
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text('최근 본 큐레이션', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 14.w),
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _recent2.length == 10 ? 10 : _recent2.length,
            itemBuilder: (context, index) {
              return _buildRecentCards($qurate, img_url, index, $user, $item);
            },
        ),
      ),
    );
  }

  Widget _buildRecentCards($qurate, img_url, index, $user, $item) {
    return Padding(
      padding: EdgeInsets.only(bottom:5.h),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.none,
        elevation: 0,
        child : InkWell(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:CachedNetworkImage(
                    fadeInCurve: Curves.fastOutSlowIn,
                    fadeInDuration: Duration(seconds: 1),
                    fit: BoxFit.cover,
                    width:160.w,
                    height:110.h,
                    imageUrl: "$img_url${_recent2[index].rimgLinkTitle}",
                    placeholder: (context, url) => Container(
                        width:160.w,
                        height:110.h,
                        color:Color(0XFFececec)
                    ),
                    errorWidget: (context, url, error) => Container(
                        width:160.w,
                        height:110.h,
                        child: Center(child: Icon(Icons.error))
                    ),
                  ),
                ),
              ),
              Container(
                width: 160.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom:6.h),
                      child: Text(
                        _recent2[index].rtitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:TextStyle(color: Color(0XFF000000), fontSize: ScreenUtil().setSp(13))
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(_recent2[index].rquserName, style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
                        Text(' ${String.fromCharCode(0x2022)} ', style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
                        Text('조회수 ${_modiCnt(_recent2[index].rclickCnt)}', style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
                      ],
                    ),
                    Text('상품 업데이트 ${timeModi(_recent2[index].ritemupDate)}', style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
                  ],
                ),
              )

            ],
          ),
        )
      ),
    );
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
