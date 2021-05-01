import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/view.dart';

class HelpButton {
  final DanceGame game;
  Rect rect;
  Sprite sprite;

  HelpButton(this.game) {
    rect = Rect.fromLTWH(
      (game.screenSize.width * 0.9) - game.tileSize,
      (game.screenSize.height * 0.9),
      game.tileSize * 2,
      game.tileSize * 2,
    );
    sprite = Sprite('help.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
    game.activeView = View.help;
  }
}
