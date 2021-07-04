import 'package:flutter/material.dart';
import 'package:root_two/models/app/questions.dart';
import 'package:root_two/services/app/ad_provider.dart';
import 'package:root_two/viewmodels/level_vm.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/views/widgets/appbar.dart';
import 'package:provider/provider.dart';

class LevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _adProvider = Provider.of<AdProvider>(context);

    return ViewModelProvider<LevelViewModel>(
      viewModel: LevelViewModel(context: context),
      onInit: (vm) {
        _adProvider.loadInterstitialAd();
      },
      builder: (_model) {
        return Scaffold(
          backgroundColor: Color(0xfff3f3f3),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                MyAppBar(
                  title: "Levels",
                  color: Color(0xff413D7A),
                  function: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                _levelList(_model),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _levelList(LevelViewModel _model) {
    return Expanded(
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: gameQuestion.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemBuilder: (context, index) {
          return _levelItem(context, index + 1, _model);
        },
      ),
    );
  }

  Widget _levelItem(
    final BuildContext context,
    int _level,
    LevelViewModel _model,
  ) {
    final _adProvider = Provider.of<AdProvider>(context);

    return GestureDetector(
      onTap: () {
        _model.onClickLevelItem(_level);
        _adProvider.showInterstitialAd(chance: 50);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: _level == _model.completedLevels.length
                    ? Colors.blueAccent
                    : Color(0xff413D7A),
              ),
              child: Center(
                child: Text(
                  "$_level",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            _model.completedLevels.contains(_level + 1)
                ? Positioned(
                    top: 2.0,
                    right: 2.0,
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 18.0,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
