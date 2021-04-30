import 'dart:ui';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/status.dart';

class BluetoothStatus {
  final DanceGame game;
  final TextConfig config = TextConfig(fontSize: 48.0, fontFamily: 'Arial');
  Status deviceStatus;


  BluetoothStatus(this.game);

  void setStatus(Status status){
    this.deviceStatus = status;
  }

  void render(Canvas c) {
    config.render(c, "Flame is awesome", Position(10, 10));
  }
  void update(double t) {}
}