import 'dart:ui';
import 'package:flame/sprite.dart';

import 'package:funkmeup/dancegame.dart';

class CalibrateButton {
  final DanceGame game;
  Rect rect;
  Sprite sprite;

  CalibrateButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 1,
      (game.screenSize.height * .75) - (game.tileSize * 1.5),
      game.tileSize * 7,
      game.tileSize * 3.5,
    );
    sprite = Sprite('calibrate.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
  }
}