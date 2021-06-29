import 'package:flutter/material.dart';
import 'package:spacex_missions/shared/custom_color.dart';

class CustomTheme {
  static final theme = ThemeData(
      fontFamily: "Kalam",
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => CustomColors.deepPurple))),
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: CustomColors.purple,
          cursorColor: CustomColors.deepPurple));
}
