import 'dart:async';

import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final skey = new GlobalKey();
  final ScrollController _searchScrollController = new ScrollController();
  final TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode;
  String _isFirst = '0';
  bool _isFocus = false;
  bool _isLoad = false;
  String _noMoreItem = '';
  Map<String, String> _tempOrder = {'sortOrder': 'de', 'name': '정렬'};
  Map<String, String> _tempPrice = {'priceRange': '0r4000000', 'name': '가격'};

  List<String> _recentLists = [];

  List _filters = [
    {'index': '2', 'name': "정렬"},
    {'index': '3', 'name': "가격"},
  ];

  List<Map<String, String>> _orderList = [
    {'sortOrder': "dr", 'name': "최신순"},
    {'sortOrder': "pl", 'name': "가격 낮은순"},
    {'sortOrder': "ph", 'name': "가격 높은순"}
  ];

  List<Map<String, String>> _priceList = [
    {'priceRange': "0r20000", 'name': "2만원 이하"},
    {'priceRange': "20000r50000", 'name': "2~5만원"},
    {'priceRange': "50000r100000", 'name': "5~10만원"},
    {'priceRange': "100000r4000000", 'name': "10만원 이상"}
  ];
  String _filterIndex = '0';

  @override
  void initState() {
    super.initState();
    print('검색드루와써');
    _openbox();
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        print('이거?');
        setState(() {
          this._isFirst = '1';
          this._isFocus = true;
        });
        $item.setOffset(0);
        print('이건 카디비____${$item.offset}');
        $item.resetItemList();
        $item.setPrice({'priceRange': '0r4000000', 'name': '가격'});
        $item.setOrder({'sortOrder': 'de', 'name': '정렬'});
      }
    });
    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels == _searchScrollController.position.maxScrollExtent) {
        if($item.listCnt == 0) {
          this._isLoad = false;
          this._noMoreItem = '상품이 더 이상 없습니다.';
        } else {
          this._isLoad = true;
          print('ㅇㅋ1___$_isLoad');
          Timer(Duration(seconds: 3), () async{
            setState(() {
              print('ㅇㅋ2r___$_isLoad');
              this._isLoad = false;
            });
          });
          $item.setOffset($item.offset + 10);
          $item.getItemList($user.accessToken, $user.userHeight);
        }
      } else {
        print('ㅇㅋ3__$_isLoad');
        this._isLoad = false;
      }
    });
  }

  Future _openbox() async{
    final prefs = await SharedPreferences.getInstance();
    this._recentLists = prefs.getStringList('searchList');
    return this._recentLists;
  }

  @override
  void dispose() {
    setState(() {
      this._isFirst = '0';
      this._isFocus = false;
    });
    _onBackPressed();
    _searchFocusNode.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);

    return Scaffold(
      appBar: _searchAppBar($item, $user, size),
      body:
      _isFirst == '0'?
        _searchSuggest() :
      _isFirst == '1'?
        _recentList($item, $user):
        _searchBody($item, img_url, $user),
    );
  }

 Widget _searchAppBar($item, $user, size) {
    return PreferredSize(
      preferredSize: _isFirst == '0' && _isFocus != true ? Size.fromHeight(120): Size.fromHeight(70),
      child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Padding(
            padding: EdgeInsets.fromLTRB(5, 40, 5, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom:5),
                  child: AnimatedContainer(
                    height: _isFirst == '0' && _isFocus != true ? 30 : 0,
                    alignment: Alignment.center,
                    duration: Duration(milliseconds: 30),
                    curve: Curves.fastOutSlowIn,
                    child: Text('검색', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AnimatedContainer(
                      width: _isFirst == '0' && _isFocus != true ? size.width : size.width-60,
                      height: 50,
                      duration: Duration(milliseconds: 30),
                      curve: Curves.fastOutSlowIn,
                      child: TextField(
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            _searchGo(value, $item, $user);
                          },
                          focusNode: _searchFocusNode,
                          autofocus: false,
                          controller: _searchController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.black,),
                              hintText: "검색 내용을 입력해주세요.",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(20.0)))
                      ),
                    ),
                    Visibility(
                      visible: _isFirst != '0',
                      child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _searchController.clear();
                            setState(() {
                              this._isFocus = false;
                              this._isFirst = '0';
                            });
                          },
                        child: Text('취소' ,style: TextStyle(fontWeight: FontWeight.bold),)
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
      ),
    );
 }

 Widget _searchBody($item, img_url, $user) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return WillPopScope(
              onWillPop: _onBackPressed,
              child: CustomScrollView(
                controller: _searchScrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    key: skey,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _showCategory($item, $user, context, '0');
                          },
                          child: $item.order['sortOrder'] == 'de'
                              ? Chip(
                            backgroundColor: Colors.grey,
                            label: Text('정렬'),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                          )
                              : Chip(
                            backgroundColor: Colors.black,
                            label: Text(
                              '${_tempOrder['name']}',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showCategory($item, $user, context, '1');
                          },
                          child: $item.pr['priceRange'] == '0r4000000'
                              ? Chip(
                            backgroundColor: Colors.grey,
                            label: Text('가격'),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                          )
                              : Chip(
                            backgroundColor: Colors.black,
                            label: Text(
                              '${_tempPrice['name']}',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 3,
                          childAspectRatio: 0.5),
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => print('$img_url${$item.itemList[index].imgFile}'),
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
                                            child: FadeInImage.memoryNetwork(
                                                fit: BoxFit.cover,
                                                width: 120,
                                                height: 160,
                                                placeholder: kTransparentImage,
                                                image:'$img_url${$item.itemList[index].imgFile}')),
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
                                        ),
                                        Positioned(
                                            top: 3,
                                            right: 4,
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.grey,
                                              size: 25,
                                            )),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                    ),
                                    Text(
                                      _fixPrice($item.itemList[index].price),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      $item.itemList[index].name,
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
                        childCount: $item.itemList.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child:
                      $item.listCnt == 0 ?
                      Center(child:Text(_noMoreItem, style: TextStyle(fontSize: 16))):
                      Container(
                        height: 30,
                        width:30,
                        child: _isLoad == true ? Center(child: CircularProgressIndicator()): Container(),
                      )
                  ),
                ],
              )
          );
        }
    );
 }


  _showCategory($item, $user, context, index) {
    print('카테고리 클릭!');
    this._filterIndex = index;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 600,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        Container(
                          height: 70,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _filters.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return new InkWell(
                                    onTap: () => _changeIndex(_filters[index]['index'], setState),
                                    child: _filterIndex == _filters[index]['index']
                                        ? Text(
                                      '${_filters[index]['name']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.grey),
                                    )
                                        : Text(
                                      '${_filters[index]['name']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ));
                              }),
                        ),
                        ConditionalSwitch.single<String>(
                            context: context,
                            valueBuilder: (BuildContext context) => _filterIndex,
                            caseBuilders: {
                              '0': (BuildContext context) => _buildSort($item),
                              '1': (BuildContext context) => _buildPrice($item),
                            }),
                      ],
                    ),
                    Positioned(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                          child: Row(
                            children: <Widget>[
                              ButtonTheme(
                                minWidth: 50,
                                height: 50,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                                  color: Colors.black12,
                                  splashColor: Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      this._tempOrder = {
                                        'sortOrder': 'de',
                                        'name': '정렬'
                                      };
                                      this._tempPrice = {
                                        'priceRange': '0r4000000',
                                        'name': '전체'
                                      };
                                      $item.setPrice(this._tempPrice);
                                      $item.setOrder(this._tempOrder);
                                    });
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              Expanded(
                                child: ButtonTheme(
                                  minWidth: 200,
                                  height: 50,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    splashColor: Colors.redAccent,
                                    color: Colors.red,
                                    child: Text(
                                      '적용',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    onPressed: () {
                                      $item.setPrice(this._tempPrice);
                                      $item.setOrder(this._tempOrder);
                                      $item.setOffset(0);
                                      $item.getItemList($user.accessToken, $user.userHeight);
                                      Scrollable.ensureVisible(skey.currentContext);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }


  Widget _buildSort($item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GridView.builder(
//                    physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _orderList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 5),
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
              onTap: () => _orderChange(_orderList[index], $item, setState),
              child: _tempOrder['sortOrder'] == _orderList[index]['sortOrder']
                  ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 3),
                    color: Colors.black),
                child: Center(
                    child: Text(
                      '${_orderList[index]['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    )),
              )
                  : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 3)),
                child: Center(
                    child: Text(
                      '${_orderList[index]['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )),
              ),
            );
          }),
    );
  }

  Widget _buildPrice($item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: _priceList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 5),
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
              onTap: () => _priceChange(_priceList[index], $item, setState),
              child: _tempPrice['priceRange'] == _priceList[index]['priceRange']
                  ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 3),
                    color: Colors.black),
                child: Center(
                    child: Text(
                      '${_priceList[index]['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    )),
              )
                  : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 3)),
                child: Center(
                    child: Text(
                      '${_priceList[index]['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )),
              ),
            );
          }),
    );
  }

  _orderChange(i, $item, StateSetter updateState) {
    print('정렬 바꿉니다잉~~~');
    updateState(() {
      this._tempOrder = i;
    });
  }

  _priceChange(i, $item, StateSetter updateState) {
    print('가격 바꿉니다잉~~~');
    updateState(() {
      this._tempPrice = i;
    });
  }

  _changeIndex(i, StateSetter updateState) {
    updateState(() {
      print(i);
      this._filterIndex = i;
    });
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

 Widget _searchSuggest() {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Text('홀로롤로롤롤로로로')
    );
 }

  Widget _recentList($item, $user) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: ListView.builder(
          itemCount: _recentLists.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                leading: Icon(Icons.search),
                trailing: Text('삭제'),
                title: Text(_recentLists[i]),
                onTap: () {
                  _searchGo(_recentLists[i], $item, $user);
                },
              );
            }
        )
    );
  }

  void _searchGo(String value, $item, $user) async  {
    _searchController.text = value;
    FocusScope.of(context).unfocus();
      final pref = await SharedPreferences.getInstance();
      var sList =  pref.getStringList('searchList');
      if(sList == null) {
        pref.setStringList('searchList', []);
        sList = [];
      }
      if(sList.length == 20) {
        sList.removeLast();
      }
      print(sList);
      sList.insert(0, value);
      var newslist = sList.toSet().toList();
      print(newslist);

      setState(() {
        this._recentLists = newslist;
      });

      pref.setStringList('searchList', newslist);

      print(value);
      $item.setSearch(value);
      $item.setOffset(0);
      $item.getItemList($user.accessToken, $user.userHeight);
      Timer(Duration(milliseconds: 30), () async{
        setState(() {
          this._isFirst = '2';
          this._isFocus = false;
        });
        print(this._isFirst);
        print(this._isFocus);
      });
    }



  Future<bool> _onBackPressed() {
    beforeRouteOut();
  }

  void beforeRouteOut() {
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    $item.setOffset(0);
    print('나갈때 카디비____${$item.offset}');
    $item.resetItemList();
    $item.setFirstCatSelect({'code': '000', 'name': '전체'});
    $item.setSecCatSelect({'code': '000', 'name': '전체'});
    $item.setFit({'fit1': "", 'name': "체형"});
    $item.setPrice({'priceRange': '0r4000000', 'name': '가격'});
    $item.setOrder({'sortOrder': 'de', 'name': '정렬'});
//    this._tempFirstCat = {'code': '000', 'name': '전체'};
//    this._tempSecCat = {'code': '000', 'name': '전체'};
//    this._tempOrder = {'sortOrder': 'de', 'name': '정렬'};
//    this._tempPrice = {'priceRange': '0r4000000', 'name': '전체'};
//    this._tempFit = {'fit1': "", 'name': "전체"};
    Navigator.pop(context);
  }
}
