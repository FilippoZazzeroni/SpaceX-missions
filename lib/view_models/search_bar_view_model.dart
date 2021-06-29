import 'package:flutter/cupertino.dart';
import 'package:spacex_missions/models/search_bar_state.dart';

/// view model assigned to the search bar widget. it is used to handle the states of the search bar
class SearchBarViewModel extends ChangeNotifier {
  String _suggestedSearch = "";

  SearchBarState _state = SearchBarState.hidden;

  String get suggestedSearch => _suggestedSearch;

  SearchBarState get state => _state;

  set suggestedSearch(String search) {
    _suggestedSearch = search;
    setState(SearchBarState.findSuggestedSearch);
  }

  void setState(SearchBarState state) {
    _state = state;
    notifyListeners();
  }
}
