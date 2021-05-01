import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:funkmeup/dancegame.dart';
import 'package:funkmeup/view.dart';

class NavigationController extends StatelessWidget {

  final DanceGame game;

  NavigationController(this.game);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Row(),
      onWillPop: () {
        if(game.activeView == View.home){
          game.stopAudio();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }else{
          game.activeView = View.home;
          game.playIntroAudio();
        }
    });
  }
}
