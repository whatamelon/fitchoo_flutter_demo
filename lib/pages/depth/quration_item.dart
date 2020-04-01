import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';


class QurationItemPage extends StatefulWidget {
  @override
  _QurationItemPageState createState() => _QurationItemPageState();
}

class _QurationItemPageState extends State<QurationItemPage> {
  final ScrollController _qiscrollController = new ScrollController();
  final fkey = new GlobalKey();
  bool _isLoad = false;
  String _noMoreItem = '';
  
  Map<String, String> _tempFirstCat = {'code': '000', 'name': '전체'};
  Map<String, String> _tempSecCat = {'code': '000', 'name': '전체'};
  Map<String, String> _tempOrder = {'sortOrder': 'de', 'name': '정렬'};
  Map<String, String> _tempPrice = {'priceRange': '0r4000000', 'name': '가격'};
  Map<String, String> _tempFit = {'fit1': "", 'name': "체형"};

  String _filterIndex = '0';

  List _filters = [
    {'index': '0', 'name': "카테고리"},
    {'index': '2', 'name': "정렬"},
    {'index': '3', 'name': "가격"},
  ];

  List _filters2 = [
    {'index': '1', 'name': "체형"},
    {'index': '2', 'name': "정렬"},
    {'index': '3', 'name': "가격"},
  ];

  List _firstCateList = [
    {'code': "000", 'name': "전체"},
    {'code': "001", 'name': "아우터"},
    {'code': "002", 'name': "상의"},
    {'code': "005", 'name': "드레스"},
    {'code': "004", 'name': "스커트"},
    {'code': "003", 'name': "바지"},
    {'code': "006", 'name': "신발"},
    {'code': "007", 'name': "가방"},
    {'code': "008", 'name': "잡화"},
    {'code': "009", 'name': "쥬얼리"},
    {'code': "010", 'name': "비치웨어"},
    {'code': "011", 'name': "란제리/파자마"}
  ];

  List _fitList = [
    {'fit1': "ws", 'name': "어깨가 넓어요."},
    {'fit1': "tc", 'name': "종아리가 굵어요."},
    {'fit1': "fb", 'name': "배가 좀 나왔어요."},
    {'fit1': "tt", 'name': "허벅지가 좀 있는 편이에요."},
    {'fit1': "ns", 'name': "어깨가 좁아요."},
    {'fit1': "tf", 'name': "팔뚝에 살이 많아요."},
    {'fit1': "sn", 'name': "목이 짧은 편이에요."},
    {'fit1': "sl", 'name': "다리가 짧아요."},
    {'fit1': "np", 'name': "골반이 좁아요."},
    {'fit1': "bb", 'name': "가슴이 커요."},
    {'fit1': "tb", 'name': "가슴이 작아요."},
    {'fit1': "cl", 'name': "다리가 굽었어요."},
    {'fit1': "lf", 'name': "얼굴이 길어요."},
    {'fit1': "af", 'name': "얼굴이 각졌어요."},
    {'fit1': "rf", 'name': "얼굴이 동그래요."},
    {'fit1': "sb", 'name': "마른체형이에요."}
  ];

  List<Map<String, String>> allCat = [
    {'code': '000', 'name': '전체'}
  ];
  List<Map<String, String>> outerCat = [
    {'code': '000', 'name': '전체'},
    {'code': '001', 'name': '코트'},
    {'code': '002', 'name': '자켓'},
    {'code': '003', 'name': '점퍼'},
    {'code': '004', 'name': '가디건'}
  ];
  List<Map<String, String>> upperCat = [
    {'code': '000', 'name': '전체'},
    {'code': '001', 'name': '티셔츠'},
    {'code': '002', 'name': '니트'},
    {'code': '003', 'name': '블라우스/셔츠'},
    {'code': '004', 'name': '후드/맨투맨'},
    {'code': '005', 'name': '나시'}
  ];
  List<Map<String, String>> pantsCat = [
    {'code': '000', 'name': '전체'},
    {'code': '001', 'name': '청바지'},
    {'code': '002', 'name': '슬랙스'},
    {'code': '003', 'name': '숏팬츠'},
    {'code': '004', 'name': '레깅스'},
    {'code': '005', 'name': '롱팬츠'}
  ];
  List<Map<String, String>> skirtCat = [
    {'code': '000', 'name': '전체'}
  ];
  List<Map<String, String>> dressCat = [
    {'code': '000', 'name': '전체'}
  ];
  List<Map<String, String>> shoesCat = [
    {'code': '000', 'name': '전체'}
  ];
  List<Map<String, String>> bagCat = [
    {'code': '000', 'name': '전체'}
  ];
  List<Map<String, String>> accesoriescat = [
    {'code': '000', 'name': '전체'}
  ];
  List<Map<String, String>> jewelryCat = [
    {'code': '000', 'name': '전체'},
    {'code': '001', 'name': '귀걸이'},
    {'code': '002', 'name': '목걸이/팔찌'},
    {'code': '003', 'name': '반지'},
    {'code': '004', 'name': '기타'}
  ];
  List<Map<String, String>> beachwearCat = [
    {'code': '000', 'name': '전체'}
  ];
  List<Map<String, String>> lingerieCat = [
    {'code': '000', 'name': '전체'}
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

  @override
  void initState() {
    super.initState();
    print('큐레이션세부 들어왔어?');
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) => initialContents(context, $user, $item, $qurate));
    _qiscrollController.addListener(() {
      if (_qiscrollController.position.pixels == _qiscrollController.position.maxScrollExtent) {
        if($item.listCnt == 0) {
          this._isLoad = false;
          this._noMoreItem = '상품이 더 이상 없습니다.';
        } else {
          this._isLoad = true;
          print('ㅇㅋ1');
          Timer(Duration(seconds: 3), () async{
            setState(() {
              print('ㅇㅋ2r');
              this._isLoad = false;
            });
          });
          $item.setOffset($item.offset + 10);
          $item.getItemList($user.accessToken, $user.userHeight);
        }
      } else {
        print('ㅇㅋ3');
        this._isLoad = false;
      }
    });
  }

  void initialContents(context, $user, $item, $qurate) {
    $item.setSecCatList(allCat);
    $qurate.setActiveSecCat(allCat[0]);
    _tempFirstCat = {'code': '000', 'name': '전체'};
    _tempSecCat = {'code': '000', 'name': '전체'};

    $qurate.qitemId == '3' ? _filterIndex = '1' : _filterIndex = '0';
  }

  @override
  void dispose() {
    _qiscrollController.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    beforeRouteOut();
  }

  void beforeRouteOut() {
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    $item.setOffset(0);
    print('나갈때 카디비____${$item.offset}');
    $item.resetItemList();
    $qurate.resetQmodelList();
    $item.setFirstCatSelect({'code': '000', 'name': '전체'});
    $item.setSecCatSelect({'code': '000', 'name': '전체'});
    this._tempFirstCat = {'code': '000', 'name': '전체'};
    this._tempSecCat = {'code': '000', 'name': '전체'};
    this._tempOrder = {'sortOrder': 'de', 'name': '정렬'};
    this._tempPrice = {'priceRange': '0r4000000', 'name': '전체'};
    this._tempFit = {'fit1': "", 'name': "전체"};
    $item.setFit({'fit1': "", 'name': "체형"});
    $item.setPrice({'priceRange': '0r4000000', 'name': '가격'});
    $item.setOrder({'sortOrder': 'de', 'name': '정렬'});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    QurateState $qurate = Provider.of<QurateState>(context);
    UserState $user = Provider.of<UserState>(context);
    ItemState $item = Provider.of<ItemState>(context);
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        appBar: _qitemAppbar($qurate),
        body: _qitemBody($qurate, $user, $item, img_url),
      ),
    );
  }

 Widget _qitemAppbar($qurate) {
    return AppBar(
      leading: new IconButton(
      icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
      onPressed: () => _onBackPressed(),
      ),
      title: Text($qurate.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      centerTitle: true,
    );
 }

 Widget _qitemBody($qurate, $user, $item, img_url) {
    return
        CustomScrollView(
            controller: _qiscrollController,
            slivers: <Widget>[
              $qurate.qitemId == '1'
                  ? SliverAppBar(
//                pinned: true,
              snap:true,
                floating: true,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          _heightChange();
                        },
                        child: Text('내 키${$user.userHeight}cm')),
                    FlatButton(onPressed: () {}, child: Text('1cm 차이')),
                    FlatButton(onPressed: () {}, child: Text('3cm 차이')),
                    FlatButton(onPressed: () {}, child: Text('5cm 차이')),
                  ],
                ),
              )
                  :  SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(top: 1))),
              SliverAppBar(
                pinned: true,
                key: fkey,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    $qurate.qitemId == '3'
                        ? GestureDetector(
                      onTap: () {
                        _showCategory(
                            $qurate, $item, $user, context, '1');
                      },
                      child: $item.fit1 == ''
                          ? Chip(
                        backgroundColor: Colors.grey,
                        label: Text(
                          '체형',
                          style: TextStyle(color: Colors.black),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                      )
                          : Chip(
                        backgroundColor: Colors.black,
                        label: Text(
                          '${$item.fit1}',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        _showCategory(
                            $qurate, $item, $user, context, '0');
                      },
                      child: $item.cat1['code'] == '000'
                          ? Chip(
                        backgroundColor: Colors.grey,
                        label: Text('전체'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                      )
                          : $item.cat2['code'] == '000'
                          ? Chip(
                        backgroundColor: Colors.black,
                        label: Text(
                          '${_tempFirstCat['name']}',
                          style:
                          TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                      )
                          : Chip(
                        backgroundColor: Colors.black,
                        label: Text(
                          '${_tempSecCat['name']}',
                          style:
                          TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showCategory($qurate, $item, $user, context, '2');
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
                        _showCategory($qurate, $item, $user, context, '3');
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
                          onTap: () =>
                              print('$img_url${$item.itemList[index].imgFile}'),
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
                                              image: '$img_url${$item.itemList[index]
                                                  .imgFile}')),
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
                  )),
              SliverToBoxAdapter(
                child:
                $item.listCnt == 0 ?
                Center(child:Text(_noMoreItem, style: TextStyle(fontSize: 16))):
                Container(
                  height: 30,
                  child: _isLoad == true ? Center(child: CircularProgressIndicator()): Container(),
                )
              ),
            ]
        );

 }


  _showCategory($qurate, $item, $user, context, index) {
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
                          child: $qurate.qitemId == '3'
                              ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _filters2.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return new InkWell(
                                    onTap: () => _changeIndex(
                                        _filters2[index]['index'],
                                        setState),
                                    child: _filterIndex ==
                                        _filters2[index]['index']
                                        ? Text(
                                      '${_filters2[index]['name']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.grey),
                                    )
                                        : Text(
                                      '${_filters2[index]['name']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ));
                              })
                              : ListView.builder(
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
                              '0': (BuildContext context) => _buildCategory($qurate, $item, setState),
                              '1': (BuildContext context) => _buildBodyType($item),
                              '2': (BuildContext context) => _buildSort($item),
                              '3': (BuildContext context) => _buildPrice($item),
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
                                      this._tempFirstCat = {
                                        'code': '000',
                                        'name': '전체'
                                      };
                                      this._tempSecCat = {
                                        'code': '000',
                                        'name': '전체'
                                      };
                                      this._tempOrder = {
                                        'sortOrder': 'de',
                                        'name': '정렬'
                                      };
                                      this._tempPrice = {
                                        'priceRange': '0r4000000',
                                        'name': '전체'
                                      };
                                      this._tempFit = {
                                        'fit1': "",
                                        'name': "전체"
                                      };
                                      $item.setFit({'fit1': "", 'name': "전체"});
                                      $item.setPrice(this._tempPrice);
                                      $item.setOrder(this._tempOrder);
                                      $item.setSecCatList(this.allCat);
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
                                      $item.setFirstCatSelect(this._tempFirstCat);
                                      $item.setSecCatSelect(this._tempSecCat);
                                      $item.setFit(this._tempFit);
                                      $item.setPrice(this._tempPrice);
                                      $item.setOrder(this._tempOrder);
                                      $item.setOffset(0);
                                      $item.getItemList($user.accessToken, $user.userHeight);
                                      Scrollable.ensureVisible(fkey.currentContext);
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

  _heightChange() {
    print('키 바꿉니다잉~~~');
  }

  _changeIndex(i, StateSetter updateState) {
    updateState(() {
      print(i);
      this._filterIndex = i;
    });
  }

  Widget _buildCategory($qurate, $item, setState) {
    return this._tempFirstCat['code'] == '000'
        ? Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _firstCateList.length,
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
                onTap: () => _secCatChange(
                    _firstCateList[index], $qurate, $item, setState),
                child: Text(
                  '${_firstCateList[index]['name']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ));
          }),
    )
        : Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: $item.secCatList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () => _secCatSelect(
                    $item.secCatList[index], $item, setState),
                child: Text(
                  '${$item.secCatList[index]['name']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ));
          }),
    );
  }

  Widget _buildBodyType($item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: _fitList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 5),
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
              onTap: () => _orderChange(_fitList[index], $item, setState),
              child: _tempFit['fit1'] == _fitList[index]['fit1']
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
                      '${_fitList[index]['name']}',
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
                      '${_fitList[index]['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )),
              ),
            );
          }),
    );
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

  _secCatChange(i, $qurate, $item, StateSetter updateState) {
    print('일단 클릭확인! $i');
    $qurate.setActiveSecCat(i);
    updateState(() {
      this._tempFirstCat = i;
      this._tempSecCat = {'code': '000', 'name': '전체'};
      switch (i['code']) {
        case "000":
          $item.setSecCatList(this.allCat);
          break;
        case "001":
          $item.setSecCatList(this.outerCat);
          break;
        case "002":
          $item.setSecCatList(this.upperCat);
          break;
        case "003":
          $item.setSecCatList(this.pantsCat);
          break;
        case "004":
          $item.setSecCatList(this.skirtCat);
          break;
        case "005":
          $item.setSecCatList(this.dressCat);
          break;
        case "006":
          $item.setSecCatList(this.shoesCat);
          break;
        case "007":
          $item.setSecCatList(this.bagCat);
          break;
        case "008":
          $item.setSecCatList(this.accesoriescat);
          break;
        case "009":
          $item.setSecCatList(this.jewelryCat);
          break;
        case "010":
          $item.setSecCatList(this.beachwearCat);
          break;
        case "011":
          $item.setSecCatList(this.lingerieCat);
          break;
      }
    });
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

  _secCatSelect(i, $item, StateSetter updateState) {
    print('일단 클릭확인22 $i');
    updateState(() {
      this._tempSecCat = i;
    });
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
}
