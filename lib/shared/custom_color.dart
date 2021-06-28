import 'package:flutter/material.dart';

class CustomColors {
  static final deepPurple = Color.fromRGBO(67, 0, 255, 1.0);

  static final purple = Color.fromRGBO(132, 87, 255, 1.0);

  static final backgroundGradient = LinearGradient(
      colors: [deepPurple, purple],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
