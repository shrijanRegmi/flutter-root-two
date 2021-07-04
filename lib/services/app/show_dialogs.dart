import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_two/models/app/questions.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/views/widgets/normal_btn.dart';
import 'package:root_two/views/widgets/small_btn.dart';
import 'package:provider/provider.dart';

class ShowDialogs {
  BuildContext context;
  ShowDialogs({@required this.context});

  // dialog when user sends play request
  showWaitingDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) => WaitingDialog(),
    );
  }

  // dialog when app is selecting a winner
  showDecidingDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) => SmallDialog(),
    );
  }

  // dialog when app selected a winner
  showWinnerDialog({@required final AppUser friend}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) => WinnerDialog(
        friend: friend,
      ),
    );
  }

  // dialog when user clicks hint
  showlightBulbDialog({
    @required Function(String req) onPressed,
    @required AppUser user,
    final bool isRewardedAdLoaded = false,
  }) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => HintDialog(
        onPressed: onPressed,
        user: user,
        isRewardedAdLoaded: isRewardedAdLoaded,
      ),
    );
  }

  // dialog for showing hint
  showHintDialog(int level) async {
    final _index = level - 1;
    final String _hint = gameQuestion[_index].hint;

    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Hint:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                _hint.contains("svg")
                    ? SvgPicture.asset(_hint)
                    : Image.asset(_hint),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      splashRadius: 30.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // dialog for showing solution
  showSolutionDialog(int level) async {
    final _index = level - 1;
    final String _solution = gameQuestion[_index].solution;

    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Solution:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                _solution.contains("svg")
                    ? SvgPicture.asset(_solution)
                    : Image.asset(_solution),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      splashRadius: 30.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WaitingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 70.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Waiting for other player",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Please don't leave this screen!",
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      NormalBtn(
                        title: "Leave Anyway",
                        color: Colors.blue,
                        function: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 80.0,
                child: Center(
                    child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Deciding winner",
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WinnerDialog extends StatelessWidget {
  final AppUser friend;
  WinnerDialog({@required this.friend});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 70.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Color(0xff1492E6),
                        radius: 30.0,
                        child: Text("${friend.userName.substring(0, 1)}",
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white)),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Geeta Kumari",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        "${_user.userName}, better luck next time.",
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      NormalBtn(
                        title: "Continue",
                        color: Colors.blue,
                        function: () => {Navigator.pop(context)},
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HintDialog extends StatelessWidget {
  final Function(String req) onPressed;
  final AppUser user;
  final bool isRewardedAdLoaded;
  HintDialog({
    @required this.onPressed,
    @required this.user,
    this.isRewardedAdLoaded,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("Your lightbulbs: ${user.lightBulbs}"),
                      SizedBox(
                        height: 10.0,
                      ),
                      SmallBtn(
                        title: "Use 1 lightbulb for hint",
                        color: user.lightBulbs >= 1
                            ? Colors.black87
                            : Colors.black26,
                        function: () {
                          if (user.lightBulbs >= 1)
                            return onPressed("LIGHTBULB_HINT");
                        },
                      ),
                      SmallBtn(
                        title: "Use 3 lightbulbs for solution",
                        color: user.lightBulbs >= 3
                            ? Colors.black87
                            : Colors.black26,
                        function: () {
                          if (user.lightBulbs >= 3)
                            return onPressed("LIGHTBULB_SOLUTION");
                        },
                      ),
                      if (isRewardedAdLoaded)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Divider(),
                        ),
                      if (isRewardedAdLoaded)
                        SmallBtn(
                          title: "Watch a video for hint",
                          color: Colors.black87,
                          function: () => onPressed("VIDEO_HINT"),
                        ),
                      // SmallBtn(
                      //   title: "Watch a video for solution",
                      //   color: Colors.black87,
                      //   function: () => onPressed("VIDEO_SOLUTION"),
                      // ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Remember: If you use hint/solution you will get less points for this level !",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
