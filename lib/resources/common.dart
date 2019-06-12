import 'dart:convert' show base64, json;
import 'dart:io';
import 'package:info_scanner_mobile/global_injector.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/constants.dart';
import 'exceptions.dart';


class Common {
  static final DateFormat dateFormatter = new DateFormat('yyyy.MM.dd HH:mm:ss');

  final String host = globalInjector.get<String>(key: 'host');

  static String formatUnixDate(val) {
    if (val == null) {
      return '';
    }

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(val);
    String str = dateFormatter.format(dt);

    return str;
  }
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


  ///diffTimeWithServer = token.iat - current unix time
  Future<LoggedUserInfo> updateLoggedUserLocal(Map<String, dynamic> obj) async {
    String token = obj['token'];
    String refreshToken = obj['refreshToken'];

    var payloadJSON = getPayloadJSON(token);

    //int curTimeUnixSec = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    LoggedUserInfo user = LoggedUserInfo.fromJson(payloadJSON);
    user.token = token;
    user.refreshToken = refreshToken;
    //user.serverMinusCurTimeSec = payloadJSON['iat'] - curTimeUnixSec;

    await saveUserLocal(user);

    return user;
  }

  //save user to local machine
  Future<void> saveUserLocal(LoggedUserInfo user) async {
    if (user == null) { return; }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJSON = user.toRawJson();
    await prefs.setString(Constants.prefUser, userJSON);
  }

  Future<LoggedUserInfo> saveTokenLocal(String nextToken) async {//}, String refreshToken) async {
    var payloadJSON = getPayloadJSON(nextToken);

    int curTimeUnixSec = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    LoggedUserInfo user = LoggedUserInfo.fromJson(payloadJSON);
    user.token = nextToken;
    //user.refreshToken = refreshToken;
    //user.serverMinusCurTimeSec = payloadJSON['iat'] - curTimeUnixSec;

    await saveUserLocal(user);

    return user;
  }

  Map<String, dynamic> getPayloadJSON(String token) {
    if (token == null) {
      throw AuthException(statusCode: 401, message: 'Token is null');
    }

    List<String> segments = token.split('.');
    if (segments.length != 3) {
      throw AuthException(statusCode: 401, message: 'Not enough or too many segments');
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



  //get user from local machine
  Future<LoggedUserInfo> getUserLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userStr = prefs.getString(Constants.prefUser);
    if (userStr == null) { return null; }
    return LoggedUserInfo.fromRawJson(userStr);
  }

  //remove user from local machine
  Future<bool> removeUserLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(Constants.prefUser);
  }

  Future<http.Response> httpWrapper(String url, {Map<String, String> params, Map<String, String> headers, Duration duration = const Duration(seconds: 5)}) async {
    print('url = $url');
    headers ??= new Map();

    //headers[HttpHeaders.contentTypeHeader] = 'application/json';
    if (headers[HttpHeaders.contentTypeHeader] == null) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }
     
    LoggedUserInfo user = await getUserLocal();

    if (user != null && user.token != null) {
      var payload = getPayloadJSON(user.token);

      bool isValidTokenTime = _checkTokenValid(payload);//, user.serverMinusCurTimeSec);
      if (!isValidTokenTime) {
        var rtResponse = await _httpRefreshToken();
        
        if (rtResponse.statusCode == 200) {
          //print('>>>>>>>>>>>> ${rtResponse.body}');
          String nextToken = rtResponse.body;
          saveTokenLocal(nextToken);//, user.refreshToken);
          //final responseJson = json.decode(rtResponse.body);
          //await saveTokenLocal(responseJson);
        }

        if (rtResponse.statusCode == 401) {
          throw AuthException(statusCode: 401, message: 'Invalid refresh token info');
        }
      }

      //reopen local user with updated info(if we got new data)
      user = await getUserLocal();
      headers[HttpHeaders.authorizationHeader] = 'Bearer ' + user.token;
    }

    final response = await http.post(
      url,
      body: json.encode(params),
      headers: headers
    )
    .timeout(duration, onTimeout: () {
      throw AuthException(statusCode: 500, message: 'Timeout exception');
    });

    //test: await Future.delayed(Duration(seconds: 5));

    return response;
  }

  bool _checkTokenValid(Map<String, dynamic> payload) {//}, int serverMinusCurTimeSec) {
    if (payload == null || payload['exp'] == null) {
      throw AuthException(statusCode: 401, message: 'Empty token info');
    }

    int expUnixTimeSec = payload['exp'];//jsonwebtoken presents expire date as seconds
    int curUnixTimeSec = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    //print('expUnixTimeSec = $expUnixTimeSec, curUnixTimeSec = $curUnixTimeSec, serverMinusCurTimeSec = $serverMinusCurTimeSec');

    //translate mobile current time to server time (current mobile time + diff)
    return expUnixTimeSec > (curUnixTimeSec);// + serverMinusCurTimeSec);
  }

  Future<http.Response> _httpRefreshToken({Duration duration = const Duration(seconds: 5)}) async {
    LoggedUserInfo user = await getUserLocal();

    if (user != null && user.refreshToken != null) {
      var payload = getPayloadJSON(user.refreshToken);

      if (payload == null || payload['exp'] == null) {
        throw AuthException(statusCode: 401, message: 'Empty refresh token info');
      }

      bool isValidTokenTime = _checkTokenValid(payload);//, user.serverMinusCurTimeSec);

      if (!isValidTokenTime) {
        throw AuthException(statusCode: 401, message: 'Invalid refresh token');
      }

      /*int expUnixTimeMs = (payload['exp'] * 1000).round();//jsonwebtoken presents expire date as seconds
      int curUnixTimeMs = DateTime.now().millisecondsSinceEpoch;

      if (curUnixTimeMs > expUnixTimeMs) {
        throw AuthException('Invalid refresh token', 401);
      }*/

      Map<String, String> headers = new Map();
      headers[HttpHeaders.authorizationHeader] = 'Bearer ' + user.refreshToken;

      final response = await http.post(
        host + '/refresh_token',
        headers: headers,
      )
      .timeout(duration, onTimeout: () {
        throw AuthException(statusCode: 401, message: 'Timeout exception');
      });

      return response;
    }

    throw AuthException(statusCode: 401, message: 'Invalid refresh token info');
  }
}