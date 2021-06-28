import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/models/pagination_state.dart';
import 'package:spacex_missions/shared/custom_color.dart';
import 'package:spacex_missions/shared/helper_widgets/error_card.dart';
import 'package:spacex_missions/shared/helper_widgets/loading_indicator.dart';
import 'package:spacex_missions/shared/helper_widgets/result_card.dart';
import 'package:spacex_missions/view_models/missions_view_model.dart';
import 'package:spacex_missions/views/home_view/search_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scrollController = ScrollController();

  late final MissionsViewModel model;

  @override
  void initState() {
    model = context.read<MissionsViewModel>();
    _scrollController.addListener(() {
      //TODO capire come inserire 10 elementi nella view port, in modo cosi da chiamare request more missions solo qunado e necessario
      // request more data only if the position in the list view is higher than the max scroll extent
      if (_scrollController.position.pixels >
          0.9 * _scrollController.position.maxScrollExtent) {
        model.requestMoreMissions();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomColors.backgroundGradient),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SearchBar(),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      bottom: -50,
                      child: Container(
                        child: SvgPicture.asset(
                          "assets/svgs/background.svg",
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    //TODO handle rebuild quando cala la tastiera
                    Consumer<MissionsViewModel>(
                      builder: (context, model, _) {
                        if (model.state == PaginationState.firstPageError)
                          return Center(child: ErrorCard(data: model.error));

                        if (model.state == PaginationState.loadingFirstPage)
                          return Center(child: LoadingIndicator());

                        if (model.state == PaginationState.noItmes)
                          //TODO attenzione occupa tutto lo schermo
                          return Center(
                              child: ErrorCard(
                            data: model.error,
                          ));

                        if (model.state == PaginationState.itemsFetched ||
                            model.state == PaginationState.loadingMoreItems)
                          return ListView.builder(
                              controller: _scrollController,
                              //length + 1 allows to ad progress indicator at the end of the view
                              //TODO aggiungere length
                              itemCount: model.missions.length,
                              itemBuilder: (context, index) {
                                //TODO capire index
                                if (model.state ==
                                        PaginationState.loadingMoreItems &&
                                    index == model.missions.length - 1) {
                                  //TODO capire errore su index
                                  return LoadingIndicator();
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
