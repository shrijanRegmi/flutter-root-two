import 'package:flutter/material.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/firebase/database/database_provider.dart';
import 'package:provider/provider.dart';

class WrapperBuilder extends StatelessWidget {
  final Widget Function() builder;
  WrapperBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    // print(_user.userName);
    if (_user != null) {
      return MultiProvider(
        providers: [
          StreamProvider<AppUser>.value(
            initialData: null,
            value: DatabaseProvider(
              uid: _user.uid,
            ).userDetail,
          ),
          StreamProvider<List<AppUser>>.value(
            initialData: null,
            value: DatabaseProvider(uid: _user.uid).topPlayerList,
          ),
          Provider<DatabaseProvider>(
            create: (_) => DatabaseProvider(
              uid: _user.uid,
            ),
          ),
        ],
        child: builder(),
      );
    }
    return builder();
  }
}
