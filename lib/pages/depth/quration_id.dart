import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:fitchoo/pages/depth/quration_item.dart';
import 'package:flutter/material.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class QurationIdPage extends StatefulWidget {
  @override
  _QurationIdPageState createState() => _QurationIdPageState();
}

class _QurationIdPageState extends State<QurationIdPage> {
  final GlobalKey<AnimatedListState> _aniKey = GlobalKey();
  final ScrollController _bscrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    print('큐레이션세부 들어왔어?');
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    QurateState $qurate = Provider.of<QurateState>(context);
    UserState $user = Provider.of<UserState>(context);
    ItemState $item = Provider.of<ItemState>(context);
    return Scaffold(
      body: _buildBody($qurate, img_url, $item, $user, size),
    );
  }

  Widget _buildBody($qurate, img_url, $item, $user, size) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return WillPopScope(
          onWillPop: () =>_onBackPressed(),
          child: SafeArea(
            top: true,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomScrollView(
                  controller: _bscrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: size.width*(2/3),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Hero(tag: _switchHero($qurate),
                                    child: Stack(
                                      children: <Widget>[
                                        Image.network('$img_url${$qurate.imgItemFile}', fit: BoxFit.fitWidth,),
                                        Positioned(top: 10, left: 10,
                                          child: ClipOval(
                                            child: Container(width: 35, height:35,
                                              color: Colors.white,
                                              child: Material(
                                                child: IconButton(
                                                  icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20,),
                                                  onPressed: () =>_onBackPressed(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            )),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(size.width*0.03, 10, size.width*0.03, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text($qurate.title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),),
                                  Padding(
                                    padding: EdgeInsets.only(top:10),
                                    child: Container(
                                      width:size.width*0.9,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.start,
                                        verticalDirection: VerticalDirection.down,
                                        spacing: 4,
                                        runSpacing: 2,
                                        children: <Widget>[
                                          Text(' 조회수 ${_modiCnt($qurate.clickCnt)} ', style: TextStyle(color:Color(0XFF777777), fontSize: 14),),
                                          Text(' ${String.fromCharCode(0x2022)} '),
                                          Text(' 상품수 234개', style: TextStyle(color:Color(0XFF777777), fontSize: 14),),
                                          Text(' ${String.fromCharCode(0x2022)} '),
                                          Text('상품 업데이트 ${timeModi($qurate.itemupDate)}', style: TextStyle(color:Color(0XFF777777), fontSize: 14),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.bookmark,color: Colors.red,),
                                          onPressed: () {

                                          }),
                                      Text('203', style: TextStyle(color:Colors.red, fontSize: 15,),),
                                      IconButton(
                                          icon: Icon(Icons.chat_bubble,color: Colors.grey,),
                                          onPressed: () {

                                          }),
                                      Text('12', style: TextStyle(color:Colors.grey, fontSize: 15,),),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:5),
                                    child: Container(
                                      width:size.width*0.9,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.start,
                                        verticalDirection: VerticalDirection.down,
                                        spacing: 10,
                                        runSpacing: 2,
                                        children: <Widget>[
                                          Chip(
                                            padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                            backgroundColor: Colors.grey,
                                            label: Text('#쇼핑몰모음', style: TextStyle(fontSize: 15),),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                          Chip(
                                            padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                            backgroundColor: Colors.grey,
                                            label: Text('#키작녀', style: TextStyle(fontSize: 15),),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                          Chip(
                                            padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                            backgroundColor: Colors.grey,
                                            label: Text('#20대', style: TextStyle(fontSize: 15),),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 15,left: size.width*0.03),
                                  child: ClipOval(
                                    child: Image.network(
                                      '$img_url${$qurate.imgFaceFile}',
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
                                    Text('민송', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),),
                                    Text('큐레이터', style: TextStyle(fontSize: 16, color: Colors.grey),),
                                  ],
                                )

                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(size.width*0.03, 10, size.width*0.03, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('큐레이션 설명', style: TextStyle(fontSize: 20),),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text($qurate.body, style: TextStyle(fontSize: 18, color: Colors.grey),),
                                  ),
                                  Text('이런 분께 추천해요', style: TextStyle(fontSize: 20),),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0, bottom: 8),
                                    child: Text($qurate.body, style: TextStyle(fontSize: 18, color: Colors.grey),),
                                  ),
                                ],
                              ),
                            )

                          ],
                        )
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
//                  left: size.width*0.3,
                  child: FloatingActionButton.extended(
                    backgroundColor: Color(0XFFec3e39),
                    splashColor: Colors.red,
                    icon: Icon(Icons.save),
                    label: Text('상품보러가기', style: TextStyle(fontSize: 20),),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => QurationItemPage()));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _switchHero($qurate) {
    if ($qurate.qSwitchHero == 'i') {
      return 'i${$qurate.imgItemFile}';
    } else if ($qurate.qSwitchHero == 'p') {
      return 'p${$qurate.imgItemFile}';
    } else if ($qurate.qSwitchHero == 'n') {
      return 'n${$qurate.imgItemFile}';
    } else {
      return 'r${$qurate.imgItemFile}';
    }
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

}