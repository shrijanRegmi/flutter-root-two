import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:root_two/models/app/questions.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/app/ad_provider.dart';
import 'package:root_two/services/app/level_provider.dart';
import 'package:root_two/services/app/show_dialogs.dart';
import 'package:root_two/services/firebase/database/database_provider.dart';
import 'package:root_two/views/home/correct_screen.dart';
import 'package:provider/provider.dart';

class PlayScreenViewModel extends ChangeNotifier {
  final BuildContext context;
  final int level;
  final bool isLevel;

  PlayScreenViewModel({
    @required this.context,
    @required this.level,
    this.isLevel,
  });

  final List<String> _optionsList = [];
  List<String> get optionsList => _optionsList;

  final List<double> _opacityList = List.generate(10, (opacity) => 1.0);
  List<double> get opacityList => _opacityList;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  String _wrongAns = "";
  String get wrongAns => _wrongAns;

  AdProvider get adProvider => Provider.of<AdProvider>(context, listen: false);

  // init function
  void onInit() {
    getOptions();
    adProvider.loadInterstitialAd();
    adProvider.loadRewardedAd();
  }

  // on admob rewarded
  void onRewardedFromAd() {
    final _dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _dbProvider.updateUserInfo(hint: true);
    ShowDialogs(context: context).showHintDialog(level);
    adProvider.updateIsRewardedLoaded(false);
    adProvider.loadRewardedAd();
  }

  // get option function
  void getOptions() {
    final _index = level - 1;
    final _answer = gameQuestion[_index].answer;

    final _count = 10 - _answer.length;
    final _rand = Random();

    for (int i = 0; i < _count; i++) {
      _optionsList.add(_rand.nextInt(9).toString());
    }
    for (int i = 0; i < _answer.length; i++) {
      _optionsList.add(_answer.substring(i, i + 1));
    }

    _optionsList.shuffle();
    notifyListeners();
  }

  // on click option
  void onClickOption(final int _index) {
    if (_opacityList[_index] == 1.0) {
      _wrongAns = "";
      _opacityList[_index] = 0.0;
      _controller.text += _optionsList[_index];
    }
    notifyListeners();
  }

  // on click delete
  void onClickDelete() {
    final _controllerIndex = _controller.text.length - 1;
    if (_controller.text != "") {
      for (int i = 0; i < 10; i++) {
        if (_optionsList[i] ==
                _controller.text
                    .substring(_controllerIndex, _controllerIndex + 1) &&
            _opacityList[i] == 0.0) {
          _opacityList[i] = 1.0;
          break;
        }
      }
      _controller.text = _controller.text.substring(0, _controllerIndex);
    }
    notifyListeners();
  }

  // on answer submitted
  void onAnsSubmitted(
    BuildContext context,
    final _levelProvider,
    final AppUser user,
  ) {
    if (controller.text != "") {
      if (controller.text == gameQuestion[level - 1].answer) {
        onAnsCorrect(context, _levelProvider, user);
      } else {
        onAnsWrong();
      }
    }
  }

  // on answer submitted
  void onAnsCorrect(
    BuildContext context,
    final LevelProvider _levelProvider,
    final AppUser user,
  ) {
    adProvider.showInterstitialAd();
    final _points = user.solution
        ? 1
        : user.hint
            ? 10
            : 20;
    final _gameCompleted = (level >= gameQuestion.length);

    if (level == _levelProvider.level) {
      _updateLevelAndPoints(context, user);
      if (isLevel == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CorrectScreen(
              user: user,
              points: user.level > gameQuestion.length ? -1 : _points,
              gameCompleted: _gameCompleted,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CorrectScreen(
              user: user,
              level: level + 1,
              points: user.level > gameQuestion.length ? -1 : _points,
              gameCompleted: _gameCompleted,
            ),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CorrectScreen(
            user: user,
            level: level + 1,
            points: user.level > gameQuestion.length ? -1 : _points,
            gameCompleted: _gameCompleted,
          ),
        ),
      );
    }
  }

  // on answer submitted
  void onAnsWrong() {
    _wrongAns = "Wrong answer ! Try again";
    _controller.clear();
    for (int i = 0; i < _opacityList.length; i++) {
      _opacityList[i] = 1.0;
    }
    notifyListeners();
  }

  // update level and points
  void _updateLevelAndPoints(BuildContext context, final AppUser user) {
    final _levelProvider = Provider.of<LevelProvider>(context, listen: false);
    final _dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    Timer(Duration(milliseconds: 100), () {
      if (user.level <= gameQuestion.length) {
        _levelProvider.updateLevel(level + 1);
        _dbProvider.updateUserInfo(level: level + 1);

        if (user.solution) {
          _dbProvider.updateUserInfo(
            points: user.points + 1,
            solution: false,
            hint: false,
          );
        } else if (user.hint) {
          _dbProvider.updateUserInfo(
            points: user.points + 10,
            solution: false,
            hint: false,
          );
        } else {
          _dbProvider.updateUserInfo(points: user.points + 20);
        }
      }
    });
  }

  // open hint dialog
  void onPressHint(
    BuildContext context,
    final AppUser user,
    final int level,
  ) {
    final _dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    ShowDialogs(context: context).showlightBulbDialog(
      user: user,
      isRewardedAdLoaded: adProvider.isRewardedLoaded,
      onPressed: (String res) async {
        Navigator.of(context).pop();
        switch (res) {
          case "LIGHTBULB_HINT":
            final _lightbulbs = user.lightBulbs - 1;
            ShowDialogs(context: context).showHintDialog(level);
            await _dbProvider.updateUserInfo(
              lightBulbs: _lightbulbs,
              hint: true,
            );
            break;
          case "LIGHTBULB_SOLUTION":
            final _lightbulbs = user.lightBulbs - 3;
            ShowDialogs(context: context).showSolutionDialog(level);
            await _dbProvider.updateUserInfo(
                lightBulbs: _lightbulbs, solution: true);
            break;
          case "VIDEO_HINT":
            adProvider.showRewardedAd(onRewarded: onRewardedFromAd);
            break;
          case "VIDEO_SOLUTION":
            adProvider.showRewardedAd(onRewarded: onRewardedFromAd);
            break;
          default:
        }
      },
    );
  }
}
