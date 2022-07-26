import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import '../helpers/audio.dart';
import '../helpers/direction.dart';

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
    position = Vector2(gameRef.canvasSize.x / 4, gameRef.canvasSize.y * 3 / 4);
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

class Kabeneko extends SpriteAnimationComponent with HasGameRef, TapCallbacks {
  Kabeneko() : super(size: Vector2.all(150));

  final double _catSpeed = 30;
  final double _animationSpeed = 0.15;

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
    position =
        Vector2(gameRef.canvasSize.x * 3 / 4, gameRef.canvasSize.y * 9 / 14);
    // position = Vector2(280, 420);
  }

  Future<void> _loadAnimations() async {
    final sheet = SpriteSheet(
      image: await gameRef.images.load('cat_wall.png'),
      srcSize: Vector2(300, 300),
    );

    _stretchAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 1);
    _standingAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 21);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // FlameAudio.play(catAudio[Random().nextInt(catAudio.length)], volume: 0.3);
    print("wall cat is tapped");
    stretch();
    super.onTapDown(event);
  }
}

class Ballneko extends SpriteAnimationComponent with HasGameRef, TapCallbacks {
  Ballneko() : super(size: Vector2.all(150));

  final double _catSpeed = 30;
  final double _animationSpeed = 0.13;

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
    position =
        Vector2(gameRef.canvasSize.x * 11 / 7, gameRef.canvasSize.y * 3 / 4);
  }

  Future<void> _loadAnimations() async {
    final sheet = SpriteSheet(
      image: await gameRef.images.load('cat_ball.png'),
      srcSize: Vector2(300, 300),
    );

    _stretchAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 21);
    _standingAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 21);
  }

  @override
  void onTapDown(TapDownEvent event) {
    stretch();
    super.onTapDown(event);
  }
}

class Blackcat extends SpriteAnimationComponent with HasGameRef, TapCallbacks {
  Blackcat() : super(size: Vector2.all(100));

  final double _catSpeed = 30;
  final double _animationSpeed = 0.15;

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
    position =
        Vector2(gameRef.canvasSize.x * 9 / 7, gameRef.canvasSize.y * 5 / 8);
  }

  Future<void> _loadAnimations() async {
    final sheet = SpriteSheet(
      image: await gameRef.images.load('black_cat.png'),
      srcSize: Vector2(200, 200),
    );

    _stretchAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 21);
    _standingAnimation = sheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 33);
  }

  @override
  void onTapDown(TapDownEvent event) {
    stretch();
    super.onTapDown(event);
  }
}
