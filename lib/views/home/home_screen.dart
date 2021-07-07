import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_two/models/app/options.dart';
import 'package:root_two/models/app/questions.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/app/level_provider.dart';
import 'package:root_two/services/app/save_data.dart';
import 'package:root_two/viewmodels/home_vm.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/views/widgets/drawer.dart';
import 'package:root_two/views/widgets/optionItem.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    final _topPlayersList = Provider.of<List<AppUser>>(context);

    return _user == null || _topPlayersList == null
        ? Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ViewModelProvider<HomeViewModel>(
            viewModel: HomeViewModel(context: context),
            onInit: (vm) {
              vm.onInit(_user);
            },
            builder: (HomeViewModel vm) {
              return Scaffold(
                backgroundColor: Color(0xfff3f3f3),
                key: _scaffoldKey,
                endDrawer: MyDrawer(_user),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _userStats(
                          vm,
                          _user,
                          Color(0xff413D7A),
                          _scaffoldKey,
                        ),
                        _gameSection(vm),
                        _optionsList(vm, context),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _userStats(
    HomeViewModel vm,
    AppUser _user,
    Color _color,
    final _scaffoldKey,
  ) {
    final _topPlayersList = Provider.of<List<AppUser>>(context) ?? [];
    final _user = Provider.of<AppUser>(context);

    final _rank =
        _topPlayersList.indexWhere((element) => element.uid == _user.uid) + 1;
    return Container(
        height: 340.0,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Container(
                    child: Text(
                      _getUserName(_user),
                      style: TextStyle(
                        fontSize: 36.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Level",
                              style: TextStyle(
                                  color: Colors.yellow, fontSize: 10.0),
                            ),
                            Text(
                              "${_user.level > gameQuestion.length ? gameQuestion.length : _user.level}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Points",
                              style: TextStyle(
                                  color: Colors.yellow, fontSize: 10.0),
                            ),
                            Text(
                              "${_user.points}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Rank",
                              style: TextStyle(
                                  color: Colors.yellow, fontSize: 10.0),
                            ),
                            Text(
                              _rank != 0 ? "$_rank" : "--",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Container(
                  width: 45.0,
                  height: 40.0,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset("images/menu.svg"),
                ),
              ),
            )
          ],
        ));
  }

  Widget _gameSection(HomeViewModel vm) {
    return Container(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Train your skills",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.0,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _optionsList(HomeViewModel vm, BuildContext context) {
    final _levelProvider = Provider.of<LevelProvider>(context);
    final _saveData = Provider.of<SaveData>(context);
    final _user = Provider.of<AppUser>(context);
    return Container(
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: optionsList.length,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 50.0, bottom: 10.0),
              child: GestureDetector(
                onTap: () {
                  vm.handleHomeNavigation(
                    optionsList[index],
                    _levelProvider,
                    _user,
                    _saveData,
                  );
                },
                child: OptionsItem(optionsList[index]),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                vm.handleHomeNavigation(
                  optionsList[index],
                  _levelProvider,
                  _user,
                  _saveData,
                );
              },
              child: OptionsItem(optionsList[index]),
            ),
          );
        },
      ),
    );
  }

  String _getUserName(AppUser _user) {
    return _user.userName.contains(" ")
        ? _user.userName.substring(0, _user.userName.indexOf(" ") + 1).length <=
                10
            ? "Welcome\n${_user.userName.substring(0, _user.userName.indexOf(" ") + 1)}"
            : "Welcome\n${_user.userName.substring(0, _user.userName.indexOf(" ") + 1).substring(0, 8)}..."
        : _user.userName.length <= 10
            ? "Welcome\n${_user.userName}"
            : "Welcome\n${_user.userName.substring(0, 8)}...";
  }
}
