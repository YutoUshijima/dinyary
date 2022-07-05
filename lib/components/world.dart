import 'package:flame/components.dart';

class World extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('bg_house_living.jpeg');
    size = sprite!.originalSize * 2;
    return super.onLoad();
  }
}
