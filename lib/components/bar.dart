import 'dart:ui';

import 'package:funkmeup/dancegame.dart';

class Bar {
  final DanceGame game;
  final Color base = Color(0xff03dac6).withOpacity(0.8);
  final Color bad = Color(0xffF44336);
  final Color good = Color(0xff4caf50);
  final Color supreme = Color(0xffffbf00);
  Rect rect;
  Paint paint;

  Bar(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 2.5,
      (game.screenSize.height * .9) - (game.tileSize * 1.5),
      game.tileSize * 4,
      game.tileSize * .25,
    );

    paint = Paint();
    paint.color = base;
  }

  void setColor(String color){
    switch (color){
      case 'bad':
        this.paint.color = bad;
        break;
      case 'good':
        this.paint.color = good;
        break;
      case 'supreme':
        this.paint.color = supreme;
        break;
      default:
        this.paint.color = base;
    }
  }

  void render(Canvas c) {
    c.drawRect(rect, paint);
  }

  void update(double t) {}
}