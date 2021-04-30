import 'dart:ui';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/components/startbtn.dart';
import 'package:funkmeup/components/calibratebtn.dart';
import 'package:funkmeup/components/title.dart';
import 'package:funkmeup/components/bluetoothstatus.dart';

class HomeView {

  final DanceGame game;
  final StartButton startbtn;
  final CalibrateButton calibratebtn;
  final Title title;
  final BluetoothStatus bluetoothStatus;

  HomeView(this.game, this.startbtn, this.calibratebtn, this.title, this.bluetoothStatus);

  void render(Canvas c) {
    title.render(c);
    startbtn.render(c);
    calibratebtn.render(c);
    bluetoothStatus.render(c);
  }

  void update(double t) {}
}