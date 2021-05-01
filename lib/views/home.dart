import 'dart:ui';

import 'package:funkmeup/components/bluetoothstatus.dart';
import 'package:funkmeup/components/helpbtn.dart';
import 'package:funkmeup/components/quitbtn.dart';
import 'package:funkmeup/components/startbtn.dart';
import 'package:funkmeup/components/title.dart';
import 'package:funkmeup/dancegame.dart';

class HomeView {
  final DanceGame game;
  final StartButton startbtn;
  final HelpButton helpbtn;
  final QuitButton quitbtn;
  final Title title;
  final BluetoothStatus bluetoothStatus;

  HomeView(this.game, this.startbtn, this.quitbtn, this.helpbtn, this.title,
      this.bluetoothStatus);

  void render(Canvas c) {
    title.render(c);
    startbtn.render(c);
    helpbtn.render(c);
    quitbtn.render(c);
    bluetoothStatus.render(c);
  }

  void update(double t) {}
}
