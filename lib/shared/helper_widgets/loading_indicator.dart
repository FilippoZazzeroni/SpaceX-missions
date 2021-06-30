import 'package:flutter/material.dart';

/// Widget that shows loading indicator
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/gifs/loading.gif")),
          shape: BoxShape.circle),
    );
  }
}
