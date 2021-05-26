import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/status.dart';

class BluetoothStatus {
  final DanceGame game;
  final TextConfig config = TextConfig(
      fontSize: 20, color: Color(0xff03dac6), fontFamily: 'BebasNeue');
  Position textPosition;
  Status deviceStatus;

  BluetoothStatus(this.game) {
    textPosition = Position(10, game.screenSize.height - 30);
  }

  void setStatus(Status status) {
    this.deviceStatus = status;
  }

  void render(Canvas c) {
    if (deviceStatus == Status.connected ||
        deviceStatus == Status.devicefound) {
      config.render(c, "Device Found!", textPosition);
    } else if (deviceStatus == Status.nobluetooth) {
      config.render(c, "Bluetooth is required for this Game!",
          Position(10, game.screenSize.height - 50));
      config.render(c, "Please enable it!",
          textPosition);
    } else {
      config.render(c, "Searching for Device ...", textPosition);
    }
  }

  void update(double t) {}
}
