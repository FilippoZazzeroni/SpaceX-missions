import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacex_missions/models/api/api.dart';
import 'package:spacex_missions/models/api/mission.dart';

/// View model responsible to request data from the SpaceX api
/// and to notify the [HomeView] with the data collected.
class MissionsViewModel extends ChangeNotifier {
  final _api = Api();

  // timer used to dealy calls on the api, and to not allow user to make much requests to the server
  Timer? _debounceTimer;

  List<Mission> _missions = [];

  List<Mission> get missions => _missions;

  void fetchMissions(String mission) async {
    // if string length is minor than 3 characters api is not called
    //! 0 is for test
    if (mission.length <= 0) return;

    if (_debounceTimer != null) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        _missions = await _api.fetchData(mission);
        notifyListeners();
      } catch (e) {
        //TODO Handle exceptions here
        print(e);
      }
    });
  }
}
