import 'dart:ui';
import 'package:flame/sprite.dart';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/components/startbtn.dart';
import 'package:funkmeup/components/calibratebtn.dart';
import 'package:funkmeup/components/title.dart';

class HomeView {

  final DanceGame game;
  final StartButton startbtn;
  final CalibrateButton calibratebtn;
  final Title title;

  HomeView(this.game, this.startbtn, this.calibratebtn, this.title);

  void render(Canvas c) {
    title.render(c);
    startbtn.render(c);
    calibratebtn.render(c);
  }

  void update(double t) {}
}