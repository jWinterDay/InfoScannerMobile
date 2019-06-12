import 'dart:async';

import 'auth_api_provider.dart';
import 'package:info_scanner_mobile/models/auth/auth_model.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/global_injector.dart';


class AuthRepository {
  final AuthApiProvider _loginProvider = globalInjector.get<AuthApiProvider>();

  String get initEmail => _loginProvider.initEmail;
  String get initPassword => _loginProvider.initPassword;

  Future<LoggedUserInfo> login(AuthModel authModel) => _loginProvider.login(authModel);
}