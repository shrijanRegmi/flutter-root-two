import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:root_two/services/app/level_provider.dart';
import 'package:root_two/views/home/play_screen.dart';
import 'package:provider/provider.dart';

class LevelViewModel extends ChangeNotifier {
  final BuildContext context;
  LevelViewModel({@required this.context}) {
    fillLevels();
  }

  List<int> _completedLevels = [];
  List<int> get completedLevels => _completedLevels;

  // fill the completed levels list
  void fillLevels() {
    final _levelProvider = Provider.of<LevelProvider>(context, listen: false);

    for (int i = 0; i < _levelProvider.level; i++) {
      _completedLevels.add(i + 1);
    }
    notifyListeners();
  }

  // on click level item
  void onClickLevelItem(int _level) {
    if (_level <= _completedLevels.length) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => PlayScreen(getLevel: _level)));
    }
  }
}
