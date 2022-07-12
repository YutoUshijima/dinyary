import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CatWorld extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('bg_house_living.jpeg');
    size = sprite!.originalSize * 2;
    return super.onLoad();
  }
}
