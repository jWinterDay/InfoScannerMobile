import 'package:flutter/foundation.dart';
import 'package:info_scanner_mobile/global_injector.dart';
import 'package:info_scanner_mobile/models/redux/ws_info.dart';
import 'package:info_scanner_mobile/models/redux/ws_message.dart';
import 'package:info_scanner_mobile/resources/ws/ws_api_provider.dart';

import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/common.dart';


@immutable
class AppState {
  final LoggedUserInfo loggedUserInfo;
  final WsInfo wsInfo;
  final WsMessage wsMessage;

  //constructor
  AppState({
    @required this.loggedUserInfo,
    @required this.wsInfo,
    @required this.wsMessage,
  });

  static Future<AppState> initAsync() async {
    Common common = new Common();
    LoggedUserInfo user = await common.getUserLocal();

    final WsApiProvider wsApiProvider = globalInjector.get<WsApiProvider>();
    WsInfo wsInfo = await wsApiProvider.createWebSocketChannel();

    return AppState(
      loggedUserInfo: user,
      wsInfo: wsInfo,
      wsMessage: null,
    );
  }

  AppState copyWith({
    LoggedUserInfo loggedUserInfo,
    WsInfo wsInfo,
    WsMessage wsMessage,
  }) =>
    AppState(
      loggedUserInfo: loggedUserInfo ?? this.loggedUserInfo,
      wsInfo: wsInfo ?? this.wsInfo,
      wsMessage: wsMessage ?? this.wsMessage,
    );

  @override
  String toString() => '(loggedUserInfo: $loggedUserInfo, wsInfo: $wsInfo, wsMessage: $wsMessage)';
}