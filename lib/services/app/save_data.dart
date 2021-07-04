import 'package:flutter/cupertino.dart';
import 'package:root_two/enums/value_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveData extends ChangeNotifier {
// save data in memory
  void saveData(String key, ValueType type, final value) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    switch (type) {
      case ValueType.string:
        _pref.setString(key, value);
        break;
      case ValueType.integer:
        _pref.setInt(key, value);
        break;
      case ValueType.boolean:
        _pref.setBool(key, value);
        break;
      default:
    }
  }

// get data from memory
  Future getData(key) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.get(key);
  }
}
