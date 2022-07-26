import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import 'header.dart';
import 'footer.dart';
import 'NoteViewModel.dart';
import '../components/world.dart';
import '../components/cat.dart';
import '../components/cat_sprite.dart';
import '../helpers/audio.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Map<String, dynamic>> _memo = [];

  void _refreshJournals() async {
    final data = await NoteViewModel.getNotes();
    setState(() {
      _memo = data;
      game.addCat(_memo.length);
      if (_memo.isEmpty)
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("日記を投稿してください！"),
          ),
        );
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final game = GameRoot();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        bottomNavigationBar: Footer(pageid: 4),
        body: Stack(children: [
          GameWidget(game: game),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x88ffffff),
                borderRadius: BorderRadius.circular(60),
              ),
              child: IconButton(
                onPressed: game.moveCameraToLeft,
                icon: const Icon(Icons.keyboard_arrow_left),
                iconSize: 40,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x88ffffff),
                borderRadius: BorderRadius.circular(60),
              ),
              child: IconButton(
                onPressed: game.moveCameraToRight,
                icon: const Icon(Icons.keyboard_arrow_right),
                iconSize: 40,
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Container(
          //     margin: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: const Color(0x88ffffff),
          //       borderRadius: BorderRadius.circular(60),
          //     ),
          //     child: IconButton(
          //       onPressed: () {
          //         if (_memo.isEmpty)
          //           showDialog(
          //             context: context,
          //             builder: (context) => AlertDialog(
          //               content: Text("日記の投稿数が足りません！"),
          //             ),
          //           );
          //       },
          //       icon: const Icon(Icons.add),
          //       iconSize: 30,
          //     ),
          //   ),
          // ),
        ]));
  }
}

class GameRoot extends FlameGame with HasTappableComponents {
  GameRoot() : super();

  final CatWorld _world = CatWorld();
  final List _cats = [
    Nobiruneko(),
    Kabeneko(),
    Ballneko(),
    Blackcat(),
  ];

  @override
  Future<void> onLoad() async {
    await add(_world);

    camera.worldBounds = Rect.fromLTRB(0, 0, _world.size.x, _world.size.y);
    camera.speed = 300;

    await FlameAudio.audioCache.loadAll(catAudio);
  }

  void moveCameraToLeft() {
    camera.moveTo(Vector2(0, 0));
  }

  void moveCameraToRight() {
    camera.moveTo(Vector2(_world.size.x, 0));
  }

  void addCat(int num) {
    for (int i = 0; i < _cats.length && i < num; i++) {
      add(_cats[i]);
    }
  }
}
