import 'dart:ui';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/status.dart';

class HelpView {
  final DanceGame game;
  final TextConfig config = TextConfig(
      fontSize: 30,
      color: Color(0xff03dac6),
      fontFamily: 'BebasNeue',
      textAlign: TextAlign.left);
  //TODO: automatic text align
  final String supportText =
      'Welcome to Funk Me UP!\n \nIn this game you will have to \n'
      'perform dance moves when they hit \nthe bar at the bottom.\n \n'
      'The Game needs Bluetooth aswell \nas an active Connection to the \n'
      'eSense Headphones in order to detect\nthe groovy moves. \n \n'
      'You can also play without the \nHeadphones, with no tracking.\n';
  Position textPosition;
  Status deviceStatus;

  HelpView(this.game) {
    textPosition = Position(10, 20);
  }

  void setStatus(Status status) {
    this.deviceStatus = status;
  }

  void render(Canvas c) {
    config.render(c, supportText, textPosition);
  }

  void update(double t) {}
}
