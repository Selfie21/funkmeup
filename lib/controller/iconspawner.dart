import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/moves.dart';
import 'package:funkmeup/view.dart';
import 'package:funkmeup/controller/detectioncontroller.dart';
import 'package:funkmeup/components/bar.dart';

class IconSpawner {
  final DanceGame game;
  final TextConfig config = TextConfig(fontSize: 40, color:Color(0xff03dac6),
      fontFamily: 'BebasNeue');
  final moves = [0,1,2,3,0,1,1,1,1];
  final timings = [2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000];

  DetectionController detectionController;
  Bar bar;
  Position textPosition;
  int nextSpawn;
  int currentMove;

  int score = 0;
  int startTime = 0;
  int thresholdForMove = 0;
  int timeSinceChange = 0;
  List<int> timeForMoveToCheck;
  List<int> moveToCheck;

  IconSpawner(this.game){
    this.bar = game.bar;
    this.detectionController = game.detectionController;
    timeForMoveToCheck = [];
    moveToCheck = [];
    textPosition = Position(10, 10);
  }

  void start() {
    score = 0;
    currentMove = 0;
    timeForMoveToCheck = [];
    moveToCheck = [];
    startTime = DateTime.now().millisecondsSinceEpoch;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + timings[0];
  }

  void render(Canvas c){
    config.render(c, "Score: $score", textPosition);
  }

  //Refactor whatever this even is
  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    // Let Song run for 100 seconds
    if(nowTimestamp - startTime > 100000){
      game.activeView = View.home;
      game.playIntroAudio();
    }

    // Add Timings for new Move to Check
    if (!(currentMove >= moves.length-1) && nowTimestamp >= nextSpawn){
      moveToCheck.add(moves[currentMove]);
      timeForMoveToCheck.add(nowTimestamp + 4000);
      game.spawnIcon(Moves.values[moves[currentMove]]);
      nextSpawn = nowTimestamp + timings[currentMove+1];
      currentMove += 1;
    }

    // Time Interval for Checking current Move
    if (moveToCheck.isNotEmpty && nowTimestamp >= timeForMoveToCheck[0]){

      // new Move detected
      if(thresholdForMove == 0){
        thresholdForMove = nowTimestamp;
      }

      // User input was Correct
      if(detectionController.update(t, Moves.values[moves[currentMove]])){
        if((nowTimestamp - thresholdForMove - 1200).abs() < 50) {
          bar.setColor('supreme');
          score += 5;
        }else{
          bar.setColor('good');
          score += 1;
        }
        thresholdForMove = 0;
        timeSinceChange = nowTimestamp;
        moveToCheck.removeAt(0);
        timeForMoveToCheck.removeAt(0);
      }

      //Timeout for Current Move
      if (nowTimestamp > (thresholdForMove+1400)){
        bar.setColor('bad');
        score -= 1;
        timeSinceChange = nowTimestamp;
        thresholdForMove = 0;
        moveToCheck.removeAt(0);
        timeForMoveToCheck.removeAt(0);
      }
    }

    // Change bar to Base
    if(nowTimestamp > (timeSinceChange+1000)){
      bar.setColor('base');
    }
  }
}