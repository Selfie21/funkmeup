import 'dart:ui';
import 'package:flame/sprite.dart';

import 'package:funkmeup/dancegame.dart';

class Title {
  final DanceGame game;
  Rect rect;
  Sprite sprite;

  Title(this.game) {
    rect = Rect.fromLTWH(
      -20,
      (game.screenSize.height * .2) - (game.tileSize * 2),
      game.tileSize * 11,
      game.tileSize * 6,
    );
    sprite = Sprite('title.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}
}
