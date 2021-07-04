import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_two/models/app/questions.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/views/widgets/appbar.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _topPlayers = Provider.of<List<AppUser>>(context);

    return ViewModelProvider(
      viewModel: null,
      onInit: (vm) {},
      builder: (vm) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  MyAppBar(
                    title: "Leaderboard - Top 10",
                    color: Color(0xff413D7A),
                    function: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _topPlayers.length,
                      itemBuilder: (context, index) {
                        final _user = _topPlayers[index];
                        final _widget = _leaderboardBuilder(index + 1, _user);

                        if (index == 0)
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 40.0,
                            ),
                            child: _widget,
                          );

                        return _widget;
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _leaderboardBuilder(final int rank, final AppUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff413D7A),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (rank == 1)
                Positioned(
                  top: -36.0,
                  right: -28.0,
                  child: Transform.rotate(
                    angle: pi / 5,
                    child: SvgPicture.asset(
                      'images/crown.svg',
                      width: 60.0,
                      height: 60.0,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 30.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.userName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Color(0xff413D7A),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    'Level: ${user.level > gameQuestion.length ? gameQuestion.length : user.level}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Color(0xff413D7A),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'Points: ${user.points}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Color(0xff413D7A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
