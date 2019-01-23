import 'package:flutter/material.dart';
import 'package:offers/src/app/const.dart';
import 'package:offers/src/ui/root.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new Root(),
      title: new Text(
        appName,
        style: new TextStyle(
          color: Colors.white,
          fontFamily: appNameFont,
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.red,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}
