import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:fitchoo/states/user_state.dart';
import 'package:provider/provider.dart';

const baseUrl = 'https://rest.fitchoo.kr';

final $user = UserState;

class QcatList {
  String cat1 = '';
  String cat2 = '';

  QcatList({
      this.cat1,
      this.cat2
    });

  factory QcatList.fromJson(Map<String, dynamic> json) {
    return QcatList(
        cat1: json["cat1"],
        cat2: json["cat2"],
    );
  }
}

class QmodelList {
  String modelId = '';
  String name = '';
  String imgFaceFile = '';

  QmodelList({
    this.modelId,
    this.name,
    this.imgFaceFile
  });

  factory QmodelList.fromJson(Map<String, dynamic> json) {
    return QmodelList(
      modelId: json["modelId"],
      name: json["name"],
      imgFaceFile: json["imgFaceFile"],
    );
  }
}

class QpopList {
  String pqitemId = '';
  String pqcode = '';
  String pclickCnt = '';
  String pquserName = '';
  String pimgFaceFile = '';
  String pimgItemFile = '';
  String pitemupDate = '';
  String ptitle = '';
  String pbody = '';

  QpopList(
    {
      this.pqitemId,
      this.pqcode,
      this.pclickCnt,
      this.pquserName,
      this.pimgFaceFile,
      this.pimgItemFile,
      this.pitemupDate,
      this.ptitle,
      this.pbody
    });
  factory QpopList.fromJson(Map<String, dynamic> json) {
    return QpopList(
        pqitemId: json["qitemId"],
        pqcode: json["qcode"],
        pclickCnt: json["clickCnt"],
        pquserName: json["quserName"],
        pimgFaceFile: json["imgFaceFile"],
        pimgItemFile: json["imgItemFile"],
        pitemupDate: json["itemupDate"],
        ptitle: json["title"],
        pbody: json["body"]
    );
  }
}

class QnewList {
  String nqitemId = '';
  String nqcode = '';
  String nclickCnt = '';
  String nquserName = '';
  String nimgFaceFile = '';
  String nimgItemFile = '';
  String nitemupDate = '';
  String ntitle = '';
  String nbody = '';

  QnewList(
      {
        this.nqitemId,
        this.nqcode,
        this.nclickCnt,
        this.nquserName,
        this.nimgFaceFile,
        this.nimgItemFile,
        this.nitemupDate,
        this.ntitle,
        this.nbody
      });
  factory QnewList.fromJson(Map<String, dynamic> json) {
    return QnewList(
        nqitemId: json["qitemId"],
        nqcode: json["qcode"],
        nclickCnt: json["clickCnt"],
        nquserName: json["quserName"],
        nimgFaceFile: json["imgFaceFile"],
        nimgItemFile: json["imgItemFile"],
        nitemupDate: json["itemupDate"],
        ntitle: json["title"],
        nbody: json["body"]
    );
  }
}


class QitemList {
  String iqitemId = '';
  String iqcode = '';
  String iclickCnt = '';
  String iquserName = '';
  String iimgFaceFile = '';
  String iimgItemFile = '';
  String iitemupDate = '';
  String ititle = '';
  String ibody = '';

  QitemList(
      {
        this.iqitemId,
        this.iqcode,
        this.iclickCnt,
        this.iquserName,
        this.iimgFaceFile,
        this.iimgItemFile,
        this.iitemupDate,
        this.ititle,
        this.ibody
      });
  factory QitemList.fromJson(Map<String, dynamic> json) {
    return QitemList(
        iqitemId: json["qitemId"],
        iqcode: json["qcode"],
        iclickCnt: json["clickCnt"],
        iquserName: json["quserName"],
        iimgFaceFile: json["imgFaceFile"],
        iimgItemFile: json["imgItemFile"],
        iitemupDate: json["itemupDate"],
        ititle: json["title"],
        ibody: json["body"]
    );
  }
}

class QurateState with ChangeNotifier {
//  -----------------------------------
//  State

  int _totCnt = 0;
  int _listCnt = 0;
  String _qitemId = '';
  String _qcode = '';
  String _clickCnt = '';
  String _quserName = '';
  String _imgFaceFile = '';
  String _imgItemFile = '';
  String _itemupDate = '';
  String _title = '';
  String _body = '';
  List<QpopList> _qpopList = [];
  List<QnewList> _qnewList = [];
  List<QitemList> _qitemList = [];
  int _qOffset = 0;
  String _qSwitchHero = '';
  List<QcatList> _qcatList = [];
  List<QmodelList> _qmodelList = [];
  List _activeFirstCat = [];
  List _activeSecCat = [];
  List _pureCatList = [];



//  -----------------------------------
//  set

  QurateState() {
    this._totCnt = 0;
    this._listCnt = 0;
    this._qitemId = '';
    this._qcode = '';
    this._clickCnt = '';
    this._quserName = '';
    this._imgFaceFile = '';
    this._imgItemFile = '';
    this._itemupDate = '';
    this._title = '';
    this._body = '';
    this._qpopList = [];
    this._qnewList = [];
    this._qitemList = [];
    this._qOffset = 0;
    this._qSwitchHero = '';
    this._qcatList = [];
    this._qmodelList = [];
    this._activeFirstCat = [];
    this._activeSecCat = [];
    this._pureCatList = [];
  }

//  -----------------------------------
//  get

  int get totCnt {
    return _totCnt;
  }

  int get listCnt {
    return _listCnt;
  }

  String get qitemId {
    return _qitemId;
  }

  String get qcode {
    return _qcode;
  }

  String get clickCnt {
    return _clickCnt;
  }

  String get quserName {
    return _quserName;
  }

  String get imgFaceFile {
    return _imgFaceFile;
  }

  String get imgItemFile {
    return _imgItemFile;
  }

  String get itemupDate {
    return _itemupDate;
  }

  String get title {
    return _title;
  }

  String get body {
    return _body;
  }

  List<QpopList> get qpopList {
    return _qpopList;
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

  List<QmodelList> get qmodelList {
    return _qmodelList;
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



//  -----------------------------------
//  Action

  setQOffset(i) async{
    this._qOffset = i;
    notifyListeners();
  }

  var dio = Dio();

  Future<List<QpopList>> getQurateList(i) async {
    List<QpopList> list;
    List<QnewList> list2;
    List<QitemList> list3;
    Response response;
    try{
      response = await dio.get("$baseUrl/qitems",
          queryParameters: {
            "offset": _qOffset,
            "limit": 10
          },
          options: Options(
          headers: {
          "Authorization" : i
          }));
      if(response.statusCode == 200) {
        print("ㅇㅋ 인기리스트 받아옴 -------${response.data['result']}");

        this._totCnt = jsonDecode(response.data['result']['totCnt']);
        this._listCnt = jsonDecode(response.data['result']['listCnt']);

        var les = response.data['result']['qpopList'];
        list = les.map<QpopList>((json) => QpopList.fromJson(json)).toList();
        this._qpopList = list;

        var les2 = response.data['result']['qnewList'];
        list2 = les2.map<QnewList>((json) => QnewList.fromJson(json)).toList();
        this._qnewList = list2;

        var les3 = response.data['result']['qitemList'];
        list3 = les3.map<QitemList>((json) => QitemList.fromJson(json)).toList();
        if(_qOffset == 0) {
          this._qitemList = list3;
        } else {
          this._qitemList.addAll(list3);
        }
        print(_qOffset);
        print(_qitemList);
      }
    }catch(e) {
      print(e);
    }
    notifyListeners();
  }

  Future<List<QcatList>> getQurateInfo(i) async {
    List<QcatList> list;
    List<QmodelList> list2;
    Response response;
    try{
      response = await dio.get("$baseUrl/qitems/info/$_qitemId",
          options: Options(
              headers: {
                "Authorization" : i
              }));
      if(response.statusCode == 200) {
        var les = response.data['result']['catList'];
        this._pureCatList = les;
        list = les.map<QcatList>((json) => QcatList.fromJson(json)).toList();
        this._qcatList = list;

        List<String> newMap = [];
        for (var code in les) {
          newMap.add(code['cat1']);
        }
        var distinctMap = newMap.toSet().toList();
        distinctMap.insert(0,'000');
        print(distinctMap);
        this._activeFirstCat = distinctMap;

        var les2 = response.data['result']['qmodelList'];
        list2 = les2.map<QmodelList>((json) => QmodelList.fromJson(json)).toList();
        this._qmodelList = list2;
      }
    }catch(e) {
      print(e);
    }
    notifyListeners();
  }

  setActiveSecCat(i) {
    List getSecMap = [];
    List<String> newMap = [];
    for(var code in this._pureCatList) {
      print(code['cat1']);
      print(i['code']);

      if(code['cat1'] == i['code']) {
        getSecMap.add(code);
      }
    }

    for(var code2 in getSecMap) {
      newMap.add(code2['cat2']);
    }
    var distinctMap = newMap.toSet().toList();
    distinctMap.insert(0,'000');
    print('이건 디스팅트 맵$distinctMap');
    this._activeSecCat = distinctMap;
    notifyListeners();
  }


  setQItemid(i) {
    this._qitemId = i;
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