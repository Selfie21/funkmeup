import 'dart:ui';
import 'package:flame/sprite.dart';

import 'package:funkmeup/dancegame.dart';

class ChooseSongButton {
  final DanceGame game;
  Rect rect;
  Sprite sprite;

  ChooseSongButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 1,
      (game.screenSize.height * .75) - (game.tileSize * 1.5),
      game.tileSize * 7,
      game.tileSize * 3.5,
    );
    sprite = Sprite('choosesong.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
  }
}