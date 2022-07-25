import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import '../helpers/audio.dart';
import '../helpers/direction.dart';

class CatWalkable extends SpriteAnimationComponent
    with HasGameRef, TapCallbacks {
  CatWalkable() : super(size: Vector2.all(100));

  final double _catSpeed = 30;
  final double _animationSpeed = 0.2;

  Direction direction = Direction.none;

  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _standingAnimation;

  @override
  void update(double dt) {
    super.update(dt);
    moveCat(dt);
  }

  void moveCat(double dt) {
    if (position.x > 100) {
      position.add(Vector2(-dt * _catSpeed, 0));
      animation = _runLeftAnimation;
    } else {
      animation = _standingAnimation;
    }
  }

  @override
  Future<void>? onLoad() async {
    _loadAnimations().then((_) => {animation = _standingAnimation});
    position = Vector2(gameRef.canvasSize.x / 3, gameRef.canvasSize.y * 2 / 3);
  }

  Future<void> _loadAnimations() async {
    final sheet = SpriteSheet(
      image: await gameRef.images.load('sample01.png'),
      srcSize: Vector2(32, 32),
    );

    _runDownAnimation =
        sheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 3);
    _runLeftAnimation =
        sheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 3);
    _runRightAnimation =
        sheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 3);
    _runUpAnimation =
        sheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 3);
    _standingAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 1, to: 2);
  }

  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.play(catAudio[Random().nextInt(catAudio.length)], volume: 0.3);
    print("cat is tapped");
    super.onTapDown(event);
  }
}

class Nobiruneko extends SpriteAnimationComponent
    with HasGameRef, TapCallbacks {
  Nobiruneko() : super(size: Vector2.all(150));

  final double _catSpeed = 30;
  final double _animationSpeed = 0.05;

  Direction direction = Direction.none;

  late final SpriteAnimation _stretchAnimation;
  late final SpriteAnimation _standingAnimation;

  @override
  void update(double dt) {
    super.update(dt);
  }

  void stretch() {
    animation = _stretchAnimation;
    Future.delayed(Duration(milliseconds: 1700))
        .then((_) => {animation = _standingAnimation});
  }

  @override
  Future<void>? onLoad() async {
    _loadAnimations().then((_) => {animation = _standingAnimation});
    // position = Vector2(gameRef.canvasSize.x / 3, gameRef.canvasSize.y * 2 / 3);
    position = Vector2(200, 300);
  }

  Future<void> _loadAnimations() async {
    final sheet = SpriteSheet(
      image: await gameRef.images.load('nobiruneko.png'),
      srcSize: Vector2(200, 200),
    );

    _stretchAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 34);
    _standingAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 1);
  }

  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.play(catAudio[Random().nextInt(catAudio.length)], volume: 0.3);
    print("cat is tapped");
    stretch();
    super.onTapDown(event);
  }
}
