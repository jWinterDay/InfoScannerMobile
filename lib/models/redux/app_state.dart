import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/common.dart';

@immutable
class AppState {
  final LoggedUserInfo loggedUserInfo;

  //constructor
  AppState({@required this.loggedUserInfo});

  static Future<AppState> initAsync() async {
    Common common = new Common();
    LoggedUserInfo user = await common.getUserLocal();

    return AppState(
      loggedUserInfo: user,
    );
  }

  AppState copyWith({
    LoggedUserInfo loggedUserInfo
  }) =>
    AppState(loggedUserInfo: loggedUserInfo);

  @override
  String toString() => '(loggedUserInfo: $loggedUserInfo)';
}