import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:info_scanner_mobile/Database.dart';// as database;
import 'package:info_scanner_mobile/models/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/constants.dart';

final String loginUrl = 'http://192.168.1.42:3001/auth/ajax/login';

class AuthApiProvider {
  //http login
  Future<LoggedUserInfo> login(String email, String password) async {
    Map<String, String> params = {
      'email': email,
      'password': password,
    };

    //do post
    final response = await http.post(
      loginUrl,
      body: params,
    )
    .timeout(Duration(seconds: 5), onTimeout: () {
      throw 'Timeout exception';
    });

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      String token = responseJson['token'];
      String refreshToken = responseJson['refreshToken'];
      var payloadJSON = getPayloadJSON(token);
      LoggedUserInfo user = LoggedUserInfo.fromMap(payloadJSON);
      user.token = token;
      user.refreshToken = refreshToken;

      await saveUserLocal(user);
      return user;
    }
    
    throw '${response.statusCode} ${response.body}';
  }

  //parse token
  getPayloadJSON(String token) {
    if (token == null) { return null; }

    String base64Url = token?.split('.')[1];
    String base64Str = base64Url.replaceAll('-', '+').replaceAll('_', '/');
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

  //save user to local machine
  /*Future saveUserLocal(LoggedUserInfo user) async {
    if (user == null) { return; }
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt(Constants.prefUserUserId, user.userId);
    await prefs.setString(Constants.prefUserFirstName, user.firstName);
    await prefs.setString(Constants.prefUserLastName, user.lastName);
    await prefs.setString(Constants.prefUserFullName, user.fullName);

    await prefs.setString(Constants.prefUserEmail, user.email);
    await prefs.setString(Constants.prefUserToken, user.token);
    await prefs.setString(Constants.prefUserRefreshToken, user.refreshToken);
    await prefs.setStringList(Constants.prefUserRoles, user.roles);
  }

  //get user from local machine
  Future<LoggedUserInfo> getUserLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    LoggedUserInfo user = new LoggedUserInfo(
      userId: prefs.getInt(Constants.prefUserEmail),
      firstName: prefs.getString(Constants.prefUserFirstName),
      lastName: prefs.getString(Constants.prefUserLastName),
      fullName: prefs.getString(Constants.prefUserFullName),

      email: prefs.getString(Constants.prefUserEmail),
      token: prefs.getString(Constants.prefUserToken),
      refreshToken: prefs.getString(Constants.prefUserRefreshToken),

      roles: prefs.getStringList(Constants.prefUserRoles),
    );

    return user;
  }

  //save user to local machine
  Future saveTokenLocal(String token) async {
    if (token == null) { return; }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.prefUserToken, token);
  }

  //get token from local machine
  Future<String> getTokenLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.prefUserToken);
  }

  //save token to local machine
  Future<String> getEmailLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.prefUserEmail);
  }*/
}