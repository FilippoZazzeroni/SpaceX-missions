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

  static const suggestedSearch = ["Thaicom", "Echostar", "Starlink"];

  PaginationState _state = PaginationState.suggestedSearchPage;

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
  ErrorCardData _error =
      ErrorCardData(title: "No data", imgPath: "assets/svgs/no_data.svg");

  //! getters

  List<Mission> get missions => _missions;

  PaginationState get state => _state;

  ErrorCardData get error => _error;

  String get search => _search;

  //! methods

  void _setState(PaginationState state) {
    _state = state;
    notifyListeners();
  }

  /// It sets the PaginationState to [PaginationState.suggestedSearchPage] because the user is going
  /// to exit from the search feature. Delete possibly current call to the api
  void clearMissions() {
    if (_debounceTimer != null) _debounceTimer!.cancel();
    if (_missions.isNotEmpty) _missions.clear();
    _setState(PaginationState.suggestedSearchPage);
  }

  void fetchMissions(String search) async {
    if (search.length <= 3) return;

    _search = search;

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
              title: e.message,
              imgPath: "assets/svgs/no_connection.svg",
              hasRefreshButton: true);
        else
          _error = ErrorCardData(
              title: e.message,
              imgPath: "assets/svgs/server_error.svg",
              hasRefreshButton: true);
        _setState(PaginationState.firstPageError);
      } on ServerException catch (e) {
        _error = ErrorCardData(
            title: e.message,
            imgPath: "assets/svg/server_error.svg",
            hasRefreshButton: true);
        _setState(PaginationState.firstPageError);
      }
    });
  }

  /// [isOffsetFixed] is true means that the offset of the search from the api is fixed, so
  /// it is not updated when this function is called again.
  void requestMoreMissions({bool isOffsetFixed = false}) {
    if (_isAllDataFetched || _search.length <= 3) return;

    final preRequestMissionLength = _missions.length;

    _setState(PaginationState.loadingMoreItems);

    if (_debounceTimer != null) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        if (!isOffsetFixed) _offset = _offset + 10;

        _missions.addAll(await _api.fetchData(_search, offset: _offset));

        if (preRequestMissionLength == _missions.length)
          _isAllDataFetched = true;

        _setState(PaginationState.itemsFetched);
      } on FetchDataException catch (e) {
        if (e.code == "NO_INTERNET_CONNECTION")
          _error = ErrorCardData(
              title: e.message,
              imgPath: "assets/svgs/no_connection.svg",
              hasRefreshButton: true);
        else
          _error = ErrorCardData(
              title: e.message,
              imgPath: "assets/svgs/server_error.svg",
              hasRefreshButton: true);
        _setState(PaginationState.nextPageError);
      } on ServerException catch (e) {
        _error = ErrorCardData(
            title: e.message,
            imgPath: "assets/svg/server_error.svg",
            hasRefreshButton: true);
        _setState(PaginationState.nextPageError);
      }
    });
  }
}
