import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/shared/custom_theme.dart';
import 'package:spacex_missions/view_models/missions_view_model.dart';
import 'package:spacex_missions/views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MissionsViewModel(),
      child: MaterialApp(
        title: 'SpaceX missions',
        theme: CustomTheme.theme,
        home: HomeView(),
      ),
    );
  }
}
