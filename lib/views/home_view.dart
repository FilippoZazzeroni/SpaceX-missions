import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/models/mission.dart';
import 'package:spacex_missions/models/pagination_state.dart';
import 'package:spacex_missions/view_models/missions_view_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _textEditingController = TextEditingController();

  final _scrollController = ScrollController();

  late final MissionsViewModel model;

  @override
  void initState() {
    model = context.read<MissionsViewModel>();
    _scrollController.addListener(() {
      // request more data only if the position in the list view is higher than te max scroll e
      if (_scrollController.position.pixels >
          0.9 * _scrollController.position.maxScrollExtent) {
        model.requestMoreMissions(_textEditingController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textEditingController,
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
        builder: (context, model, _) {
          if (model.state == PaginationState.loadingFirstPage)
            return CircularProgressIndicator.adaptive();

          if (model.state == PaginationState.noItmes)
            return Text("no data available");

          if (model.state == PaginationState.itemsFetched ||
              model.state == PaginationState.loadingMoreItems)
            return ListView.builder(
                controller: _scrollController,
                //length + 1 allows to ad progress indicator at the end of the view
                //TODO aggiungere length
                itemCount: model.missions.length,
                itemBuilder: (context, index) {
                  //TODO capire index
                  if (model.state == PaginationState.loadingMoreItems &&
                      index == model.missions.length - 1) {
                    return CircularProgressIndicator();
                  }

                  final mission = model.missions[index];

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

          return SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
