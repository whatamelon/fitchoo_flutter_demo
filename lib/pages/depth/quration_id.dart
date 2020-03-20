import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class QurationIdPage extends StatefulWidget {

  @override
  _QurationIdPageState createState() => _QurationIdPageState();
}

class _QurationIdPageState extends State<QurationIdPage> {
  final GlobalKey<AnimatedListState> _aniKey = GlobalKey();
  final dataKey = new GlobalKey();
  final ScrollController _scrollController = new ScrollController();
  Map<String, String> _tempFirstCat = {'code': '000','name': '전체'};
  Map<String, String> _tempSecCat = {'code': '000','name': '전체'};
  Map<String, String> _tempOrder = {'sortOrder': 'de','name': '정렬'};
  Map<String, String> _tempPrice = {'priceRange': '0r4000000','name': '전체'};


  List _firstCateList = [
    { 'code': "000", 'name': "전체" },
    { 'code': "001", 'name': "아우터" },
    { 'code': "002", 'name': "상의" },
    { 'code': "005", 'name': "드레스" },
    { 'code': "004", 'name': "스커트" },
    { 'code': "003", 'name': "바지" },
    { 'code': "006", 'name': "신발" },
    { 'code': "007", 'name': "가방" },
    { 'code': "008", 'name': "잡화" },
    { 'code': "009", 'name': "쥬얼리" },
    { 'code': "010", 'name': "비치웨어" },
    { 'code': "011", 'name': "란제리/파자마" }
  ];

  List<Map<String,String>> allCat = [{'code': '000', 'name': '전체'}];
  List<Map<String,String>>  outerCat = [{'code': '000', 'name': '전체'},{'code': '001', 'name': '코트'},
    {'code': '002', 'name': '자켓'},{'code': '003', 'name': '점퍼'},{'code': '004', 'name': '가디건'}];
  List<Map<String,String>>  upperCat = [{'code': '000', 'name': '전체'},{'code': '001', 'name': '티셔츠'},{'code': '002', 'name': '니트'},
    {'code': '003', 'name': '블라우스/셔츠'},{'code': '004', 'name': '후드/맨투맨'},{'code': '005', 'name': '나시'}];
  List<Map<String,String>>  pantsCat = [{'code': '000', 'name': '전체'},{'code': '001', 'name': '청바지'},{'code': '002', 'name': '슬랙스'},
    {'code': '003', 'name': '숏팬츠'},{'code': '004', 'name': '레깅스'},{'code': '005', 'name': '롱팬츠'}];
  List<Map<String,String>>  skirtCat = [{'code': '000', 'name': '전체'}];
  List<Map<String,String>>  dressCat = [{'code': '000', 'name': '전체'}];
  List<Map<String,String>>  shoesCat = [{'code': '000', 'name': '전체'}];
  List<Map<String,String>>  bagCat = [{'code': '000', 'name': '전체'}];
  List<Map<String,String>>  accesoriescat = [{'code': '000', 'name': '전체'}];
  List<Map<String,String>>  jewelryCat = [{'code': '000', 'name': '전체'},{'code': '001', 'name': '귀걸이'},
    {'code': '002', 'name': '목걸이/팔찌'},{'code': '003', 'name': '반지'},{'code': '004', 'name': '기타'}];
  List<Map<String,String>>  beachwearCat = [{'code': '000', 'name': '전체'}];
  List<Map<String,String>>  lingerieCat = [{'code': '000', 'name': '전체'}];


  List<Map<String, String>> _orderList = [
    { 'sortOrder': "de", 'name': "정렬" },
    { 'sortOrder': "dr", 'name': "최신순" },
    { 'sortOrder': "pl", 'name': "가격 낮은순" },
    { 'sortOrder': "ph", 'name': "가격 높은순" }];

  List<Map<String, String>> _priceList = [
    { 'priceRange': "0r4000000", 'name':"전체" },
    { 'priceRange': "0r20000", 'name':"2만원 이하" },
    { 'priceRange': "20000r50000", 'name':"2~5만원" },
    { 'priceRange': "50000r100000", 'name':"5~10만원" },
    { 'priceRange': "100000r4000000", 'name':"10만원 이상" }];

  @override
  void initState() {
    super.initState();
    UserState $user = Provider.of<UserState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);

    $item.setSecCatList(allCat);
    $qurate.setActiveSecCat(allCat[0]);
    _tempFirstCat = {'code': '000','name': '전체'};
    _tempSecCat = {'code': '000','name': '전체'};

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        $item.setOffset($item.offset + 10);
        $item.getItemList($user.accessToken, $user.userHeight);
      } else {
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final String img_url = "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    QurateState $qurate = Provider.of<QurateState>(context);
    UserState $user = Provider.of<UserState>(context);
    ItemState $item = Provider.of<ItemState>(context);
    return Scaffold(
      body: _buildBody($qurate, img_url, $item, $user),
    );
  }

 Widget _buildBody($qurate, img_url, $item, $user) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            top: true,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: constraints.maxHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Hero(
                                tag: _switchHero($qurate),
                                child: Stack(
                                  children:<Widget>[
                                    Image.network('$img_url${$qurate.imgItemFile}',fit: BoxFit.fitWidth,),
                                    Positioned(
                                      top:5,
                                      right:5,
                                      child: Transform.rotate(
                                        angle: 45 * pi / 180,
                                        child: Opacity(
                                          opacity: 0.7,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: IconButton(
                                                icon: Icon(Icons.add_circle, color:Colors.black,size: 35,),
                                                onPressed: (){
                                                  $item.setOffset(0);
                                                  $item.resetItemList();
                                                  Navigator.pop(context);}),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 18, 12, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(right: 8),
                                              child: ClipOval(
                                                child: Image.network(
                                                  '$img_url${$qurate.imgFaceFile}',
                                                  width: 45,
                                                  height: 45,
                                                  fit: BoxFit.cover,),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Curated by', style: TextStyle(fontSize: 12, color: Colors.grey),),
                                                Text($qurate.quserName, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),),
                                              ],
                                            )
                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text('상품업데이트 4시간전', style: TextStyle(fontSize: 13, color: Colors.black26),)
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    $qurate.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10),),
                                  Container(
                                    child: Text(
                                      $qurate.body,
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top:20),
                              height:120.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: $qurate.qmodelList.length,
                                itemExtent: 70,
                                itemBuilder: (context, index) {
                                  return _buildModels($qurate, img_url, index);
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                if($qurate.qitemId == '1')
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  title: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          _heightChange();
                        },
                        child: Text('내 키${$user.userHeight}cm')),
                      FlatButton(
                          onPressed: () {

                          },
                          child: Text('1cm 차이')),
                      FlatButton(
                          onPressed: () {

                          },
                          child: Text('3cm 차이')),
                      FlatButton(
                          onPressed: () {

                          },
                          child: Text('5cm 차이')),
                    ],
                  ),
                ),
                SliverAppBar(
                  key: dataKey,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      $qurate.qitemId == '3' ?
                        GestureDetector(
                          onTap: () {
                            _showBodytypeFilter($item, $user);
                          },
                          child: Chip(
                            label : Text('체형'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          ),
                        ) :
                        GestureDetector(
                          onTap: () {
                            _showCategory($qurate, $item, $user, context);
                          },
                          child:
                          _tempFirstCat['code'] == '000' ?
                          Chip(
                            backgroundColor: Colors.grey,
                            label : Text('전체'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          ) :
                          $item.cat2['code'] == '000' ?
                            Chip(
                              backgroundColor: Colors.black,
                              label : Text('${_tempFirstCat['name']}', style: TextStyle(color:Colors.white),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ):
                            Chip(
                              backgroundColor: Colors.black,
                              label :Text('${_tempSecCat['name']}', style: TextStyle(color:Colors.white),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                        ),
                      Padding(padding: EdgeInsets.only(right: 20),),
                      GestureDetector(
                        onTap: () {
                          _showFilter($item, $user);
                        },
                        child:
                        _tempOrder['sortOrder'] == 'de' ?
                        Chip(
                          backgroundColor: Colors.grey,
                          label : Text('정렬'),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ):
                        Chip(
                          backgroundColor: Colors.black,
                          label : Text('${_tempOrder['name']}', style: TextStyle(color:Colors.white),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 20),),
                      GestureDetector(
                        onTap: () {
                          _showFilter($item, $user);
                        },
                        child:
                        _tempPrice['priceRange'] == '0r4000000' ?
                        Chip(
                          backgroundColor: Colors.grey,
                          label : Text('가격'),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ):
                        Chip(
                          backgroundColor: Colors.black,
                          label : Text('${_tempPrice['name']}', style: TextStyle(color:Colors.white),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                  pinned: true,
                ),
                SliverPadding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 3,
                        childAspectRatio: 0.5
                    ),
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return Card(
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
                                          image: '$img_url${$item.itemList[index].imgFile}'
                                      )
                                  ),
                                  Positioned(
                                    top: 5,
                                    left: 5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(Radius.circular(3))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                                        child: Text('N', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 3,
                                      right: 4,
                                      child: Icon(Icons.favorite, color: Colors.grey, size: 25,)
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:12),
                              ),
                              Text(
                                _fixPrice($item.itemList[index].price),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                              Text(
                                $item.itemList[index].name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.grey, fontSize: 11,),),
                            ],
                          )
                      );
                    },
                      childCount: $item.itemList.length,
                    ),
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
     if($qurate.qSwitchHero == 'i') {
       return 'i${$qurate.imgItemFile}';
     } else if($qurate.qSwitchHero == 'p') {
       return 'p${$qurate.imgItemFile}';
     } else {
       return 'n${$qurate.imgItemFile}';
     }
 }

 _fixPrice(i) {
    int _index = 0;
    if(i.length == 11) {
      _index = 3;
      i = i.substring(0,6);
    }else if(i.length == 10) {
      _index = 2;
      i = i.substring(0,5);
    }else if(i.length == 9) {
      _index = 1;
      i = i.substring(0,4);
    }else {
      return i;
    }
    return i.substring(0,_index)+","+i.substring(_index);
  }


  Future<bool> _onBackPressed() {
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    $item.setOffset(0);
    $item.resetItemList();
    $item.setFirstCatSelect('000');
    $item.setSecCatSelect('000');
    _tempFirstCat = {'code': '000','name': '전체'};
    _tempSecCat = {'code': '000','name': '전체'};
    Navigator.pop(context);
  }

  _showCategory($qurate, $item, $user, context) {
    print('카테고리 클릭!');
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20)
          )
        ),
        context: context,
        builder: (context){
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
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                    child: Text('카테고리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: _firstCateList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 5
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return $qurate.activeFirstCat.indexOf(_firstCateList[index]['code']) == -1 ?
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 3),
                                color: Colors.grey
                            ),
                            child: Center(child: Text('${_firstCateList[index]['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),)),
                          ):
                          new InkWell(
                            onTap: () => _secCatChange(_firstCateList[index], $qurate, $item, setState),
                            child:
                            _tempFirstCat['code'] == _firstCateList[index]['code'] ?
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3),
                                  color: Colors.black
                              ),
                              child: Center(child: Text('${_firstCateList[index]['name']}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),)),
                            ) :
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3)
                              ),
                              child: Center(child: Text('${_firstCateList[index]['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                            ),
                          );
                        }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(color: Colors.black,),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: $item.secCatList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 5
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return $qurate.activeSecCat.indexOf($item.secCatList[index]['code']) == -1 ?
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 3),
                                color: Colors.grey
                            ),
                            child: Center(child: Text('${$item.secCatList[index]['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color:Colors.black),)),):
                            InkWell(
                            onTap: () => _secCatSelect($item.secCatList[index], $item, setState),
                            child:
                            _tempSecCat['code'] == $item.secCatList[index]['code'] ?
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3),
                                color: Colors.black
                              ),
                              child: Center(child: Text('${$item.secCatList[index]['name']}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color:Colors.white),)),):
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3)
                              ),
                              child: Center(child: Text('${$item.secCatList[index]['name']}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),),
                          );
                        }
                    ),
                  ),
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
                            height:50,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                              ),
                              color: Colors.black12,
                              splashColor: Colors.grey,
                              onPressed: () {
                                setState(() {
                                  this._tempFirstCat = {'code': '000','name': '전체'};
                                  this._tempSecCat = {'code': '000','name': '전체'};
                                  $item.setSecCatList(this.allCat);
                                });
                              },
                              child: Icon(Icons.refresh, color: Colors.grey, size: 25,),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right:10)),
                          Expanded(
                            child: ButtonTheme(
                              minWidth: 200,
                              height: 50,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                splashColor: Colors.redAccent,
                                color: Colors.red,
                                child: Text('적용', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold,fontSize: 20),),
                                onPressed: () {
                                  $item.setFirstCatSelect(this._tempFirstCat);
                                  $item.setSecCatSelect(this._tempSecCat);
                                  $item.setOffset(0);
                                  $item.getItemList($user.accessToken, $user.userHeight);
                                  Scrollable.ensureVisible(dataKey.currentContext);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )],
            ),
          );
        },
      );
    });
  }

  void _showFilter($item, $user) {
    print('필터 클릭!');
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        context: context,
        builder: (context){
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
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                          child: Text('카테고리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: GridView.builder(
//                    physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _orderList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 5
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return new InkWell(
                                  onTap: () => _orderChange(_orderList[index], $item, setState),
                                  child:
                                  _tempOrder['sortOrder'] == _orderList[index]['sortOrder'] ?
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3),
                                        color: Colors.black
                                    ),
                                    child: Center(child: Text('${_orderList[index]['name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),)),
                                  ) :
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3)
                                    ),
                                    child: Center(child: Text('${_orderList[index]['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                                  ),
                                );
                              }
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(color: Colors.black,),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: GridView.builder(
//                      physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _priceList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 5
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return new InkWell(
                                  onTap: () => _priceChange(_priceList[index], $item, setState),
                                  child:
                                  _tempPrice['priceRange'] == _priceList[index]['priceRange'] ?
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3),
                                        color: Colors.black
                                    ),
                                    child: Center(child: Text('${_priceList[index]['name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color:Colors.white),)),):
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black, style: BorderStyle.solid, width: 3)
                                    ),
                                    child: Center(child: Text('${_priceList[index]['name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),),
                                );
                              }
                          ),
                        ),
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
                                height:50,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8))
                                  ),
                                  color: Colors.black12,
                                  splashColor: Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      this._tempOrder = {'sortOrder': 'de','name': '정렬'};
                                      this._tempPrice = {'priceRange': '0r4000000','name': '전체'};
                                      $item.setOrder(this._tempOrder);
                                      $item.setPrice(this._tempPrice);
                                    });
                                  },
                                  child: Icon(Icons.refresh, color: Colors.grey, size: 25,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right:10)),
                              Expanded(
                                child: ButtonTheme(
                                  minWidth: 200,
                                  height: 50,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                    ),
                                    splashColor: Colors.redAccent,
                                    color: Colors.red,
                                    child: Text('적용', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold,fontSize: 20),),
                                    onPressed: () {
                                      $item.setOrder(this._tempOrder);
                                      $item.setPrice(this._tempPrice);
                                      $item.setOffset(0);
                                      $item.getItemList($user.accessToken, $user.userHeight);
                                      Scrollable.ensureVisible(dataKey.currentContext);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )],
                ),
              );
            },
          );
        });
  }

  void _showBodytypeFilter($item, $user) {
    print('체형 & 필터 클릭!');
  }

  _secCatChange(i, $qurate, $item, StateSetter updateState) {
    print('일단 클릭확인! $i');
    $qurate.setActiveSecCat(i);
    updateState(() {
      this._tempFirstCat = i;
      this._tempSecCat = {'code': '000','name': '전체'};
      switch (i['code']) {
        case "000" :
          $item.setSecCatList(this.allCat);
          break;
        case "001" :
          $item.setSecCatList(this.outerCat);
          break;
        case "002" :
          $item.setSecCatList(this.upperCat);
          break;
        case "003" :
          $item.setSecCatList(this.pantsCat);
          break;
        case "004" :
          $item.setSecCatList(this.skirtCat);
          break;
        case "005" :
          $item.setSecCatList(this.dressCat);
          break;
        case "006" :
          $item.setSecCatList(this.shoesCat);
          break;
        case "007" :
          $item.setSecCatList(this.bagCat);
          break;
        case "008" :
          $item.setSecCatList(this.accesoriescat);
          break;
        case "009" :
          $item.setSecCatList(this.jewelryCat);
          break;
        case "010" :
          $item.setSecCatList(this.beachwearCat);
          break;
        case "011" :
          $item.setSecCatList(this.lingerieCat);
          break;
      }
    });
  }

  _secCatSelect(i, $item, StateSetter updateState) {
    print('일단 클릭확인22 $i');
    updateState(() {
      this._tempSecCat = i;
    });
  }

  Widget _buildModels($qurate, img_url, index) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          ClipOval(
            child: Image.network('$img_url${$qurate.qmodelList[index].imgFaceFile}',
                fit:BoxFit.fitWidth, width: 60, height:60)),
          Text('${$qurate.qmodelList[index].name}', style: TextStyle(fontSize: 12),)
        ],
      ),
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

  _heightChange() {

  }

}
