
import 'package:frontend/states/login_state.dart';
import 'package:frontend/repositories/auth.dart';

class AuthService {
  static AuthService? _instance;
  late AuthRepository authRepository;
  late LoginState loginState;

  AuthService(this.authRepository) {
    loginState = LoginState.instance;
  }

  static AuthService get instance {
    _instance ??= AuthService(
      AuthApiRepository()
    );
    return _instance!;
  }

  Future<void> register(String username, String password) async {
    try {
      await AuthApiRepository().register(username, password);
      loginState.setLoggedIn(true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      await AuthApiRepository().login(username, password);
      loginState.setLoggedIn(true);
    } catch (e) {
      rethrow;
    }
  }

  bool isLoggedIn() {
    return AuthApiRepository().isLoggedIn();
  }

  void logout() {
    AuthApiRepository().logout();
    loginState.setLoggedIn(false);
  }
}