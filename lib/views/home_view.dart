import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/view_models/missions_view_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = TextEditingController();

  late final MissionsViewModel model;

  @override
  void initState() {
    model = context.read<MissionsViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            onChanged: (value) => model.fetchMissions(value),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                //TODO implement hide show of text editing controller
                onPressed: () => {},
                icon: Icon(Icons.search))
          ],
        ),
        body: Consumer<MissionsViewModel>(
          builder: (context, missionViewModel, _) {
            if (missionViewModel.missions.isEmpty)
              return Text("no data available");

            return ListView.builder(
                itemCount: missionViewModel.missions.length,
                itemBuilder: (context, index) {
                  final mission = missionViewModel.missions[index];

                  return Container(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.amberAccent,
                    child: Column(
                      children: [
                        Text(mission.missionName),
                        if (mission.details != null) Text(mission.details!)
                      ],
                    ),
                  );
                });
          },
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
