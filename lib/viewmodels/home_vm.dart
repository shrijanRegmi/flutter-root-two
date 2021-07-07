import 'package:flutter/material.dart';
import 'package:root_two/models/app/options.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/app/level_provider.dart';
import 'package:root_two/services/app/save_data.dart';
import 'package:root_two/services/firebase/database/database_provider.dart';
import 'package:root_two/views/home/leaderboard_screen.dart';
import 'package:root_two/views/home/level_screen.dart';
import 'package:root_two/views/home/play_screen.dart';

class HomeViewModel extends ChangeNotifier {
  final BuildContext context;
  HomeViewModel({@required this.context});

  int _rank;
  static final _now = DateTime.now();
  final _currentDate = DateTime(_now.year, _now.month, _now.day);

  int get rank => _rank;

  // init function
  void onInit(final AppUser appUser) {
    if (appUser.lightBulbRefillsAt != null) {
      final _refill = _currentDate.isAfter(DateTime.fromMillisecondsSinceEpoch(
              appUser.lightBulbRefillsAt)) ||
          _currentDate.isAtSameMomentAs(
              DateTime.fromMillisecondsSinceEpoch(appUser.lightBulbRefillsAt));

      if (_refill && appUser.lightBulbs < 5) {
        DatabaseProvider(uid: appUser.uid).updateUserInfo(
          lightBulbs: 5,
          lightBulbRefillsAt:
              _currentDate.add(Duration(days: 1)).millisecondsSinceEpoch,
        );
      }
    } else {
      if (appUser.lightBulbs < 5) {
        DatabaseProvider(uid: appUser.uid).updateUserInfo(
          lightBulbs: 5,
          lightBulbRefillsAt:
              _currentDate.add(Duration(days: 1)).millisecondsSinceEpoch,
        );
      }
    }
  }

  // update rank
  void updateRank({@required int newRank}) {
    _rank = newRank;
    notifyListeners();
  }

  // handle navigation on click
  handleHomeNavigation(
    Options _options,
    LevelProvider _levelProvider,
    AppUser _user,
    SaveData _saveData,
  ) {
    switch (_options.title) {
      case "Quick Play":
        _levelProvider.updateLevel(_user.level);
        return Navigator.push(
            context, MaterialPageRoute(builder: (_) => PlayScreen()));
        break;
      case "Levels":
        _levelProvider.updateLevel(_user.level);
        return Navigator.push(
            context, MaterialPageRoute(builder: (_) => LevelScreen()));
        break;
      case "Leaderboard":
        _levelProvider.updateLevel(_user.level);
        return Navigator.push(
            context, MaterialPageRoute(builder: (_) => LeaderboardScreen()));
        break;
      default:
        return null;
    }
  }
}
