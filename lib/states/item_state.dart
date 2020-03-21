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

  ItemList({
    this.itemId,
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
    this.modelId
  });

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

class ItemState with ChangeNotifier {
//  -----------------------------------
//  State

  int _offset = 0;
  int _limit = 30;
  int _totCnt = 0;
  int _listCnt = 0;
  Map<String, String> _cat1 = {'code': '000','name': '전체'};
  Map<String, String> _cat2 = {'code': '000','name': '전체'};
  String _qid = '';
  String _fit1 = '';
  String _option = '';
  String _keyword = '';
  String  _hr = '';
  Map<String, String>  _pr = {'priceRange': '0r4000000','name': '전체'};
  Map<String, String> _order = {'sortOrder': 'de','name': '정렬'};
  List<ItemList> _itemList = [];
  List<Map<String, String>> _secCatList = [];

//  -----------------------------------
//  set

  ItemState() {
    this._offset = 0;
    this._limit = 0;
    this._totCnt = 0;
    this._listCnt = 0;
    this._cat1 = {'code': '000','name': '전체'};
    this._cat2 = {'code': '000','name': '전체'};
    this._qid = '';
    this._fit1 = '';
    this._option = '';
    this._keyword = '';
    this._hr = '';
    this._pr = {'priceRange': '0r4000000','name': '전체'};
    this._order = {'sortOrder': 'de','name': '정렬'};
    this._itemList = [];
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

  Map<String,String> get cat1 {
    return _cat1;
  }

  Map<String,String> get cat2 {
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

  Map<String,String> get pr {
    return _pr;
  }

  Map<String,String> get order {
    return _order;
  }

  List<ItemList> get itemList {
    return _itemList;
  }

  List<Map<String, String>> get secCatList {
    return _secCatList;
  }


//  -----------------------------------
//  Action

  var dio = Dio();

  Future<List<ItemList>> getItemList(i, height) async {
    List<ItemList> list;
    Response response;
    try{
      response = await dio.get("$baseUrl/items/32/all",
          queryParameters: {
            "offset": _offset,
            "limit": 30,
            'height': height,
            'cat1': _cat1['code'],
            'cat2': _cat2['code'],
            'qid': _qid,
            'fit1': _fit1,
            'option': _option,
            'keyword': _keyword,
            'hr': _hr,
            'pr': _pr['priceRange'],
            'order': _order['sortOrder']
          },
          options: Options(
              headers: {
                "Authorization" : i
              }));
      if(response.statusCode == 200) {
        this._totCnt = jsonDecode(response.data['result']['totCnt']);
        this._listCnt = jsonDecode(response.data['result']['listCnt']);
        var les = response.data['result']['itemList'];
        list = les.map<ItemList>((json) => ItemList.fromJson(json)).toList();
        if(this._offset == 0) {
          this._itemList = list;
        } else {
          this._itemList.addAll(list);
        }

        print('offset은?___ $_offset');
        print('상품리스트 매핑____$_itemList');
      }
    }catch(e) {
      print(e);
    }
    notifyListeners();
  }

  setOffset(i) async{
    this._offset = i;
    notifyListeners();
  }

  setQid(i) async{
    this._qid = i;
    notifyListeners();
  }

  resetItemList() async{
    this._itemList.clear();
    print('리스트 초기화함!$_itemList');
    notifyListeners();
  }

  setFirstCatSelect(i) async{
    this._cat1 = i;
    notifyListeners();
  }

  setSecCatList(i) async{
    this._secCatList = i;
    print('이게 세컨리스트$_secCatList');
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



}