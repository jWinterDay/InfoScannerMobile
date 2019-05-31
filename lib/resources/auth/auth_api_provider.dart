import 'dart:convert';
import 'package:info_scanner_mobile/models/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/common.dart';
import 'package:info_scanner_mobile/resources/constants.dart';

class AuthApiProvider {
  Common _common = new Common();
  
  //http login
  Future<LoggedUserInfo> login(String email, String password) async {
    Map<String, String> params = {
      'email': email,
      'password': password,
    };
    
    final response = await _common.httpWrapper(Constants.loginUrl, params: params);

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return await _common.saveTokenLocal(responseJson);
    }
    
    throw '${response.statusCode} ${response.body}';
  }
}