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
  bool _connectionLock = false;
  List<double> gyro = List<double>.filled(3, 0);
  List<double> accel = List<double>.filled(3, 0);

  BluetoothController(this.game) {
    this.detectionController = game.detectionController;
    Timer.periodic(Duration(seconds: 2), (timer) {
      FlutterBlue.instance.state.listen((state) {
        if (state == BluetoothState.off) {
          game.bluetoothStatus.setStatus(Status.nobluetooth);
        }else{
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
    if(_connectionLock){
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
      convertData(event.toString());
      detectionController.updateData(gyro, accel);
    });
  }

  void convertData(String dataString) {
    //TODO: have to wait for headphones to see how data looks like ... convert to accel and gyro array Maybe with Regex? Looks like the data will just be one long string
  }
}
