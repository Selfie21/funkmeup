import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:funkmeup/components/bar.dart';
import 'package:funkmeup/components/bluetoothstatus.dart';
import 'package:funkmeup/components/icon.dart';
import 'package:funkmeup/components/quitbtn.dart';
import 'package:funkmeup/components/startbtn.dart';
import 'package:funkmeup/components/title.dart';
import 'package:funkmeup/controller/bluetoothcontroller.dart';
import 'package:funkmeup/controller/detectioncontroller.dart';
import 'package:funkmeup/controller/iconspawner.dart';
import 'package:funkmeup/moves.dart';
import 'package:funkmeup/view.dart';
import 'package:funkmeup/views/help.dart';
import 'package:funkmeup/views/home.dart';

import 'components/helpbtn.dart';

class DanceGame extends Game with TapDetector {
  Size screenSize;
  double tileSize;
  bool hasWon = false;
  List<Icon> icons;
  Random rnd;
  IconSpawner spawner;
  Bar bar;
  int score;
  AudioPlayer introAudio;
  AudioPlayer mainAudio;

  View activeView = View.home;
  Title title;
  HomeView homeView;
  HelpView helpView;
  StartButton startbtn;
  QuitButton quitbtn;
  HelpButton helpbtn;

  DetectionController detectionController;
  BluetoothController bluetoothController;
  BluetoothStatus bluetoothStatus;

  DanceGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    icons = [];
    startbtn = StartButton(this);
    quitbtn = QuitButton(this);
    helpbtn = HelpButton(this);
    title = Title(this);
    bar = Bar(this);
    bluetoothStatus = BluetoothStatus(this);

    homeView =
        HomeView(this, startbtn, quitbtn, helpbtn, title, bluetoothStatus);
    helpView = HelpView(this);
    detectionController = DetectionController(this);
    bluetoothController = BluetoothController(this);
    spawner = IconSpawner(this);
    mainAudio = await Flame.audio.loopLongAudio('september.mp3', volume: .25);
    mainAudio.pause();
    introAudio = await Flame.audio.loopLongAudio('intro.mp3', volume: .25);
  }

  void playMainAudio() {
    introAudio.pause();
    mainAudio.pause();
    mainAudio.seek(Duration.zero);
    mainAudio.resume();
  }

  void playIntroAudio() {
    mainAudio.pause();
    introAudio.pause();
    introAudio.seek(Duration.zero);
    introAudio.resume();
  }

  void stopAudio() {
    mainAudio.stop();
    introAudio.stop();
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void spawnIcon(Moves move) {
    double middle = (screenSize.width / 2);
    Icon newIcon = Icon(this, middle - (tileSize * 1.5), 0, move);
    icons.add(newIcon);
  }

  void render(Canvas canvas) {
    drawBackground(canvas);
    icons.forEach((Icon icon) => icon.render(canvas));
    if (activeView == View.home)
      homeView.render(canvas);
    else if (activeView == View.help)
      helpView.render(canvas);
    else if (activeView == View.playing) {
      spawner.render(canvas);
      bar.render(canvas);
    }
  }

  void update(double t) {
    if (activeView == View.playing) spawner.update(t);
    icons.forEach((Icon icon) => icon.update(t));
    icons.removeWhere((Icon icon) => icon.isOffScreen);
  }

  void drawBackground(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff222f3e);
    canvas.drawRect(bgRect, bgPaint);
  }

  void onTapDown(TapDownDetails d) {
    if (startbtn.rect.contains(d.globalPosition) && activeView == View.home) {
      Flame.audio.play('play.mp3');
      startbtn.onTapDown();
    }

    if (quitbtn.rect.contains(d.globalPosition) && activeView == View.home) {
      Flame.audio.play('play.mp3');
      stopAudio();
      quitbtn.onTapDown();
    }

    if (helpbtn.rect.contains(d.globalPosition) && activeView == View.home) {
      Flame.audio.play('play.mp3');
      helpbtn.onTapDown();
    }
  }
}
