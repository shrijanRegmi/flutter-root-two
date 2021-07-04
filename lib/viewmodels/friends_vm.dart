import 'package:flutter/material.dart';

class FriendsVm extends ChangeNotifier {
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  String _searchText = "";
  String get searchText => _searchText;

  // update typing
  void updateTyping({@required bool newTyping}) {
    _isTyping = newTyping;
    notifyListeners();
  }

  // update search text
  void updateSearchText({@required String newSearchText}) {
    _searchText = newSearchText;
    print(newSearchText);
    notifyListeners();
  }
}
