import 'package:flame/util.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:funkmeup/dancegame.dart';

void main() {

  DanceGame game = DanceGame();
  
  TapGestureRecognizer tapper = TapGestureRecognizer();
	tapper.onTapDown = game.onTapDown;
	Util flameUtil = Util();
  runApp(game.widget);

  Flame.images.loadAll(<String>[
  	'slidefront.png',
  	'slideleft.png',
  	'slideright.png',
  	'spin.png',
		'start.png',
		'calibrate.png',
		'title.png'
	]);

	Flame.audio.disableLog();
	Flame.audio.loadAll(<String>[
		'september.mp3'
	]);

  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);
}