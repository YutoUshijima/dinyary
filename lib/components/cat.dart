import 'package:flame/components.dart';

class Cat extends SpriteComponent with HasGameRef {
  Cat() : super(size: Vector2.all(100));
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('cat_mikeneko2.png');
  }
}
