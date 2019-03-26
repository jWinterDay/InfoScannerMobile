import 'dart:async';
import 'auth_api_provider.dart';
import 'package:info_scanner_mobile/models/logged_user_info.dart';

class AuthRepository {
  final AuthApiProvider _loginProvider = new AuthApiProvider();

  Future<LoggedUserInfo> login(String email, String password) => _loginProvider.login(email, password);
  Future<LoggedUserInfo> getUserLocal() => _loginProvider.getUserLocal();
  Future<bool> removeUserLocal() => _loginProvider.removeUserLocal();
}