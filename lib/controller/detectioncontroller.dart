import 'dart:collection';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/moves.dart';

class DetectionController {
  final DanceGame game;

  Queue<int> accelXQueue = Queue<int>();
  Queue<int> accelZQueue = Queue<int>();
  Queue<int> gyroYQueue = Queue<int>();
  final int amountValuesOverAverage = 3;
  int degreeTurned = 0;

  DetectionController(this.game);

  bool update(double t, Moves move) {
    switch (move) {
      case Moves.slideleft:
        return detectNegativeAxisMovement(0, 30);
        break;
      case Moves.slidefront:
        return detectPostiveAxisMovement(0, 30);
        break;
      case Moves.slideright:
        return detectPostiveAxisMovement(0, 30);
        break;
      case Moves.spin:
        updateDegree(1, t);
        return detectSpin();
        break;
    }
    return false;
  }

  bool detectPostiveAxisMovement(double force, double threshold) {
    return force > threshold ? true : false;
  }

  bool detectNegativeAxisMovement(double force, double threshold) {
    return force < threshold ? true : false;
  }

  bool detectSpin() {
    if (degreeTurned > 360) {
      degreeTurned = 0;
      return true;
    } else {
      return false;
    }
  }

  void updateDegree(double degPerSec, double time) {
    degreeTurned += (degPerSec * time).toInt();
  }

  void updateData(int gyroY, List<int> accel) {
    insertToQueue(gyroYQueue, gyroY);
    insertToQueue(accelXQueue, accel[0]);
    insertToQueue(accelZQueue, accel[2]);

    int avgX = getAverageFromQueue(accelXQueue);
    int avgZ = getAverageFromQueue(accelZQueue);
    int avgGyro = getAverageFromQueue(gyroYQueue);
    print("avgX: $avgX    $avgZ    $avgGyro");
  }

  void insertToQueue(Queue<int> tmpQueue, int value){
    if(tmpQueue.length > amountValuesOverAverage){
      tmpQueue.removeLast();
    }
    tmpQueue.addFirst(value);
  }

  int getAverageFromQueue(Queue<int> tmpQueue){
    int avg = 0;
    for(var accelerationData in tmpQueue){
      avg += accelerationData;
    }
    return avg~/tmpQueue.length;
  }
}
