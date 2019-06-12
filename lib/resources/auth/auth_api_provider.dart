import 'dart:convert';
import 'package:info_scanner_mobile/models/auth/auth_model.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/common.dart';
import 'package:info_scanner_mobile/resources/exceptions.dart' as exc;


class AuthApiProvider {
  Common _common = new Common();

  //for inject
  String initEmail;//for init login textfields
  String initPassword;
  
  String host;

  //constructor
  AuthApiProvider(this.initEmail, this.initPassword, this.host);
  
  //http login
  Future<LoggedUserInfo> login(AuthModel authModel) async {
    Map<String, String> params = {
      'email': authModel.email,
      'password': authModel.password,
    };
    
    final response = await _common.httpWrapper(host + '/login', params: params);

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return await _common.updateLoggedUserLocal(responseJson);
    }

    exc.AuthException authException = exc.AuthException.fromRawJson(response.body);
    throw authException;
  }

  Future<void> logout() async {
    _common.removeUserLocal();
  }
}