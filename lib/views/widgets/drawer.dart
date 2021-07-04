import 'package:flutter/material.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/firebase/auth/auth_provider.dart';

class MyDrawer extends StatefulWidget {
  final AppUser _user;
  MyDrawer(this._user);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  color: Colors.blueAccent,
                  height: 205.0,
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    currentAccountPicture: CircleAvatar(
                      child: Text(
                        widget._user.userName.substring(0, 1),
                        style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    accountName: Text(widget._user.userName),
                    accountEmail: Text(widget._user.userEmail),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color(0xff413D7A),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ListTile(
                              title: Text("Points",
                                  style: TextStyle(color: Colors.white)),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "${widget._user.points}",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Levels completed",
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "${widget._user.level - 1}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Light bulbs",
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "${widget._user.lightBulbs}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Divider(
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Log out",
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              onTap: () {
                                AuthProvider().signOut();
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
