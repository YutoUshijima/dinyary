import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'header.dart';
import '../components/world.dart';
import '../components/cat.dart';

class Game extends StatelessWidget {
  Game({Key? key}) : super(key: key);

  final game = GameRoot();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: GameWidget(game: game),
    );
  }
}

class GameRoot extends FlameGame {
  final World _world = World();
  final Cat _cat = Cat();

  @override
  Future<void> onLoad() async {
    await add(_world);
    add(_cat);

    _cat.position = Vector2(250, 400);
    camera.followComponent(
      _cat,
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y),
    );
  }
}
