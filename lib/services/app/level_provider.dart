import 'package:flutter/cupertino.dart';

class LevelProvider extends ChangeNotifier {
  int _level = 1;
  int get level => _level;

  // update the level
  void updateLevel(int _newLevel) {
    _level = _newLevel;
    notifyListeners();
  }
}
