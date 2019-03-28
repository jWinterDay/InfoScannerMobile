import 'dart:convert' show base64, json;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:info_scanner_mobile/models/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/constants.dart';

final String loginUrl = 'http://192.168.1.42:3001/auth/ajax/login';
final String refreshTokenUrl = 'http://192.168.1.42:3001/auth/ajax/refreshtoken';

class Common {
  static boolToInt(dynamic val) {
    var t = val.runtimeType;

    switch (t) {
      case Null:
        return false;
      case int:
        return val;
      case bool:
        return val ? 1 : 0;
      case String:
        return int.tryParse(val);
      default:
        throw Exception('Unknown format');
    }
  }

  static bool inDebug() {
    bool state = false;
    assert(state == true);
    return state;
  }

  Future<LoggedUserInfo> saveTokenLocal(dynamic json) async {
    String token = json['token'];
    String refreshToken = json['refreshToken'];

    var payloadJSON = getPayloadJSON(token);
    LoggedUserInfo user = LoggedUserInfo.fromMap(payloadJSON);
    user.token = token;
    user.refreshToken = refreshToken;

    await saveUserLocal(user);

    return user;
  }

  getPayloadJSON(String token) {
    if (token == null) {
      throw Exception('Token is null');
    }

    List<String> segments = token.split('.');
    if (segments.length != 3) {
      throw Exception('Not enough or too many segments');
    }

    String base64Url = token.split('.')[1];

    //ensure length divives by 4
    int remainder = base64Url.length % 4;
    int rpad = remainder == 0 ? 0 : 4 - remainder;
    if (remainder != 0) {
      base64Url = base64Url.padRight(base64Url.length + rpad, '=');
    }

    String base64Str = base64Url;//.replaceAll('-', '+').replaceAll('_', '/');
    var payloadCharCodes = base64.decode(base64Str);
    String payload = String.fromCharCodes(payloadCharCodes);

    return json.decode(payload);
  }

  //save user to local machine
  Future saveUserLocal(LoggedUserInfo user) async {
    if (user == null) { return; }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJSON = loggedUserToJson(user);
    await prefs.setString(Constants.prefUser, userJSON);
  }

  //get user from local machine
  Future<LoggedUserInfo> getUserLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userStr = prefs.getString(Constants.prefUser);
    if (userStr == null) { return null; }
    return loggedUserFromJson(userStr);
  }

  //remove user from local machine
  Future<bool> removeUserLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(Constants.prefUser);
  }

  Future<http.Response> httpWrapper(String url, {Map<String, String> params, Map<String, String> headers, Duration duration = const Duration(seconds: 5)}) async {
    headers = headers ?? new Map();

    LoggedUserInfo user = await getUserLocal();

    if (user != null && user.token != null) {
      var payload = getPayloadJSON(user.token);
      if (payload == null || payload['exp'] == null) {
        await removeUserLocal();
        throw Exception('Empty token info');
      }

      int expUnixTimeMs = (payload['exp'] * 1000).round();//jsonwebtoken presents expire date as seconds
      int curUnixTimeMs = DateTime.now().millisecondsSinceEpoch;

      if (curUnixTimeMs > expUnixTimeMs) {
        //try get token by refresh token
        var rtResponse = await _httpRefreshToken();
        if (rtResponse.statusCode == 200) {
          final responseJson = json.decode(rtResponse.body);
          await saveTokenLocal(responseJson);
        }
      }

      //reopen local user with updated info(if we got new data)
      user = await getUserLocal();
      headers['Authorization'] = 'Bearer ' + user.token;
    }

    final response = await http.post(
      url,
      body: params,
      headers: headers
    )
    .timeout(duration, onTimeout: () {
      throw 'Timeout exception';
    });

    //
    if (response.statusCode == 200) {
      print('ok. 200');
    }

    if (response.statusCode == 401) {
      print('401');
    }

    return response;
  }

  Future<http.Response> _httpRefreshToken({Duration duration = const Duration(seconds: 5)}) async {
    LoggedUserInfo user = await getUserLocal();

    if (user != null && user.refreshToken != null) {
      var payload = getPayloadJSON(user.refreshToken);
      if (payload == null || payload['exp'] == null) {
        await removeUserLocal();
        throw Exception('Empty refresh token info');
      }

      int expUnixTimeMs = (payload['exp'] * 1000).round();//jsonwebtoken presents expire date as seconds
      int curUnixTimeMs = DateTime.now().millisecondsSinceEpoch;

      if (curUnixTimeMs > expUnixTimeMs) {
        await removeUserLocal();
        throw Exception('Invalid refresh token');
      }

      Map<String, String> headers = new Map();
      headers['Authorization'] = 'Bearer ' + user.refreshToken;

      final response = await http.post(
        refreshTokenUrl,
        headers: headers
      )
      .timeout(duration, onTimeout: () {
        throw 'Timeout exception';
      });

      if (response.statusCode == 401) {
        throw Exception('Invalid refresh token info');
      }

      return response;
    }

    throw Exception('Invalid refresh token info');
  }
}