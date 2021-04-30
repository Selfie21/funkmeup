import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/moves.dart';

class DetectionController {
  final DanceGame game;

  List<double> accel = List<double>.filled(3, 0);
  List<double> gyro = List<double>.filled(3, 0);
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
    return force > threshold ? true : false;
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

  void updateData(List<double> gyro, List<double> accel) {
    this.gyro = gyro;
    this.accel = accel;
  }
}
