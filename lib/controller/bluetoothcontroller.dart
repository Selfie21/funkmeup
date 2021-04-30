import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:esense_flutter/esense.dart';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/controller/detectioncontroller.dart';
import 'package:funkmeup/status.dart';

class BluetoothController {
  final DanceGame game;
  DetectionController detectionController;

  String eSenseName = 'Unkown';
  Status _deviceStatus = Status.unknown;
  List<double> gyro = List<double>.filled(3, 0);
  List<double> accel = List<double>.filled(3, 0);

  BluetoothController(this.game) {
    this.detectionController = game.detectionController;
    _connectToESense();
  }

  //TODO: Prevent Crash when bluetooth is not turned on
  Future<void> _connectToESense() async {
    ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');
      if (event.type == ConnectionType.connected) {
        Timer(Duration(seconds: 2), () async {
          _startListenToSensorEvents();
        });
      }

      switch (event.type) {
        case ConnectionType.connected:
          _deviceStatus = Status.connected;
          break;
        case ConnectionType.unknown:
          _deviceStatus = Status.unknown;
          break;
        case ConnectionType.disconnected:
          _deviceStatus = Status.disconnected;
          break;
        case ConnectionType.device_found:
          _deviceStatus = Status.devicefound;
          break;
        case ConnectionType.device_not_found:
          _deviceStatus = Status.devicenotfound;
          break;
      }

      game.bluetoothStatus.setStatus(_deviceStatus);
    });

    Timer.periodic(Duration(seconds: 4), (timer) async {
      await ESenseManager.connect(eSenseName);

      await new Future.delayed(const Duration(seconds: 3));
      if (_deviceStatus == Status.devicefound ||
          _deviceStatus == Status.connected) {
        timer.cancel();
      }
    });
  }

  StreamSubscription subscription;

  void _startListenToSensorEvents() async {
    subscription = ESenseManager.sensorEvents.listen((event) {
      convertData(event.toString());
      detectionController.updateData(gyro, accel);
    });
  }

  void convertData(String dataString) {
    //TODO: when getting headphones convert to accel and gyro array Maybe with Regex? Looks like the data will just be one long string
  }
}
