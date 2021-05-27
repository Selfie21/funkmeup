import 'dart:collection';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:funkmeup/components/bar.dart';
import 'package:funkmeup/controller/detectioncontroller.dart';
import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/moves.dart';
import 'package:funkmeup/view.dart';

class IconSpawner {
  final DanceGame game;
  final TextConfig config = TextConfig(
      fontSize: 40, color: Color(0xff03dac6), fontFamily: 'BebasNeue');
  final moves = [0,2,0,2,1,1,3,0,0,2,2,0,2,0,2,0,3,2,3,3,3,3,2];
  final timings = [0,2000,3340,2000,4000,1800,1600,1400,1400,1400,1400,6000,
    1400,1400,1400,4000,2000,2000,2000,7000,4000,99999];
  static const int PLAY_TIME = 60000;
  static const int TIMEDELAY_AFTER_CHECKING_MOVES = 4000;
  static const int TIMEDELAY_AFTER_GOODMOVE = 1200;
  static const int TIMEDELAY_AFTER_TIMEOUT = 1400;
  static const int THRESHOLD_SUPREME_MOVE = 70;

  DetectionController detectionController;
  Bar bar;
  Position textPosition;

  int score = 0;
  int currentMoveIndex = 0;
  int startTime = 0;
  int nowTimestamp = 0;
  int nextSpawnTime = 0;

  Queue<int> categoryMoveToCheck = Queue<int>();
  Queue<int> timingMoveToCheck = Queue<int>();

  IconSpawner(this.game) {
    this.bar = game.bar;
    this.detectionController = game.detectionController;
    textPosition = Position(10, 10);
  }

  void start() {
    game.icons = [];
    currentMoveIndex = 0;
    categoryMoveToCheck.clear();
    timingMoveToCheck.clear();
    score = 0;
    startTime = DateTime.now().millisecondsSinceEpoch;
    nextSpawnTime = startTime + timings[currentMoveIndex];
  }

  void render(Canvas c) {
    config.render(c, "Score: $score", textPosition);
  }

  void update(double t) {
    nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    // Spawn Icons
    if(nowTimestamp >= nextSpawnTime){
      game.spawnIcon(Moves.values[moves[currentMoveIndex]]);
      addNextMove();
    }

    // Correct Move Detected in Time Frame
    if(timingMoveToCheck.isNotEmpty && nowTimestamp >= timingMoveToCheck.first &&
        detectionController.update(t, Moves.values[categoryMoveToCheck.first])){
      correctMoveRoutine();
    }

    // Timout after Checking Move
    if(timingMoveToCheck.isNotEmpty && nowTimestamp >= (timingMoveToCheck.first + TIMEDELAY_AFTER_TIMEOUT)){
      timeoutRoutine();
    }

    // Let Song run for 60 seconds
    if(nowTimestamp - startTime > PLAY_TIME){
      game.activeView = View.home;
      game.playIntroAudio();
    }
  }

  void addNextMove(){
    categoryMoveToCheck.addLast(moves[currentMoveIndex]);
    timingMoveToCheck.addLast(nowTimestamp + TIMEDELAY_AFTER_CHECKING_MOVES);
    currentMoveIndex += 1;
    nextSpawnTime = nowTimestamp + timings[currentMoveIndex];
  }

  void correctMoveRoutine(){
    int thresholdGoodMove = nowTimestamp - timingMoveToCheck.first - TIMEDELAY_AFTER_GOODMOVE;
    if (thresholdGoodMove.abs() < THRESHOLD_SUPREME_MOVE) {
      bar.setColor('supreme');
      score += 5;
    } else {
      bar.setColor('good');
      score += 1;
    }
    categoryMoveToCheck.removeFirst();
    timingMoveToCheck.removeFirst();
  }

  void timeoutRoutine(){
    bar.setColor('bad');
    score -= 1;
    categoryMoveToCheck.removeFirst();
    timingMoveToCheck.removeFirst();
  }
}
