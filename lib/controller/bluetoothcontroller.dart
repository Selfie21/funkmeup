import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:funkmeup/controller/detectioncontroller.dart';
import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/status.dart';

class BluetoothController {
  final DanceGame game;
  DetectionController detectionController;

  String eSenseName = 'eSense-0176';
  Status _deviceStatus = Status.unknown;
  bool _connectionLock = false;

  List<int> accel = List<int>.filled(3, 0);
  List<double> gravity = List<double>.filled(3, 0);
  final double alpha = 0.8;
  int gyroY = 0;

  BluetoothController(this.game) {
    this.detectionController = game.detectionController;
    Timer.periodic(Duration(seconds: 2), (timer) {
      FlutterBlue.instance.state.listen((state) {
        if (state == BluetoothState.off) {
          game.bluetoothStatus.setStatus(Status.nobluetooth);
        } else {
          game.bluetoothStatus.setStatus(Status.unknown);
          _connectToESense();
          _connectionLock = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _connectToESense() async {
    //prevent calling this method twice
    if (_connectionLock) {
      return;
    }
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
      gravity[0] = alpha * gravity[0] + (1 - alpha) * event.accel[0];
      gravity[1] = alpha * gravity[1] + (1 - alpha) * event.accel[1];
      gravity[2] = alpha * gravity[2] + (1 - alpha) * event.accel[2];

      // Remove the gravity contribution with the high-pass filter.
      accel[0] = (event.accel[0] - gravity[0]).toInt();
      accel[1] = (event.accel[1] - gravity[1]).toInt();
      accel[2] = (event.accel[2] - gravity[2]).toInt();

      gyroY = event.gyro[1];
      detectionController.updateData(gyroY, accel);
    });
  }
}
