import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:like_this/api/Api.dart';
import 'package:like_this/util/HttpUtil.dart';
import 'package:like_this/gson/home_title_avatar_entity.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageIndex();
  }
}

class HomePageIndex extends State<HomePage> {
  var _items;

  final List<HomeTabList> myTabs = <HomeTabList>[
    new HomeTabList('推荐', new Container()),
    new HomeTabList('附近', new Container()),
    new HomeTabList('关注', new Container())
  ];

  Widget _widget_menu_card(BuildContext contexts) {
    return new SliverToBoxAdapter(
      child: new Wrap(
        alignment: WrapAlignment.end,
        children: <Widget>[home_top_menu(contexts)],
      ),
    );
  }

  @override
  Widget build(BuildContext contexts) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _widget_menu_card(contexts),
              SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child: SliverAppBar(
                      backgroundColor: Colors.transparent,
                      pinned: true,
                      forceElevated: innerBoxIsScrolled,
                      title: TabBar(
                        indicatorColor: Color(0xff4ddfa9),
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelStyle: new TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        labelStyle: new TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        labelColor: Colors.black,
                        unselectedLabelColor: Color(0xff707070),
                        indicatorWeight: 5.0,
                        isScrollable: true,
                        tabs: myTabs.map((HomeTabList item) {
                          return new Tab(
                              text: item.text == null ? '错误' : item.text);
                        }).toList(),
                      ),
                    ),
                  ),
            ];
          },
          body: TabBarView(
            children: myTabs.map((item) {
              return item.goodList;
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getTitleAvatarData();
  }

  Widget home_top_menu(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 33),
      height: 145,
      child: _items == null
          ? Container()
          : new ListView.builder(
              itemCount: _items.length,
              itemBuilder: homeTitleItemView,
              scrollDirection: Axis.horizontal),
    );
  }

  getTitleAvatarData() async {
    var response = await HttpUtil().get(Api.HOME_TITLE_AVATAR);
    final body = json.decode(response.toString());
    var code = HomeTitleAvatarEntity.fromJson(body);
    if (body != null)
      setState(() {
        _items = code.data;
      });
  }

  //标题圆圈
  Widget homeTitleItemView(BuildContext context, int index) {
    HomeTitleAvatarData model = this._items[index];
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage("${model.activePicture}"),
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              border: new Border.all(width: 4, color: Color(0xff4ddfa9)),
            ),
          ),
          new Text(
            "${model.activeName}",
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xff000000)),
          )
        ],
      ),
      margin: EdgeInsets.all(10),
    );
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar widget;
  final Color color;

  const SliverTabBarDelegate(this.widget, {this.color})
      : assert(widget != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: widget,
      color: color,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => widget.preferredSize.height;

  @override
  double get minExtent => widget.preferredSize.height;
}

class HomeTabList {
  //商品列表 tab包装 类
  String text;
  Container goodList;

  HomeTabList(this.text, this.goodList);
}
