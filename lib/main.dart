import 'package:flame/util.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:funkmeup/dancegame.dart';

import 'controller/navigationcontroller.dart';

void main() {
  DanceGame game = DanceGame();

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  Util flameUtil = Util();

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            game.widget,
            new NavigationController(game)
            ],
        )
      )
    )
  );

  Flame.images.loadAll(<String>[
    'slidefront.png',
    'slideleft.png',
    'slideright.png',
    'spin.png',
    'start.png',
    'quit.png',
    'title.png',
    'help.png'
  ]);

  Flame.audio.disableLog();
  Flame.audio.loadAll(<String>['intro.mp3', 'september.mp3', 'play.mp3']);

  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);
}
