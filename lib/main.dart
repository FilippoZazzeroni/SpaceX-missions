import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/shared/custom_theme.dart';
import 'package:spacex_missions/view_models/missions_view_model.dart';
import 'package:spacex_missions/view_models/search_bar_view_model.dart';
import 'package:spacex_missions/views/home_view/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionsViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => SearchBarViewModel()),
      ],
      child: MaterialApp(
        title: 'SpaceX missions',
        theme: CustomTheme.theme,
        home: HomeView(),
      ),
    );
  }
}
