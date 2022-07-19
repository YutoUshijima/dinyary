// 新しいフッター表示用ウィジェット
// これを毎回bottomNavigationBarに入れてください

// パラメータ"pageid"によってアクティブなアイコンを管理します
// pageidの値はリスト"_routes"のインデックスに一致するよう記入してください

import 'package:flutter/material.dart';

// == 作成したWidget をインポート ==================
import 'timeline_route.dart';
import 'map_route.dart';
import 'calendar_route.dart';
import 'analysis_route.dart';
//import 'routes/home_route.dart';
//import 'routes/user_route.dart';
import 'game_route.dart';
// =============================================

class Footer extends StatefulWidget {
  //Footer({Key? key}) : super(key: key);

  final int pageid;
  Footer({Key? key, required this.pageid}) : super(key: key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  static const _footerIcons = [
    Icons.textsms,
    Icons.map,
    Icons.calendar_month,
    Icons.content_paste,
    Icons.videogame_asset,
  ];

  static const _footerItemNames = [
    'TimeLine',
    'Map',
    'Calendar',
    'Analysis',
    'Game',
  ];

  // === 追加部分 ===
  var _routes = [
    TimeLine(),
    Map_view(),
    Calendar(),
    Analysis(),
    Game(),
  ];
  // ==============

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageid;
    _bottomNavigationBarItems.add(_UpdateActiveState(0));
    for (var i = 1; i < _footerItemNames.length; i++) {
      _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
    }
  }

  /// インデックスのアイテムをアクティベートする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: Colors.black87,
      ),
      label: _footerItemNames[index],
    );
  }

  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: Colors.black26,
      ),
      label: _footerItemNames[index],
    );
  }

  void _onItemTapped(int index) {
    //setState(() {
    //  _bottomNavigationBarItems[_selectedIndex] =
    //      _UpdateDeactiveState(_selectedIndex);
    //  _bottomNavigationBarItems[index] = _UpdateActiveState(index);
    //  _selectedIndex = index;
    //});
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _routes.elementAt(index);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var footer = BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // これを書かないと3つまでしか表示されない
      items: _bottomNavigationBarItems,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
    _bottomNavigationBarItems[0] =
          _UpdateDeactiveState(0);
    _bottomNavigationBarItems[_selectedIndex] = _UpdateActiveState(_selectedIndex);
    return footer;
  }
}
