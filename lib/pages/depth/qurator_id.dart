import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuratorIdPage extends StatefulWidget {
  @override
  _QuratorIdPageState createState() => _QuratorIdPageState();
}

class _QuratorIdPageState extends State<QuratorIdPage> {
  @override
  Widget build(BuildContext context) {
    final $qurate = Provider.of<QurateState>(context);
    final $user = Provider.of<UserState>(context);
    final $item = Provider.of<ItemState>(context);
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";

    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child:CachedNetworkImage(
                fadeInCurve: Curves.fastOutSlowIn,
                fadeInDuration: Duration(seconds: 1),
                fit: BoxFit.cover,
                width:150,
                height:150,
                imageUrl: "$img_url${$qurate.quserImgLink}",
                placeholder: (context, url) => Container(
                    width: 150,
                    height:150,
                    color:Color(0XFFececec)
                ),
                errorWidget: (context, url, error) => Container(
                    width: 150,
                    height: 150,
                    child: Center(child: Icon(Icons.error))
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text($qurate.quserName),
              ],
            ),
            Text($qurate.quserDepartment),

            Container(
              height:50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: $qurate.quserTagList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                      padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                      backgroundColor: Colors.grey,
                      label: Text($qurate.quserTagList[index], style: TextStyle(fontSize: 15),),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20))),
                    ),
                  );
                }
              ),
            ),

            Text($qurate.myExp),

            Expanded(child: Divider(thickness: 1,)),
            Text('사진'),
            Text($qurate.styleExp),

            GridView.builder(
              itemCount: 6,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 3,
                childAspectRatio: 1),
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.fastOutSlowIn,
                    fadeInDuration: Duration(seconds: 1),
                    fit: BoxFit.cover,
                    width:100,
                    height:100,
                    imageUrl: "$img_url${$qurate.imgList[index]}",
                    placeholder: (context, url) => Container(
                        width: 100,
                        height:100,
                        color:Color(0XFFececec)
                    ),
                    errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        child: Center(child: Icon(Icons.error))
                    ),
                  ),
                );
              }
            ),

            Text('자주 입는 스타일'),
            Container(
              height:50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: $qurate.quserlstyleList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                      padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                      backgroundColor: Color(_changelbColor(index,$qurate)),
                      label: Text($qurate.quserlstyleList[index].style, style: TextStyle(fontSize: 15, color:Color(_changelColor(index,$qurate)))),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20))),
                    ),
                  );
                }
              ),
            ),

            Text('절대 안 입는 스타일'),
            Container(
              height:50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: $qurate.quserdstyleList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      child: Chip(
                        padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                        backgroundColor: Color(_changedbColor(index,$qurate)),
                        label: Text($qurate.quserdstyleList[index].style, style: TextStyle(fontSize: 15, color:Color(_changedColor(index,$qurate)))),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                      ),
                    );
                  }
              ),
            ),

            Text('좋아하는 브랜드'),


          ],
        ),
      ),
    );
  }

  _changelColor(index,$qurate) {
    return 0XFF + $qurate.quserlstyleList[index].colorText;
  }

  _changedColor(index,$qurate) {
    return 0XFF + $qurate.quserdstyleList[index].colorText;
  }

  _changelbColor(index, $qurate) {
   return 0XFF + $qurate.quserlstyleList[index].colorBg;
  }

  _changedbColor(index, $qurate) {
    return 0XFF + $qurate.quserdstyleList[index].colorBg;
  }
}
