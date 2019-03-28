import 'dart:convert';
import 'package:info_scanner_mobile/models/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/common.dart';

final String loginUrl = 'http://192.168.1.42:3001/auth/ajax/login';

class AuthApiProvider {
  Common _common = new Common();
  
  //http login
  Future<LoggedUserInfo> login(String email, String password) async {
    Map<String, String> params = {
      'email': email,
      'password': password,
    };

    final response = await _common.httpWrapper(loginUrl, params: params);

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return await _common.saveTokenLocal(responseJson);
    }
    
    throw '${response.statusCode} ${response.body}';
  }
}