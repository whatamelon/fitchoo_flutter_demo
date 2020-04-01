import 'dart:convert';
import 'package:fitchoo/pages/depth/quration_id.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class QrecentList {
  String rqitemId = '';
  String rqcode = '';
  String rclickCnt = '';
  String rquserName = '';
  String rimgFaceFile = '';
  String rimgItemFile = '';
  String ritemupDate = '';
  String rtitle = '';
  String rbody = '';

  QrecentList(
      {this.rqitemId,
        this.rqcode,
        this.rclickCnt,
        this.rquserName,
        this.rimgFaceFile,
        this.rimgItemFile,
        this.ritemupDate,
        this.rtitle,
        this.rbody});

  factory QrecentList.fromJson(Map<String, dynamic> json) {
    return QrecentList(
        rqitemId: json["qitemId"],
        rqcode: json["qcode"],
        rclickCnt: json["clickCnt"],
        rquserName: json["quserName"],
        rimgFaceFile: json["imgFaceFile"],
        rimgItemFile: json["imgItemFile"],
        ritemupDate: json["itemupDate"],
        rtitle: json["title"],
        rbody: json["body"]);
  }
}

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<QrecentList> _recent2 = [];
  List _timeList = [];
  bool _isTap = false;

  @override
  void initState() {
    super.initState();
    print('스토어어어');
    _openbox();
  }

  Future _openbox() async{
    final prefs = await SharedPreferences.getInstance();
    var les = prefs.getStringList('recentList');

    for(var i = 0; i<les.length; i++) {
      print(jsonDecode(les[i]));
      _timeList.add(jsonDecode(les[i]));
    }
    print('timeList____$_timeList');

    this._recent2 = _timeList.map<QrecentList>((json) => QrecentList.fromJson(json)).toList();
    print(this._recent2);
    return this._recent2;
  }

  @override
  Widget build(BuildContext context) {
    UserState $user = Provider.of<UserState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";

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
          ListTile(
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('최근 본 큐레이션'),
            onTap: () {
              setState(() {
                _isTap = true;
              });
            },
          ),
          Visibility(
            visible: _isTap,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _recent2.length,
                itemExtent: 220,
                itemBuilder: (context, index) {
                  return _buildRecentCards($qurate, img_url, index, $user, $item);
                },
              ),
        ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('즐겨찾기한 큐레이션'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('찜한 상품'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.remove_red_eye),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('최근 본 상품'),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }


  Widget _buildRecentCards($qurate, img_url, int index, $user, $item) {
    return Hero(
      tag:'r${_recent2[index].rimgItemFile}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () async{
            $qurate.switchHero('r');

//            print(box[index]);
//            listToMap($qurate, box[index]);
//            var qbox = await Hive.openBox('qurateInfo');
//            var getBox = qbox.get('recentList');
//            getBox.insert(0, newMap);
//            print('qinfo in Hive: ${qbox.get('recentList')}');
//            await qbox.close();

            $qurate.setQItemid(_recent2[index].rqitemId);
            $qurate.setImgItemFile(_recent2[index].rimgItemFile);
            $qurate.setImgFaceFile(_recent2[index].rimgFaceFile);
            $qurate.setQUsername(_recent2[index].rquserName);
            $qurate.setQTitle(_recent2[index].rtitle);
            $qurate.setQBody(_recent2[index].rbody);
            await $qurate.getQurateInfo($user.accessToken);
            $item.setQid(_recent2[index].rqitemId);
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
                          '$img_url${_recent2[index].rimgItemFile}')),
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
        ),
      ),
    );
  }
}
