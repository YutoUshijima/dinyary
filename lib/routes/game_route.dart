import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import 'header.dart';
import '../components/world.dart';
import '../components/cat.dart';
import '../components/cat_sprite.dart';
import '../helpers/audio.dart';

class Game extends StatelessWidget {
  Game({Key? key}) : super(key: key);

  final game = GameRoot();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
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
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x88ffffff),
                borderRadius: BorderRadius.circular(60),
              ),
              child: IconButton(
                onPressed: game.addCat,
                icon: const Icon(Icons.add),
                iconSize: 30,
              ),
            ),
          ),
        ]));
  }
}

class GameRoot extends FlameGame with HasTappableComponents {
  final CatWorld _world = CatWorld();
  int _numCat = 0;
  final List<Cat> _cats = [
    Cat('cat_mikeneko2.png', 250, 400),
    Cat('cat_mikeneko2.png', 400, 400),
  ];

  @override
  Future<void> onLoad() async {
    await add(_world);
    add(CatWalkable());

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

  void addCat() {
    if (_cats.length > _numCat) {
      add(_cats[_numCat]);
      _numCat++;
    }
    // TODO
    print(canvasSize);
  }
}
