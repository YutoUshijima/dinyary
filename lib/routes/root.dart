import 'package:flutter/cupertino.dart';
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

class RootWidget extends StatefulWidget {
  RootWidget({Key? key}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
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
    Map(),
    Calendar(),
    Analysis(),
    Game(),
  ];
  // ==============

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _bottomNavigationBarItems[_selectedIndex] =
          _UpdateDeactiveState(_selectedIndex);
      _bottomNavigationBarItems[index] = _UpdateActiveState(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _routes.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // これを書かないと3つまでしか表示されない
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
