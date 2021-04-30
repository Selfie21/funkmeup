import 'package:flame/flame.dart';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/moves.dart';
import 'package:funkmeup/controller/detectioncontroller.dart';
import 'package:funkmeup/components/bar.dart';

class IconSpawner {
  final DanceGame game;
  final moves = [0,1,2,3,0];
  final timings = [2000, 2000, 2000, 2000, 2000];

  DetectionController detectionController;
  Bar bar;
  int nextSpawn;
  int currentMove;

  int thresholdForMove = 0;
  int timeSinceChange = 0;
  List<int> timeForMoveToCheck;
  List<int> moveToCheck;

  IconSpawner(this.game){
    this.bar = game.bar;
    this.detectionController = game.detectionController;
    timeForMoveToCheck = [];
    moveToCheck = [];
  }

  void start() {
    currentMove = 0;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + timings[0];
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp >= nextSpawn){
      moveToCheck.add(moves[currentMove]);
      timeForMoveToCheck.add(nowTimestamp + 4000);
      game.spawnIcon(Moves.values[moves[currentMove]]);
      nextSpawn = nowTimestamp + timings[currentMove+1];
      currentMove += 1;
      if(currentMove >= moves.length-1){
        currentMove = 0;
      }
    }

    if (moveToCheck.isNotEmpty && nowTimestamp >= timeForMoveToCheck[0]){
      if(thresholdForMove == 0){
        thresholdForMove = nowTimestamp;
      }
      if(detectionController.update(t, Moves.values[moves[currentMove]])){
        if((nowTimestamp - thresholdForMove - 1200).abs() < 50) {
          bar.setColor('supreme');
        }else{
          bar.setColor('good');
        }
        thresholdForMove = 0;
        timeSinceChange = nowTimestamp;
        moveToCheck.removeAt(0);
        timeForMoveToCheck.removeAt(0);
      }

      if (nowTimestamp > (thresholdForMove+1400)){
        bar.setColor('bad');
        timeSinceChange = nowTimestamp;
        thresholdForMove = 0;
        moveToCheck.removeAt(0);
        timeForMoveToCheck.removeAt(0);
      }
    }

    if(nowTimestamp > (timeSinceChange+1000)){
      bar.setColor('base');
    }
  }
}