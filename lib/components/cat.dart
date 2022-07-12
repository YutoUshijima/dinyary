import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_audio/flame_audio.dart';

List<String> catAudio = [
  'cat1a.mp3',
  'cat1b.mp3',
  'cat3c.mp3',
];

class Cat extends SpriteComponent with HasGameRef, TapCallbacks {
  Cat(this.spriteName, this.posX, this.posY) : super(size: Vector2.all(100));

  String spriteName;
  double posX, posY;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite(spriteName);
    position = Vector2(posX, posY);
  }

  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.play(catAudio[Random().nextInt(catAudio.length)]);
    super.onTapDown(event);
  }
}
