import 'dart:async';
import 'dart:ui';
import 'package:esense_flutter/esense.dart';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/controller/detectioncontroller.dart';

class BluetoothController {

  final DanceGame game;
  DetectionController detectionController;

  bool connected = false;
  String eSenseName = 'Unkown';
  String _deviceStatus = '';
  List<double> gyro = List<double>.filled(3, 0);
  List<double> accel = List<double>.filled(3, 0);

  BluetoothController(this.game) {
    this.detectionController = game.detectionController;
    _connectToESense();
  }

  Future<void> _connectToESense() async {

    ESenseManager.connectionEvents.listen((event) {

      print('CONNECTION event: $event');
      if(event.type == ConnectionType.connected) {
        Timer(Duration(seconds: 2), () async {
          _startListenToSensorEvents();
          connected = true;
        });
      }

      switch (event.type) {
        case ConnectionType.connected:
          _deviceStatus = 'connected';
          break;
        case ConnectionType.unknown:
          _deviceStatus = 'unknown';
          break;
        case ConnectionType.disconnected:
          _deviceStatus = 'disconnected';
          break;
        case ConnectionType.device_found:
          _deviceStatus = 'device_found';
          break;
        case ConnectionType.device_not_found:
          _deviceStatus = 'device_not_found';
          break;
      }
    });

    Timer.periodic(Duration(seconds: 4), (timer) async {
      await ESenseManager.connect(eSenseName);

      await new Future.delayed(const Duration(seconds : 3));
      if(_deviceStatus == 'device_found' || _deviceStatus == 'connected') {
        timer.cancel();
      }
    });
  }

  StreamSubscription subscription;
  void _startListenToSensorEvents() async{
    subscription = ESenseManager.sensorEvents.listen((event) {
        convertData(event.toString());
        detectionController.updateData(gyro, accel);
    });
  }

  void convertData(String dataString) {
    //TODO: when getting headphones convert to accel and gyro array Maybe with Regex?
  }

}