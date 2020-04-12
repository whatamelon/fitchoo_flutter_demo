import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:fitchoo/states/user_state.dart';
import 'package:provider/provider.dart';

const baseUrl = 'https://rest.fitchoo.kr';

final $user = UserState;

class QuserSnsList {
  String snsType = '';
  String snsLink = '';

  QuserSnsList({this.snsType, this.snsLink});

  factory QuserSnsList.fromJson(Map<String, dynamic> json) {
    return QuserSnsList(
      snsType: json["snsType"],
      snsLink: json["snsLink"],
    );
  }
}

class QuserLstyleList {
  String style = '';
  String colorText = '';
  String colorBg = '';

  QuserLstyleList({this.style, this.colorText, this.colorBg});

  factory QuserLstyleList.fromJson(Map<String, dynamic> json) {
    return QuserLstyleList(
      style: json["style"],
      colorText: json["colorText"],
      colorBg: json["colorBg"],
    );
  }
}

class QuserDstyleList {
  String style = '';
  String colorText = '';
  String colorBg = '';

  QuserDstyleList({this.style, this.colorText, this.colorBg});

  factory QuserDstyleList.fromJson(Map<String, dynamic> json) {
    return QuserDstyleList(
      style: json["style"],
      colorText: json["colorText"],
      colorBg: json["colorBg"],
    );
  }
}

class QuserContList {
  String qcontId = '';
  String clickCnt = '';
  String imgLinkTitle = '';
  String itemupDate = '';
  String title = '';

  QuserContList({this.qcontId, this.clickCnt, this.imgLinkTitle, this.itemupDate, this.title});

  factory QuserContList.fromJson(Map<String, dynamic> json) {
    return QuserContList(
      qcontId: json["qcontId"],
      clickCnt: json["clickCnt"],
      imgLinkTitle: json["imgLinkTitle"],
      itemupDate: json["itemupDate"],
      title: json["title"],
    );
  }
}

class QcatList {
  String cat1 = '';
  String cat2 = '';

  QcatList({this.cat1, this.cat2});

  factory QcatList.fromJson(Map<String, dynamic> json) {
    return QcatList(
      cat1: json["cat1"],
      cat2: json["cat2"],
    );
  }
}


class QnewList {
  String nqcontId = '';
  String ntitle = '';
  String nimgLinkTitle = '';
  String nclickCnt = '';
  String nitemCnt = '';
  String nitemupDate = '';
  String nquserId = '';
  String nquserName = '';
  String nquserImgLink = '';

  QnewList({
    this.nqcontId,
    this.ntitle,
    this.nimgLinkTitle,
    this.nclickCnt,
    this.nitemCnt,
    this.nitemupDate,
    this.nquserId,
    this.nquserName,
    this.nquserImgLink,
  });

  factory QnewList.fromJson(Map<String, dynamic> json) {
    return QnewList(
        nqcontId: json["qcontId"],
        ntitle: json["title"],
        nimgLinkTitle: json["imgLinkTitle"],
        nclickCnt: json["clickCnt"],
        nitemCnt: json["itemCnt"],
        nitemupDate: json["itemupDate"],
        nquserId: json["quserId"],
        nquserName: json["quserName"],
        nquserImgLink: json["quserImgLink"]);
  }
}

class QitemList {
  String iqcontId = '';
  String ititle = '';
  String iimgLinkTitle = '';
  String iclickCnt = '';
  String iitemCnt = '';
  String iitemupDate = '';
  String iquserId = '';
  String iquserName = '';
  String iquserImgLink = '';

  QitemList({
    this.iqcontId,
    this.ititle,
    this.iimgLinkTitle,
    this.iclickCnt,
    this.iitemCnt,
    this.iitemupDate,
    this.iquserId,
    this.iquserName,
    this.iquserImgLink,
  });

  factory QitemList.fromJson(Map<String, dynamic> json) {
    return QitemList(
        iqcontId: json["qcontId"],
        ititle: json["title"],
        iimgLinkTitle: json["imgLinkTitle"],
        iclickCnt: json["clickCnt"],
        iitemCnt: json["itemCnt"],
        iitemupDate: json["itemupDate"],
        iquserId: json["quserId"],
        iquserName: json["quserName"],
        iquserImgLink: json["quserImgLink"]);
  }
}

class QmarkList {
  String mqcontId = '';
  String mtitle = '';
  String mimgLinkTitle = '';
  String mclickCnt = '';
  String mitemCnt = '';
  String mitemupDate = '';
  String mquserId = '';
  String mquserName = '';
  String mquserImgLink = '';

  QmarkList({
    this.mqcontId,
    this.mtitle,
    this.mimgLinkTitle,
    this.mclickCnt,
    this.mitemCnt,
    this.mitemupDate,
    this.mquserId,
    this.mquserName,
    this.mquserImgLink,
  });

  factory QmarkList.fromJson(Map<String, dynamic> json) {
    return QmarkList(
        mqcontId: json["qcontId"],
        mtitle: json["title"],
        mimgLinkTitle: json["imgLinkTitle"],
        mclickCnt: json["clickCnt"],
        mitemCnt: json["itemCnt"],
        mitemupDate: json["itemupDate"],
        mquserId: json["quserId"],
        mquserName: json["quserName"],
        mquserImgLink: json["quserImgLink"]);
  }
}

class QurateState with ChangeNotifier {
//  -----------------------------------
//  State

  int _totCnt = 0;
  int _listCnt = 0;
  String _qcontId = '';
  String _imgLinkTitle = '';
  String _isMark = '';
  String _title = '';
  String _body = '';
  String _clickCnt = '';
  String _itemCnt = '';
  String _markCnt = '';
  String _itemupDate = '';
  String _quserId = '';
  String _quserName = '';
  String _quserImgLink = '';
  String _quserDepartment = '';
  String _imgFaceFile = '';
  String _imgItemFile = '';
  List _tagList = [];
  List _recommendList = [];
  List<QnewList> _qnewList = [];
  List<QitemList> _qitemList = [];
  int _qOffset = 0;
  String _qSwitchHero = '';
  List<QcatList> _qcatList = [];
  List _activeFirstCat = [];
  List _activeSecCat = [];
  List _pureCatList = [];
  List<QuserSnsList> _qusersnsList = [];
  List<QuserLstyleList> _quserlstyleList = [];
  List<QuserDstyleList> _quserdstyleList = [];
  List<QuserContList> _qusercontList = [];
  String _sizeHeight = '';
  String _sizeTop = '';
  String _sizeBottom = '';
  String _sizeFoot = '';
  String _sizeShoulder = '';
  String _sizePelvis = '';
  String _myExp = '';
  String _styleExp = '';
  List _likeBrand = [];
  List _quserTagList = [];
  List _imgList = [];
  String _qcontCnt = '';
  List<QmarkList> _qmarkList = [];



//  -----------------------------------
//  set

  QurateState() {
    this._totCnt = 0;
    this._listCnt = 0;
    this._qcontId = '';
    this._imgLinkTitle = '';
    this._isMark = '';
    this._title = '';
    this._body = '';
    this._clickCnt = '';
    this._itemCnt = '';
    this._markCnt = '';
    this._itemupDate = '';
    this._quserId = '';
    this._quserName = '';
    this._quserImgLink = '';
    this._quserDepartment = '';
    this._imgFaceFile = '';
    this._imgItemFile = '';
    this._tagList = [];
    this._recommendList = [];
    this._qnewList = [];
    this._qitemList = [];
    this._qOffset = 0;
    this._qSwitchHero = '';
    this._qcatList = [];
    this._activeFirstCat = [];
    this._activeSecCat = [];
    this._pureCatList = [];
    this._qusersnsList = [];
    this._quserlstyleList = [];
    this._quserdstyleList = [];
    this._qusercontList = [];
    this._sizeHeight = '';
    this._sizeTop = '';
    this._sizeBottom = '';
    this._sizeFoot = '';
    this._sizeShoulder = '';
    this._sizePelvis = '';
    this._myExp = '';
    this._styleExp = '';
    this._likeBrand = [];
    this._quserTagList = [];
    this._imgList = [];
    this._qcontCnt = '';
    this._qmarkList = [];
  }

//  -----------------------------------
//  get

  int get totCnt {
    return _totCnt;
  }

  int get listCnt {
    return _listCnt;
  }

  String get qcontId {
    return _qcontId;
  }

  String get imgLinkTitle {
    return _imgLinkTitle;
  }

  String get isMark {
    return _isMark;
  }

  String get title {
    return _title;
  }

  String get body {
    return _body;
  }

  String get clickCnt {
    return _clickCnt;
  }

  String get itemCnt {
    return _itemCnt;
  }

  String get markCnt {
    return _markCnt;
  }

  String get itemupDate {
    return _itemupDate;
  }

  String get quserId {
    return _quserId;
  }

  String get quserName {
    return _quserName;
  }

  String get quserImgLink {
    return _quserImgLink;
  }

  String get quserDepartment {
    return _quserDepartment;
  }

  String get imgFaceFile {
    return _imgFaceFile;
  }

  String get imgItemFile {
    return _imgItemFile;
  }

  List get tagList {
    return _tagList;
  }

  List get recommendList {
    return _recommendList;
  }

  List<QnewList> get qnewList {
    return _qnewList;
  }

  List<QitemList> get qitemList {
    return _qitemList;
  }

  int get qOffset {
    return _qOffset;
  }

  String get qSwitchHero {
    return _qSwitchHero;
  }

  List<QcatList> get qcatList {
    return _qcatList;
  }

  List get activeFirstCat {
    return _activeFirstCat;
  }

  List get activeSecCat {
    return _activeSecCat;
  }

  List get pureCatList {
    return _pureCatList;
  }

  List get qusersnsList {
    return _qusersnsList;
  }

  List get quserlstyleList {
    return _quserlstyleList;
  }

  List get quserdstyleList {
    return _quserdstyleList;
  }

  List get qusercontList {
    return _qusercontList;
  }

  String get sizeHeight {
    return _sizeHeight;
  }

  String get sizeTop {
    return _sizeTop;
  }

  String get sizeBottom {
    return _sizeBottom;
  }

  String get sizeFoot {
    return _sizeFoot;
  }

  String get sizeShoulder {
    return _sizeShoulder;
  }

  String get sizePelvis {
    return _sizePelvis;
  }

  String get myExp {
    return _myExp;
  }

  String get styleExp {
    return _styleExp;
  }

  List get likeBrand {
    return _likeBrand;
  }

  List get quserTagList {
    return _quserTagList;
  }

  List get imgList {
    return _imgList;
  }

  String get qcontCnt {
    return _qcontCnt;
  }

  List get qmarkList {
    return _qmarkList;
  }


//  -----------------------------------
//  Action

  setQOffset(i) async {
    this._qOffset = i;
    notifyListeners();
  }

  var dio = Dio();

  Future<List<QitemList>> getQurateList(i, j) async {
    List<QnewList> list2;
    List<QitemList> list3;
    Response response;
    try {
      response = await dio.get("$baseUrl/qconts/100",
          queryParameters: {"offset": _qOffset, "limit": 10},
          options: Options(headers: {"Authorization": i, "User-Agent": j}));
      if (response.statusCode == 200) {
        print("ㅇㅋ 인기리스트 받아옴 -------${response.data['result']}");

        this._totCnt = jsonDecode(response.data['result']['totCnt']);
        this._listCnt = jsonDecode(response.data['result']['listCnt']);

        var les2 = response.data['result']['qnewList'];
        list2 = les2.map<QnewList>((json) => QnewList.fromJson(json)).toList();
        this._qnewList = list2;

        var les3 = response.data['result']['qcontList'];
        print('큐레이션리스트____$les3');
        list3 = les3.map<QitemList>((json) => QitemList.fromJson(json)).toList();
        if (_qOffset == 0) {
          this._qitemList = list3;
        } else {
          this._qitemList.addAll(list3);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<List<QcatList>> getQurateInfo(i,j, k) async {
    List<QcatList> list;
    Response response;
    try {
      response = await dio.get("$baseUrl/qconts/100/$j",
          options: Options(
              headers: {"Authorization": i, "User-Agent": k}));
      if (response.statusCode == 200) {
        var les2 = response.data['result'];
        print(les2);
        var les = response.data['result']['catList'];
        if (les != null) {
          this._pureCatList = les;
          list = les.map<QcatList>((json) => QcatList.fromJson(json)).toList();
          this._qcatList = list;

          List<String> newMap = [];
          for (var code in les) {
            newMap.add(code['cat1']);
          }
          var distinctMap = newMap.toSet().toList();
          distinctMap.insert(0, '000');
          this._activeFirstCat = distinctMap;

          this._qcontId = les2['qcontId'];
          this._isMark = les2['isMark'];
          this._imgLinkTitle = les2['imgLinkTitle'];
          this._title = les2['title'];
          this._body = les2['body'];
          this._clickCnt = les2['clickCnt'];
          this._itemCnt = les2['itemCnt'];
          this._markCnt = les2['markCnt'];
          this._itemupDate = les2['itemupDate'];
          this._quserId = les2['quserId'];
          this._quserName = les2['quserName'];
          this._quserImgLink = les2['quserImgLink'];
          this._quserDepartment = les2['quserDepartment'];
          this._tagList = les2['tagList'];
          print(this._tagList);
          this._recommendList = les2['recommendList'];
          print(this._recommendList);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<List<QcatList>> getQuratorInfo(i,j, k) async {
    List<QuserSnsList> list3;
    List<QuserLstyleList> list4;
    List<QuserDstyleList> list5;
    List<QuserContList> list6;
    Response response;
    try {
      response = await dio.get("$baseUrl/qusers/100/$j",
          options: Options(
              headers: {"Authorization": i, "User-Agent": k}));
      if (response.statusCode == 200) {
        var les2 = response.data['result'];
        print(les2);
          this._qcontId = les2['qcontId'];
          this._quserName = les2['name'];
          this._quserDepartment = les2['department'];
          this._imgLinkTitle = les2['imgLinkTitle'];
          this._sizeHeight = les2['sizeHeight'];
          this._sizeTop = les2['sizeTop'];
          this._sizeBottom = les2['sizeBottom'];
          this._sizeFoot = les2['sizeFoot'];
          this._sizeShoulder = les2['sizeShoulder'];
          this._sizePelvis = les2['sizePelvis'];
          this._sizePelvis = les2['myExp'];
          this._sizePelvis = les2['styleExp'];
          var brand = les2['likeBrand'];
          var brandSplit = brand.split(',');
          this._likeBrand = brandSplit;
          this._quserTagList = les2['tagList'];
          this._imgList = les2['imgList'];

          var les3 = response.data['result']['snsList'];
          list3 = les3.map<QuserSnsList>((json) => QuserSnsList.fromJson(json)).toList();
          this._qusersnsList = list3;

          var les4 = response.data['result']['styleLikeList'];
          list4 = les4.map<QuserLstyleList>((json) => QuserLstyleList.fromJson(json)).toList();
          this._quserlstyleList = list4;

          var les5 = response.data['result']['styleLikeList'];
          list5 = les5.map<QuserDstyleList>((json) => QuserDstyleList.fromJson(json)).toList();
          this._quserdstyleList = list5;

          var les6 = response.data['result']['qcontList'];
          list6 = les6.map<QuserContList>((json) => QuserContList.fromJson(json)).toList();
          this._qusercontList = list6;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  addmarkQurate(i,j,k) async{
    Response response;
    try{
      response = await dio.post("$baseUrl/qconts/100/mark/$j",
          options: Options(
              headers: {"Authorization": i, "User-Agent": k}));
    } catch(e) {
    }
    notifyListeners();
  }

  removemarkQurate(i,j,k) async{
    Response response;
    try{
      response = await dio.delete("$baseUrl/qconts/100/mark/$j",
          options: Options(
              headers: {"Authorization": i, "User-Agent": k}));
    } catch(e) {
    }
    notifyListeners();
  }


  Future<List<QmarkList>> getMarkList(i, j) async {
    List<QmarkList> list;
    Response response;
    try {
      response = await dio.get("$baseUrl/qconts/100/mark",
          queryParameters: {"offset": _qOffset, "limit": 10},
          options: Options(headers: {"Authorization": i, "User-Agent": j}));
      if (response.statusCode == 200) {
        print("ㅇㅋ 인기리스트 받아옴 -------${response.data['result']}");

        this._totCnt = jsonDecode(response.data['result']['totCnt']);
        this._listCnt = jsonDecode(response.data['result']['listCnt']);

        var les = response.data['result']['qcontList'];
        print('큐레이션리스트____$les');
        list = les.map<QmarkList>((json) => QmarkList.fromJson(json)).toList();
        if (_qOffset == 0) {
          this._qmarkList = list;
        } else {
          this._qmarkList.addAll(list);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  setActiveSecCat(i) {
    List getSecMap = [];
    List<String> newMap = [];
    for (var code in this._pureCatList) {
      if (code['cat1'] == i['code']) {
        getSecMap.add(code);
      }
    }

    for (var code2 in getSecMap) {
      newMap.add(code2['cat2']);
    }
    var distinctMap = newMap.toSet().toList();
    distinctMap.insert(0, '000');
    this._activeSecCat = distinctMap;
    notifyListeners();
  }

  setQItemid(i) {
    this._qcontId = i;
    print(this._qcontId);
    notifyListeners();
  }

  setImgItemFile(i) {
    this._imgItemFile = i;
    notifyListeners();
  }

  setImgFaceFile(i) {
    this._imgFaceFile = i;
    notifyListeners();
  }

  setUpdatetiem(i) {
    this._itemupDate = i;
    notifyListeners();
  }

  setClickCnt(i) {
    this._clickCnt = i;
    notifyListeners();
  }

  setQUsername(i) {
    this._quserName = i;
    notifyListeners();
  }

  setQTitle(i) {
    this._title = i;
    notifyListeners();
  }

  setQBody(i) {
    this._body = i;
    notifyListeners();
  }

  switchHero(i) {
    this._qSwitchHero = i;
    notifyListeners();
  }
}
