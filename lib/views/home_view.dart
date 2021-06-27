import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/models/pagination_state.dart';
import 'package:spacex_missions/shared/custom_color.dart';
import 'package:spacex_missions/shared/helper_widgets/result_card.dart';
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
    return Container(
      decoration: BoxDecoration(gradient: CustomColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        //TODO implementare custom app bar
        body: Stack(
          children: [
            //TODO capire come posizionarla in fondo allo schermo
            Positioned(
              bottom: -1000,
              child: SvgPicture.asset(
                "assets/svgs/background.svg",
              ),
            ),
            Consumer<MissionsViewModel>(
              builder: (context, model, _) {
                if (model.state == PaginationState.loadingFirstPage)
                  return CircularProgressIndicator.adaptive();

                if (model.state == PaginationState.noItmes)
                  //TODO attenzione occupa tutto lo schermo
                  return Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Text("no data available"));

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

                        return ResultCard(mission: mission);
                      });

                return SizedBox.shrink();
              },
            ),
          ],
        ),
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
