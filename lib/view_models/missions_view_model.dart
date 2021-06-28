import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacex_missions/models/api/api.dart';
import 'package:spacex_missions/models/api/api_expections.dart';
import 'package:spacex_missions/models/error_card_data.dart';
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

  // it stores the current search from the user.
  String _search = "";

  int _offset = 0;

  // true when all data for the specified search are fetched
  // it prevents to call the api when there are no more data to get
  bool _isAllDataFetched = false;

  // contains error coming from the api formatted for [ErrorCard]
  //TODO capire se fare un error card data per la pagina iniziale
  ErrorCardData _error =
      ErrorCardData(title: "No data", imgPath: "assets/svgs/no_data.svg");

  //! getters

  List<Mission> get missions => _missions;

  PaginationState get state => _state;

  ErrorCardData get error => _error;

  //! methods

  void _setState(PaginationState state) {
    _state = state;
    notifyListeners();
  }

  void clearMissions() {
    if (_missions.isEmpty) return;
    _missions.clear();
    //TODO aggiungere errore
    _setState(PaginationState.noItmes);
  }

  void fetchMissions(String search) async {
    // if string length is minor than 3 characters api is not called
    if (search.length <= 3) return;

    _search = search;

    // restore to initial value
    _offset = 0;
    // restore to initial value
    _isAllDataFetched = false;

    _setState(PaginationState.loadingFirstPage);

    if (_debounceTimer != null) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        _missions = await _api.fetchData(search);

        if (_missions.isEmpty) {
          _error = ErrorCardData(
              title: "No data found", imgPath: "assets/svgs/no_data.svg");
          _setState(PaginationState.noItmes);
        } else
          _setState(PaginationState.itemsFetched);
      } on FetchDataException catch (e) {
        if (e.code == "NO_INTERNET_CONNECTION")
          _error = ErrorCardData(
              title: "Internet connection absent",
              imgPath: "assets/svgs/no_connection.svg");
        else
          _error =
              //TODO capire titotlo
              ErrorCardData(title: "", imgPath: "assets/svgs/server_error.svg");
        _setState(PaginationState.firstPageError);
      } on ServerException {
        _error =
            //TODO capire titotlo
            ErrorCardData(
                title: "Server error",
                imgPath: "assets/svg/server_error.svg",
                hasRefreshButton: true);
        _setState(PaginationState.firstPageError);
      } on BadRequestException {
        //TODO da capire
      }
    });
  }

  //TODO gestione errori
  void requestMoreMissions() {
    if (_isAllDataFetched || _search.length <= 3) return;

    final preRequestMissionLength = _missions.length;

    _offset = _offset + 15;

    _setState(PaginationState.loadingMoreItems);

    if (_debounceTimer != null) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        //TODO da rendere variabile offset
        _missions.addAll(await _api.fetchData(_search, offset: _offset));

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
