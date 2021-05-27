import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/status.dart';

class BluetoothStatus {
  final DanceGame game;
  TextConfig config = TextConfig(
      fontSize: 25, color: Color(0xff03dac6), fontFamily: 'BebasNeue');
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
      changeTextColour(Color(0xff03dac6));
      config.render(c, "Device Found!", textPosition);
    } else if (deviceStatus == Status.nobluetooth) {
      config.render(c, "Bluetooth is required for this Game!",
          Position(10, game.screenSize.height - 60));
      config.render(c, "Please enable it!",
          textPosition);
    } else {
      config.render(c, "Searching for Device ...", textPosition);
    }
  }

  void update(double t) {}

  void changeTextColour(Color newColor){
    this.config = TextConfig(
        fontSize: 25, color: newColor, fontFamily: 'BebasNeue');
  }
}
