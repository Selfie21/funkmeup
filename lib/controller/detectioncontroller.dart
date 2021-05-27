import 'dart:collection';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/moves.dart';

class DetectionController {
  final DanceGame game;

  Queue<int> accelXQueue = Queue<int>();
  Queue<int> accelZQueue = Queue<int>();
  Queue<int> gyroYQueue = Queue<int>();
  static const int VALUES_TO_TAKE_AVERAGE_OVER = 3;

  DetectionController(this.game);

  bool update(double t, Moves move) {
    switch (move) {
      case Moves.slideleft:
        return detectNegativeAxisMovement(getAverageFromQueue(accelZQueue), -1000);
        break;
      case Moves.slidefront:
        return detectPostiveAxisMovement(getAverageFromQueue(accelZQueue), 1000);
        break;
      case Moves.slideright:
        return detectPostiveAxisMovement(getAverageFromQueue(accelXQueue), 1000);
        break;
      case Moves.spin:
        detectPostiveAxisMovement(getAverageFromQueue(gyroYQueue), 2500);
        break;
    }
    return false;
  }

  bool detectPostiveAxisMovement(int force, int threshold) {
    return force > threshold ? true : false;
  }

  bool detectNegativeAxisMovement(int force, int threshold) {
    return force < threshold ? true : false;
  }

  void updateData(int gyroY, List<int> accel) {
    insertToQueue(gyroYQueue, gyroY);
    insertToQueue(accelXQueue, accel[0]);
    insertToQueue(accelZQueue, accel[2]);

    int avgX = getAverageFromQueue(accelXQueue);
    int avgZ = getAverageFromQueue(accelZQueue);
    int avgGyro = getAverageFromQueue(gyroYQueue);
    print("Sensordata: $avgX    $avgZ    $avgGyro");
  }

  void insertToQueue(Queue<int> tmpQueue, int value){
    if(tmpQueue.length > VALUES_TO_TAKE_AVERAGE_OVER){
      tmpQueue.removeLast();
    }
    tmpQueue.addFirst(value);
  }

  int getAverageFromQueue(Queue<int> tmpQueue){
    int avg = 0;
    for(var accelerationData in tmpQueue){
      avg += accelerationData;
    }
    if(tmpQueue.length == 0){
      return 0;
    }else{
      return avg~/tmpQueue.length;
    }
  }
}
