import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/view.dart';

class StartButton {
  final DanceGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 1,
      (game.screenSize.height * .5) - (game.tileSize * 1.5),
      game.tileSize * 7,
      game.tileSize * 3.5,
    );
    sprite = Sprite('start.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
    game.activeView = View.playing;
    game.playMainAudio();
    game.spawner.start();
  }
}
