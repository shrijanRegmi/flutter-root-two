import 'package:flutter/cupertino.dart';
import 'package:root_two/services/app/ad_provider.dart';
import 'package:root_two/services/firebase/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreenVm extends ChangeNotifier {
  BuildContext context;
  LoginScreenVm({@required this.context});

  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;

  String _errorMessage;
  String get errorMessage => _errorMessage;

// login user
  void loginUser({
    final String email,
    final String pass,
  }) async {
    final _adProvider = Provider.of<AdProvider>(context, listen: false);
    _errorMessage = null;
    if (email != "" && pass != "") {
      FocusScope.of(context).unfocus();
      _updateProgressbar(true);
      final _result = await AuthProvider()
          .signInWithEmailAndPassword(email: email, password: pass);
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
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          _errorMessage =
              "It seems like you don't have an account to login.\nCreate one first";
          break;
        case "The password is invalid or the user does not have a password.":
          _errorMessage = "Your password is incorrect";
          break;
        default:
      }
    }
    notifyListeners();
  }
}
