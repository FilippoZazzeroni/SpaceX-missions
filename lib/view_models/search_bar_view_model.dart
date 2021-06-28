import 'package:flutter/cupertino.dart';

/// view model assigned to the search bar widget. it is used to handle the states of the search bar
class SearchBarViewModel extends ChangeNotifier {
  // true means the text field of the search bar is hidden
  bool _isSearchBarHidden = true;

  bool get isSearchBarHidden => _isSearchBarHidden;

  set isSearchBarHidden(bool value) {
    _isSearchBarHidden = value;
    notifyListeners();
  }
}
