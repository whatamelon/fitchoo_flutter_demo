import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

const baseUrl = 'https://rest.fitchoo.kr';

class ItemList {
  String itemId = '';
  String cat1 = '';
  String cat2 = '';
  String uploadTime = '';
  String name = '';
  String price = '';
  String linkUrl = '';
  String imgFile = '';
  String info = '';
  String modelName = '';
  String modelHeight = '';
  String modelId = '';

  ItemList(
      {this.itemId,
      this.cat1,
      this.cat2,
      this.uploadTime,
      this.name,
      this.price,
      this.linkUrl,
      this.imgFile,
      this.info,
      this.modelName,
      this.modelHeight,
      this.modelId});

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      itemId: json["itemId"],
      cat1: json["cat1"],
      cat2: json["cat2"],
      uploadTime: json["uploadTime"],
      name: json["name"],
      price: json["price"],
      linkUrl: json["linkUrl"],
      imgFile: json["imgFile"],
      info: json["info"],
      modelName: json["modelName"],
      modelHeight: json["modelHeight"],
      modelId: json["modelId"],
    );
  }
}

class QItemList {
  String qitemId = '';
  String qisHeart = '';
  String qcat1 = '';
  String qcat2 = '';
  String qisNew = '';
  String qname = '';
  String qprice = '';
  String qlinkUrl = '';
  String qimgFile = '';
  String qinfo = '';
  String qshopId = '';
  String qheight = '';
  String qmodelId = '';

  QItemList({
    this.qitemId,
    this.qisHeart,
    this.qcat1,
    this.qcat2,
    this.qisNew,
    this.qname,
    this.qprice,
    this.qlinkUrl,
    this.qimgFile,
    this.qinfo,
    this.qshopId,
    this.qheight,
    this.qmodelId
  });

  factory QItemList.fromJson(Map<String, dynamic> json) {
    return QItemList(
      qitemId: json["itemId"],
      qisHeart: json["isHeart"],
      qcat1: json["cat1"],
      qcat2: json["cat2"],
      qisNew: json["isNew"],
      qname: json["name"],
      qprice: json["price"],
      qlinkUrl: json["linkUrl"],
      qimgFile: json["imgFile"],
      qinfo: json["info"],
      qshopId: json["shopId"],
      qheight: json["height"],
      qmodelId: json["modelId"],
    );
  }
}

class KItemList {
  String kitemId = '';
  String kisHeart = '';
  String kcat1 = '';
  String kcat2 = '';
  String kisNew = '';
  String kname = '';
  String kprice = '';
  String klinkUrl = '';
  String kimgFile = '';
  String kinfo = '';
  String kshopId = '';
  String kheight = '';
  String kmodelId = '';

  KItemList({
    this.kitemId,
    this.kisHeart,
    this.kcat1,
    this.kcat2,
    this.kisNew,
    this.kname,
    this.kprice,
    this.klinkUrl,
    this.kimgFile,
    this.kinfo,
    this.kshopId,
    this.kheight,
    this.kmodelId
  });

  factory KItemList.fromJson(Map<String, dynamic> json) {
    return KItemList(
      kitemId: json["itemId"],
      kisHeart: json["isHeart"],
      kcat1: json["cat1"],
      kcat2: json["cat2"],
      kisNew: json["isNew"],
      kname: json["name"],
      kprice: json["price"],
      klinkUrl: json["linkUrl"],
      kimgFile: json["imgFile"],
      kinfo: json["info"],
      kshopId: json["shopId"],
      kheight: json["height"],
      kmodelId: json["modelId"],
    );
  }
}

class SaveItemList {
  String sitemId = '';
  String sisHeart = '';
  String scat1 = '';
  String scat2 = '';
  String sisNew = '';
  String sname = '';
  String sprice = '';
  String slinkUrl = '';
  String simgFile = '';
  String sinfo = '';
  String sshopId = '';
  String sheight = '';
  String smodelId = '';

  SaveItemList({
    this.sitemId,
    this.sisHeart,
    this.scat1,
    this.scat2,
    this.sisNew,
    this.sname,
    this.sprice,
    this.slinkUrl,
    this.simgFile,
    this.sinfo,
    this.sshopId,
    this.sheight,
    this.smodelId
  });

  factory SaveItemList.fromJson(Map<String, dynamic> json) {
    return SaveItemList(
      sitemId: json["itemId"],
      sisHeart: json["isHeart"],
      scat1: json["cat1"],
      scat2: json["cat2"],
      sisNew: json["isNew"],
      sname: json["name"],
      sprice: json["price"],
      slinkUrl: json["linkUrl"],
      simgFile: json["imgFile"],
      sinfo: json["info"],
      sshopId: json["shopId"],
      sheight: json["height"],
      smodelId: json["modelId"],
    );
  }
}

class ItemState with ChangeNotifier {
//  -----------------------------------
//  State
  int _offset = 0;
  int _limit = 30;
  int _totCnt = 0;
  int _listCnt = 0;
  Map<String, String> _cat1 = {'code': '000', 'name': '전체'};
  Map<String, String> _cat2 = {'code': '000', 'name': '전체'};
  String _qid = '';
  String _fit1 = '';
  String _option = '';
  String _keyword = '';
  String _hr = '';
  Map<String, String> _pr = {'priceRange': '0r4000000', 'name': '전체'};
  Map<String, String> _order = {'sortOrder': 'de', 'name': '정렬'};
  List<ItemList> _itemList = [];
  List<QItemList> _qitemList = [];
  List<KItemList> _kitemList = [];
  List<SaveItemList> _sitemList = [];
  List<Map<String, String>> _secCatList = [];

//  -----------------------------------
//  set

  ItemState() {
    this._offset = 0;
    this._limit = 0;
    this._totCnt = 0;
    this._listCnt = 0;
    this._cat1 = {'code': '000', 'name': '전체'};
    this._cat2 = {'code': '000', 'name': '전체'};
    this._qid = '';
    this._fit1 = '';
    this._option = '';
    this._keyword = '';
    this._hr = '';
    this._pr = {'priceRange': '0r4000000', 'name': '전체'};
    this._order = {'sortOrder': 'de', 'name': '정렬'};
    this._itemList = [];
    this._qitemList = [];
    this._kitemList = [];
    this._sitemList = [];
    this._secCatList = [];
  }

//  -----------------------------------
//  get

  int get offset {
    return _offset;
  }

  int get limit {
    return _limit;
  }

  int get totCnt {
    return _totCnt;
  }

  int get listCnt {
    return _listCnt;
  }

  Map<String, String> get cat1 {
    return _cat1;
  }

  Map<String, String> get cat2 {
    return _cat2;
  }

  String get qid {
    return _qid;
  }

  String get fit1 {
    return _fit1;
  }

  String get option {
    return _option;
  }

  String get keyword {
    return _keyword;
  }

  String get hr {
    return _hr;
  }

  Map<String, String> get pr {
    return _pr;
  }

  Map<String, String> get order {
    return _order;
  }

  List<ItemList> get itemList {
    return _itemList;
  }

  List<QItemList> get qitemList {
    return _qitemList;
  }

  List<KItemList> get kitemList {
    return _kitemList;
  }

  List<SaveItemList> get sitemList {
    return _sitemList;
  }

  List<Map<String, String>> get secCatList {
    return _secCatList;
  }

//  -----------------------------------
//  Action

  var dio = Dio();

  Future<List<QItemList>> getQItemList(i, height, qcontId, j) async {
    List<QItemList> qitemlist;
    Response response;
    try {
      response = await dio.get("$baseUrl/items/100/qcont/0$qcontId",
          queryParameters: {
            "offset": _offset,
            "limit": 30,
            'height': height,
            'cat1': _cat1['code'],
            'cat2': _cat2['code'],
            'fit1': _fit1,
            'hr': _hr,
            'pr': _pr['priceRange'],
            'order': _order['sortOrder']
          },
          options: Options(headers: {"Authorization": i, "User-Agent": j}));
      if (response.statusCode == 200) {
        this._totCnt = jsonDecode(response.data['result']['totCnt']);
        this._listCnt = jsonDecode(response.data['result']['listCnt']);
        var les = response.data['result']['itemList'];
        qitemlist = les.map<QItemList>((json) => QItemList.fromJson(json)).toList();
        print('상품리스트_____$qitemlist');
        print('카디비_____${this._offset}');
        if (this._offset == 0) {
          this._qitemList = qitemlist;
        } else {
          this._qitemList.addAll(qitemlist);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<List<KItemList>> getKItemList(i, height, keyword, j) async {
    List<KItemList> kitemlist;
    Response response;
    try {
      response = await dio.get("$baseUrl/items/100/name/$keyword",
          queryParameters: {
            "offset": _offset,
            "limit": 30,
            'pr': _pr['priceRange'],
            'order': _order['sortOrder']
          },
          options: Options(headers: {"Authorization": i, "User-Agent": j}));
      if (response.statusCode == 200) {
        this._totCnt = jsonDecode(response.data['result']['totCnt']);
        this._listCnt = jsonDecode(response.data['result']['listCnt']);
        var les = response.data['result']['itemList'];
        kitemlist = les.map<KItemList>((json) => KItemList.fromJson(json)).toList();
        print('상품리스트_____$kitemlist');
        print('카디비_____${this._offset}');
        if (this._offset == 0) {
          this._kitemList = kitemlist;
        } else {
          this._kitemList.addAll(kitemlist);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }


  addSavedProduct(i,j,k) async{
    Response response;
    try{
      response = await dio.post("$baseUrl/items/100/heart/$j",
          options: Options(
              headers: {"Authorization": i, "User-Agent": k}));
      print('굿');
    } catch(e) {
      print('낫 굿');
    }
    notifyListeners();
  }

  removeSavedProduct(i,j,k) async{
    Response response;
    try{
      response = await dio.delete("$baseUrl/items/100/heart/$j",
          options: Options(
              headers: {"Authorization": i, "User-Agent": k}));
      print('굿');
    } catch(e) {
      print('낫 굿');
    }
    notifyListeners();
  }


  Future<List<SaveItemList>> getSaveList(i, j) async {
    List<SaveItemList> list;
    Response response;
    try {
      response = await dio.get("$baseUrl/items/100/heart",
          queryParameters: {"offset": _offset, "limit": 30},
          options: Options(headers: {"Authorization": i, "User-Agent": j}));
      if (response.statusCode == 200) {
        print("ㅇㅋ 받아옴 -------${response.data['result']}");

        this._totCnt = jsonDecode(response.data['result']['totCnt']);
        this._listCnt = jsonDecode(response.data['result']['listCnt']);

        var les = response.data['result']['itemList'];
        print('큐레이션리스트____$les');
        list = les.map<SaveItemList>((json) => SaveItemList.fromJson(json)).toList();
        if (_offset == 0) {
          this._sitemList = list;
        } else {
          this._sitemList.addAll(list);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  sendItemInfo(i,j,k) async {
    Response response;
    try {
      response = await dio.get("$baseUrl/items/100/info/$j",
          options: Options(
              headers: {"Authorization": i, "User-Agent": k}));
    } catch (e) {}
    notifyListeners();
  }

  setOffset(i) async {
    this._offset = i;
    notifyListeners();
  }

  setQid(i) async {
    print('qid 세팅합니다아-----$_qid');
    this._qid = i;
    notifyListeners();
  }

  resetItemList() async {
    this._itemList.clear();
    notifyListeners();
  }

  resetQItemList() async {
    this._qitemList.clear();
    notifyListeners();
  }

  setFirstCatSelect(i) async {
    this._cat1 = i;
    notifyListeners();
  }

  setSecCatList(i) async {
    this._secCatList = i;
    notifyListeners();
  }

  setSecCatSelect(i) async {
    this._cat2 = i;
    notifyListeners();
  }

  setOrder(i) {
    this._order = i;
    notifyListeners();
  }

  setPrice(i) {
    this._pr = i;
    notifyListeners();
  }

  setFit(i) {
    this._fit1 = i['fit1'];
    notifyListeners();
  }

  setSearch(i) {
    this._keyword = i;
    notifyListeners();
  }
}
