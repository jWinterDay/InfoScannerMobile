import 'dart:async';

import 'auth_api_provider.dart';
import 'package:info_scanner_mobile/models/auth/auth_model.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/common.dart';

class AuthRepository {
  //Common _common = new Common();
  final AuthApiProvider _loginProvider = new AuthApiProvider();

  Future<LoggedUserInfo> login(AuthModel authModel) => _loginProvider.login(authModel);
  //Future<LoggedUserInfo> getUserLocal() => _common.getUserLocal();
  //Future<bool> removeUserLocal() => _common.removeUserLocal();
}