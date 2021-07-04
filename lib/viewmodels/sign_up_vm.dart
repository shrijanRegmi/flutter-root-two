import 'package:flutter/cupertino.dart';
import 'package:root_two/services/app/ad_provider.dart';
import 'package:root_two/services/firebase/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreenVm extends ChangeNotifier {
  BuildContext context;
  SignUpScreenVm({@required this.context});

  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;

  String _errorMessage;
  String get errorMessage => _errorMessage;

// sign up user
  void signUpUser(
      {final String name, final String email, final String pass}) async {
    _errorMessage = null;
    final _adProvider = Provider.of<AdProvider>(context, listen: false);
    if (name != "" && email != "" && pass != "") {
      FocusScope.of(context).unfocus();
      _updateProgressbar(true);
      final _result = await AuthProvider()
          .signUpWithEmailAndPassword(name: name, email: email, password: pass);
      _handleErrorMessage(_result);
      if (_result != null) {
        _updateProgressbar(false);
      } else {
        _adProvider.showInterstitialAd(forced: true);
      }
    }
  }

// update progress bar
  void _updateProgressbar(final bool newVal) {
    _showProgressBar = newVal;
    notifyListeners();
  }

// handle error message
  void _handleErrorMessage(_result) {
    if (_result != null) {
      switch (_result.message) {
        case "The email address is badly formatted.":
          _errorMessage = "Invalid email address. Try correcting the email";
          break;
        case "The email address is already in use by another account.":
          _errorMessage =
              "The email address is already in use by another account.\nUse a different email.";
          break;
        default:
      }
    }
    notifyListeners();
  }
}
