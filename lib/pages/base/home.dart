import 'package:fitchoo/pages/depth/quration_id.dart';
import 'package:fitchoo/states/qurate_state.dart';
import 'package:fitchoo/states/user_state.dart';
import 'package:fitchoo/states/item_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    UserState $user = Provider.of<UserState>(context, listen: false);
    QurateState $qurate = Provider.of<QurateState>(context, listen: false);
    ItemState $item = Provider.of<ItemState>(context, listen: false);
    $qurate.getQurateList($user.accessToken);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        $qurate.setQOffset($qurate.qOffset + 10);
        $qurate.getQurateList($user.accessToken);
      } else {}
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final $qurate = Provider.of<QurateState>(context);
    final $user = Provider.of<UserState>(context);
    final $item = Provider.of<ItemState>(context);
    List<QitemList> qurations = $qurate.qitemList;
    final String img_url =
        "https://s3.ap-northeast-2.amazonaws.com/image.fitchoo";
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildHomeBody($qurate, img_url, qurations, $user, $item),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Image.asset(
        'assets/black_logo.png',
        width: 120,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.favorite_border), iconSize: 22, onPressed: () {}),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 10, 0),
          child: IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildHomeBody($qurate, img_url, qurations, $user, $item) {
    return ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  '인기 큐레이션',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemExtent: 220,
                  itemBuilder: (context, index) {
                    return _buildPopCards(
                        $qurate, img_url, index, $user, $item);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  '새로운 큐레이션',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemExtent: 220,
                  itemBuilder: (context, index) {
                    return _buildnewCards(
                        $qurate, img_url, index, $user, $item);
                  },
                ),
              ),
              Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: qurations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Hero(
                        tag: 'i${$qurate.qitemList[index].iimgItemFile}',
                        child: new Material(
                          color: Colors.transparent,
                          child: new InkWell(
                              splashColor: Colors.white,
                              onTap: () async {
                                $qurate.switchHero('i');
                                $qurate.setQItemid(qurations[index].iqitemId);
                                $qurate.setImgItemFile(
                                    qurations[index].iimgItemFile);
                                $qurate.setImgFaceFile(
                                    qurations[index].iimgFaceFile);
                                $qurate
                                    .setQUsername(qurations[index].iquserName);
                                $qurate.setQTitle(qurations[index].ititle);
                                $qurate.setQBody(qurations[index].ibody);
                                await $qurate.getQurateInfo($user.accessToken);
                                $item.setQid(qurations[index].iqitemId);
                                await $item.getItemList($user.accessToken, $user.userHeight);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        QurationIdPage()));
                                print('홈나갔어?');
                              },
                              child: _buildItemCard(qurations, img_url, index)),
                        ),
                      );
                    }),
              )
            ],
          ),
        ]);
  }

  Widget _buildPopCards($qurate, img_url, index, $user, $item) {
    return Hero(
      tag: 'p${$qurate.qpopList[index].pimgItemFile}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () async {
            $qurate.switchHero('p');
            $qurate.setQItemid($qurate.qpopList[index].pqitemId);
            $qurate.setImgItemFile($qurate.qpopList[index].pimgItemFile);
            $qurate.setImgFaceFile($qurate.qpopList[index].pimgFaceFile);
            $qurate.setQUsername($qurate.qpopList[index].pquserName);
            $qurate.setQTitle($qurate.qpopList[index].ptitle);
            $qurate.setQBody($qurate.qpopList[index].pbody);
            await $qurate.getQurateInfo($user.accessToken);
            $item.setQid($qurate.qpopList[index].pqitemId);
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
                              '$img_url${$qurate.qpopList[index].pimgItemFile}')),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    '${$qurate.qpopList[index].ptitle}',
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

  Widget _buildnewCards($qurate, img_url, int index, $user, $item) {
    return Hero(
      tag: 'n${$qurate.qnewList[index].nimgItemFile}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () async{
            $qurate.switchHero('n');
            $qurate.setQItemid($qurate.qnewList[index].nqitemId);
            $qurate.setImgItemFile($qurate.qnewList[index].nimgItemFile);
            $qurate.setImgFaceFile($qurate.qnewList[index].nimgFaceFile);
            $qurate.setQUsername($qurate.qnewList[index].nquserName);
            $qurate.setQTitle($qurate.qnewList[index].ntitle);
            $qurate.setQBody($qurate.qnewList[index].nbody);
            await $qurate.getQurateInfo($user.accessToken);
            $item.setQid($qurate.qnewList[index].nqitemId);
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
                              '$img_url${$qurate.qnewList[index].nimgItemFile}')),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    '${$qurate.qnewList[index].ntitle}',
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

  Widget _buildItemCard(qurations, img_url, index) {
    return Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FadeInImage.memoryNetwork(
                fit: BoxFit.fitWidth,
                width: 300,
                height: 225,
                placeholder: kTransparentImage,
                image: '$img_url${qurations[index].iimgItemFile}'),
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
                                  '$img_url${qurations[index].iimgFaceFile}',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Curated by',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  qurations[index].iquserName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '상품업데이트 4시간전',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black26),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    qurations[index].ititle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    qurations[index].ibody,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
