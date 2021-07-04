import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:root_two/models/app/questions.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/app/level_provider.dart';
import 'package:root_two/viewmodels/play_vm.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/views/widgets/appbar.dart';
import 'package:provider/provider.dart';

class PlayScreen extends StatefulWidget {
  final int getLevel;
  PlayScreen({this.getLevel});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    final _levelProvider = Provider.of<LevelProvider>(context);
    final _user = Provider.of<AppUser>(context);
    var _level =
        widget.getLevel != null ? widget.getLevel : _levelProvider.level;
    _level = _level > gameQuestion.length ? gameQuestion.length : _level;

    return ViewModelProvider<PlayScreenViewModel>(
      viewModel: PlayScreenViewModel(
        context: context,
        level: _level,
        isLevel: widget.getLevel != null ? true : null,
      ),
      onInit: (PlayScreenViewModel vm) {
        vm.onInit();
      },
      builder: (model) {
        return Scaffold(
          backgroundColor: Color(0xff413D7A),
          body: SafeArea(
            child: Container(
              color: Color(0xfff3f3f3),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      MyAppBar(
                        title: "Level: $_level",
                        color: Color(0xff413D7A),
                        isLevelScreen: widget.getLevel != null ? true : null,
                        function: () {
                          Navigator.pop(context);
                        },
                      ),
                      Positioned.fill(
                        right: 20.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.lightbulb_outline,
                                    color: Color(0xff413D7A),
                                  ),
                                  onPressed: () =>
                                      model.onPressHint(context, _user, _level),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _questionSection(_level),
                  Text(
                    "${model.wrongAns}",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  _inputSection(model, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _questionSection(final int _level) {
    final _index = _level - 1;
    final String _question = gameQuestion[_index].question;
    return Expanded(
      flex: 1,
      child: _question.contains("svg")
          ? SvgPicture.asset(_question)
          : Image.asset(_question),
    );
  }

  Widget _inputSection(PlayScreenViewModel _model, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Color(0xff413D7A),
      ),
      padding: const EdgeInsets.fromLTRB(
        20.0,
        20.0,
        20.0,
        40.0,
      ),
      child: Column(
        children: <Widget>[
          _inputTop(_model),
          SizedBox(
            height: 20.0,
          ),
          _numbersList(_model),
          SizedBox(
            height: 20.0,
          ),
          _submitBtn(_model, context),
        ],
      ),
    );
  }

  Widget _inputTop(PlayScreenViewModel _model) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Stack(
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.white),
            enabled: false,
            controller: _model.controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  top: 20.0, bottom: 20.0, left: 10.0, right: 60.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        onPressed: _model.onClickDelete,
                        icon: Icon(Icons.backspace, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _numbersList(PlayScreenViewModel _model) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _model.optionsList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemBuilder: (_, index) {
          return _numbersItem(_model.optionsList[index], index, _model);
        });
  }

  Widget _numbersItem(String _level, int _index, PlayScreenViewModel _model) {
    return GestureDetector(
      onTap: () => _model.onClickOption(_index),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: _model.opacityList[_index],
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.black87,
              ),
              child: Center(
                child: Text("$_level",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          )),
    );
  }

  Widget _submitBtn(PlayScreenViewModel _model, BuildContext context) {
    final _levelProvider = Provider.of<LevelProvider>(context);
    final _user = Provider.of<AppUser>(context);
    return RaisedButton.icon(
      onPressed: () => _model.onAnsSubmitted(context, _levelProvider, _user),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.black87,
      textColor: Colors.white,
      icon: Icon(Icons.check_circle),
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      label: Text("Submit"),
    );
  }
}
