import 'dart:async';

import 'package:fitchoo/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final ScrollController _searchScrollController = new ScrollController();
  final TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode;
  bool _isFocus = true;

  @override
  void initState() {
    super.initState();
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _isFocus = true;
        $item.setOffset(0);
        print('나갈때 카디비____${$item.offset}');
        $item.resetItemList();
        $item.setFirstCatSelect({'code': '000', 'name': '전체'});
        $item.setSecCatSelect({'code': '000', 'name': '전체'});
        $item.setFit({'fit1': "", 'name': "체형"});
        $item.setPrice({'priceRange': '0r4000000', 'name': '가격'});
        $item.setOrder({'sortOrder': 'de', 'name': '정렬'});
      }
    });
    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels == _searchScrollController.position.maxScrollExtent) {
        $item.setOffset($item.offset + 10);
        $item.getItemList($user.accessToken, $user.userHeight);
      } else {}
    });
  }

  // 폼이 삭제될 때 호출
  @override
  void dispose() {
    _onBackPressed();
    _searchFocusNode.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);

    return Scaffold(
      appBar: _searchAppBar($item, $user),
      body:
      _isFocus == true ?
        _searchSuggest() :
        _searchBody($item, img_url),
    );
  }

 Widget _searchAppBar($item, $user) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(5, 50, 5, 10),
          child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                  print(value);
                  $item.setSearch(value);
                  $item.setOffset(0);
                  $item.getItemList($user.accessToken, $user.userHeight);
                Timer(Duration(seconds: 1), () async{
                  setState(() {
                    this._isFocus = false;
                  });
                });
              },
              focusNode: _searchFocusNode,
              autofocus: false,
              controller: _searchController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black,),
                  suffixIcon: GestureDetector(
                      onTap: () {
                          FocusScope.of(context).unfocus();
                          _searchController.clear();
                          setState(() {
                            this._isFocus = true;
                          });
                      },
                      child: Icon(Icons.clear, color: Colors.black,)
                  ),
                  hintText: "검색 내용을 입력해주세요.",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20.0)))
          ),
        ),
      ),
    );
 }

 Widget _searchBody($item, img_url) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return WillPopScope(
              onWillPop: _onBackPressed,
              child: CustomScrollView(
                controller: _searchScrollController,
                slivers: <Widget>[
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
                ],
              )
          );
        }
    );
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
