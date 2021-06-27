import 'package:flutter/material.dart';

class CustomColors {
  static final _backgroundFirstColor = Color.fromRGBO(67, 0, 255, 1.0);

  static final _backgroundSecondColor = Color.fromRGBO(132, 87, 255, 1.0);

  static final backgroundGradient = LinearGradient(
      colors: [_backgroundFirstColor, _backgroundSecondColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
