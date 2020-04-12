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

class MarkQurationPage extends StatefulWidget {
  @override
  _MarkQurationPageState createState() => _MarkQurationPageState();
}

class _MarkQurationPageState extends State<MarkQurationPage> {
  Map<String, String> newMap = {};
  @override
  void initState() {
    print('즐겨찾기한 큐레이셔어어어언!!!');
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    super.initState();
    $qurate.getMarkList($user.accessToken, $user.appInfo);
  }

  @override
  void dispose() {
    super.dispose();
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
        title: Text('즐겨찾기한 큐레이션', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 14.w),
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: $qurate.qmarkList.length == 10 ? 10 : $qurate.qmarkList.length,
          itemBuilder: (context, index) {
            return _buildMarkCards($qurate, img_url, index, $user, $item);
          },
        ),
      ),
    );
  }

  Widget _buildMarkCards($qurate, img_url, index, $user, $item) {
    return Padding(
      padding: EdgeInsets.only(bottom:5.h),
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.none,
          elevation: 0,
          child : InkWell(
            onTap: () async{

              $qurate.switchHero('r');

              listToMap($qurate, $qurate.qmarkList[index]);
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
                  if(_recent2[i].rqcontId == $qurate.qmarkList[index].mqcontId) {
                    print(_recent2[i].rqcontId);
                    print($qurate.qmarkList[index].mqcontId);
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

              await $qurate.getQurateInfo($user.accessToken, $qurate.qmarkList[index].mqcontId, $user.appInfo);
              await $item.getQItemList($user.accessToken, $user.userHeight, $qurate.qmarkList[index].mqcontId, $user.appInfo);
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
                      imageUrl: "$img_url${$qurate.qmarkList[index].mimgLinkTitle}",
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
                            $qurate.qmarkList[index].mtitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style:TextStyle(color: Color(0XFF000000), fontSize: ScreenUtil().setSp(13))
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text($qurate.qmarkList[index].mquserName, style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
                          Text(' ${String.fromCharCode(0x2022)} ', style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
                          Text('조회수 ${_modiCnt($qurate.qmarkList[index].mclickCnt)}', style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
                        ],
                      ),
                      Text('상품 업데이트 ${timeModi($qurate.qmarkList[index].mitemupDate)}', style:TextStyle(color: Color(0XFF8a8a8a), fontSize: ScreenUtil().setSp(12))),
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
    newMap['rqcontId'] = x.mqcontId;
    newMap['rtitle'] = x.mtitle;
    newMap['rimgLinkTitle'] = x.mimgLinkTitle;
    newMap['rclickCnt'] = x.mclickCnt;
    newMap['ritemCnt'] = x.mitemCnt;
    newMap['ritemupDate'] = x.mitemupDate;
    newMap['rquserId'] = x.mquserId;
    newMap['rquserName'] = x.mquserName;
    newMap['rquserImgLink'] = x.mquserImgLink;
  }

}
