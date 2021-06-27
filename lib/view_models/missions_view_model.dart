import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacex_missions/models/api/api.dart';
import 'package:spacex_missions/models/mission.dart';
import 'package:spacex_missions/models/pagination_state.dart';

/// View model responsible to request data from the SpaceX api
/// and to notify the [HomeView] with the data collected.
class MissionsViewModel extends ChangeNotifier {
  final _api = Api();

  // initial state of the page is without items to show
  PaginationState _state = PaginationState.noItmes;

  // timer used to dealy calls on the api, and to not allow user to make much requests to the server
  Timer? _debounceTimer;

  List<Mission> _missions = [];

  int _offset = 0;

  // true when all data for the specified mission was fetched
  // it prevents to call the api when all data are fetched
  bool _isAllDataFetched = false;

  //! getters

  List<Mission> get missions => _missions;

  PaginationState get state => _state;

  //! methods

  void _setState(PaginationState state) {
    _state = state;
    notifyListeners();
  }

  void fetchMissions(String mission) async {
    // if string length is minor than 3 characters api is not called
    //! 0 is for test
    if (mission.length <= 0) return;

    // restore to initial value
    _offset = 0;
    // restore to initial value
    _isAllDataFetched = false;

    _setState(PaginationState.loadingFirstPage);

    if (_debounceTimer != null) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        _missions = await _api.fetchData(mission);

        if (_missions.isEmpty)
          _setState(PaginationState.noItmes);
        else
          _setState(PaginationState.itemsFetched);
      } catch (e) {
        //TODO Handle exceptions here using _state
        print(e);
      }
    });
  }

  //TODO ad comment for arguments
  void requestMoreMissions(String mission) {
    if (_isAllDataFetched) return;

    final preRequestMissionLength = _missions.length;

    _offset = _offset + 15;

    _setState(PaginationState.loadingMoreItems);

    if (_debounceTimer != null) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        //TODO da rendere variabile offset
        _missions.addAll(await _api.fetchData(mission, offset: _offset));

        if (preRequestMissionLength == _missions.length)
          _isAllDataFetched = true;

        _setState(PaginationState.itemsFetched);
      } catch (e) {
        //TODO Handle exceptions here using _state
        print(e);
      }
    });
  }
}
