import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/models/pagination_state.dart';
import 'package:spacex_missions/shared/custom_color.dart';
import 'package:spacex_missions/shared/custom_shadow.dart';
import 'package:spacex_missions/shared/custom_text_style.dart';
import 'package:spacex_missions/shared/helper_widgets/error_card.dart';
import 'package:spacex_missions/shared/helper_widgets/loading_indicator.dart';
import 'package:spacex_missions/shared/helper_widgets/result_card.dart';
import 'package:spacex_missions/view_models/missions_view_model.dart';
import 'package:spacex_missions/view_models/search_bar_view_model.dart';
import 'package:spacex_missions/views/home_view/search_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scrollController = ScrollController();

  late final MissionsViewModel _missionsViewModel;

  late final SearchBarViewModel _searchBarViewModel;

  @override
  void initState() {
    _missionsViewModel = context.read<MissionsViewModel>();
    _searchBarViewModel = context.read<SearchBarViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomColors.backgroundGradient),
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
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  SearchBar(),
                  Flexible(
                    child: NotificationListener(
                      onNotification: (notification) {
                        if (!_scrollController.hasClients) return false;

                        if (notification is ScrollEndNotification &&
                            _scrollController.position.extentAfter < 400) {
                          // Prevents to call requestMoreMissions() when error occured while calling the same function
                          // or when the state is PaginationState.loadingMoreItems
                          if (_missionsViewModel.state !=
                                  PaginationState.nextPageError &&
                              _missionsViewModel.state !=
                                  PaginationState.loadingMoreItems)
                            _missionsViewModel.requestMoreMissions();
                        }

                        return false;
                      },
                      child: Consumer<MissionsViewModel>(
                        builder:
                            (BuildContext context, MissionsViewModel model, _) {
                          if (model.state ==
                              PaginationState.suggestedSearchPage)
                            return _buildSuggestedSearches();

                          if (model.state == PaginationState.firstPageError)
                            return ErrorCard(
                              data: model.error,
                              onRefreshButtonPressed:
                                  model.error.hasRefreshButton
                                      ? () => model.fetchMissions(model.search)
                                      : null,
                            );

                          if (model.state == PaginationState.loadingFirstPage)
                            return Center(child: LoadingIndicator());

                          if (model.state == PaginationState.noItmes)
                            return ErrorCard(
                              data: model.error,
                            );

                          if (model.state == PaginationState.itemsFetched ||
                              model.state == PaginationState.loadingMoreItems ||
                              model.state == PaginationState.nextPageError)
                            return ListView.builder(
                                controller: _scrollController,
                                //length + 1 allows to ad progress indicator at the end of the view
                                itemCount: model.missions.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == model.missions.length) {
                                    if (model.state ==
                                        PaginationState.loadingMoreItems)
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: LoadingIndicator(),
                                      );
                                    if (model.state ==
                                        PaginationState.nextPageError)
                                      return ErrorCard(
                                        data: model.error,
                                        onRefreshButtonPressed: model
                                                .error.hasRefreshButton
                                            ? () => model.requestMoreMissions(
                                                isOffsetFixed: true)
                                            : null,
                                      );
                                  }
                                  // prevent range error when exctracing value from model.missions
                                  if (index == model.missions.length)
                                    return SizedBox.shrink();

                                  final mission = model.missions[index];

                                  return ResultCard(mission: mission);
                                });

                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedSearches() {
    final widgets = <Widget>[];
    MissionsViewModel.suggestedSearch.forEach((search) {
      widgets.add(TextButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.black)),
          onPressed: () {
            _searchBarViewModel.suggestedSearch = search;
            _missionsViewModel.fetchMissions(search);
          },
          child: Text(
            search,
            style: CustomTextStyles.body,
          )));
    });

    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.fromLTRB(15.0, 0, 15.0, 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: [CustomShadow.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Suggested search",
            style: CustomTextStyles.title,
          )
        ]..addAll(widgets),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
