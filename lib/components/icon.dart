import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:funkmeup/moves.dart';
import 'package:funkmeup/dancegame.dart';

class Icon {
  final DanceGame game;
  Rect iconRect;
  bool gotClicked = false;
  bool isOffScreen = false;
  Sprite iconSprite;

  Icon(this.game, double x, double y, Moves type) {
    iconRect = Rect.fromLTWH(x, y, game.tileSize * 3, game.tileSize * 3);
    this.setType(type);
  }

  void setType(Moves move) {
    switch (move) {
      case Moves.slideleft:
        iconSprite = Sprite('slideleft.png');
        break;
      case Moves.slidefront:
        iconSprite = Sprite('slidefront.png');
        break;
      case Moves.slideright:
        iconSprite = Sprite('slideright.png');
        break;
      case Moves.spin:
        iconSprite = Sprite('spin.png');
        break;
    }
  }

  void render(Canvas c) {
    iconSprite.renderRect(c, iconRect);
  }

  void update(double t) {
    iconRect = iconRect.translate(0, game.tileSize * 2 * t);
    if (iconRect.top > game.screenSize.height) {
      isOffScreen = true;
    }
  }

  void onTapDown() {
    gotClicked = true;
  }
}
