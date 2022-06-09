
import 'package:flutter/widgets.dart';
import 'package:frontend/repositories/api.dart';

class LoginState extends ChangeNotifier {
  static LoginState? _instance;
  
  LoginState._() {
    _isLoggedIn = ApiDatasource.instance.jwt != null;
  }

  static LoginState get instance {
    _instance ??= LoginState._();
    return _instance!;
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}