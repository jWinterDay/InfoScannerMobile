import 'dart:io';
import 'dart:async';
import 'package:web_socket_channel/io.dart';

import 'package:info_scanner_mobile/actions/ws_actions.dart';
import 'package:info_scanner_mobile/global_store.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/models/redux/ws_info.dart';
import 'package:info_scanner_mobile/resources/common.dart';


class WsApiProvider {
  WebSocket socket;
  IOWebSocketChannel wsChannel;

  final String wsUrl;

  //constructor
  WsApiProvider(this.wsUrl);


  ///connect to websocket server
  ///if user hasn't logged, we don't connect and don't create websocket channel
  Future<WsInfo> createWebSocketChannel({Map<String, dynamic> headers}) async {
    Common common = new Common();
    LoggedUserInfo user = await common.getUserLocal();//globalStore.state?.loggedUserInfo;

    if (user == null) {
      return null;
    }

    try {
      socket = await WebSocket
        .connect(wsUrl)
        .timeout(Duration(seconds: 5));

      wsChannel = IOWebSocketChannel(socket);

      wsChannel.stream.listen((message) {
        print('stream data = $message');

        //redux
        globalStore.dispatch(new WsMessageAction(message));
      });
    } catch(ex) {
      print('ws exception = $ex');
      return null;
    }

    WsInfo wsInfo = new WsInfo(socket: socket, channel: wsChannel);

    return wsInfo;
  }

  sendWebSocketMessage(Object obj) {
    WsInfo wsInfo = globalStore.state.wsInfo;

    if (wsInfo == null) {
      return;
    }

    wsInfo.channel.sink.add(obj);
  }

  dispose() async {
    WsInfo wsInfo = globalStore.state.wsInfo;
    if (wsInfo != null) wsInfo.socket.close();
    if (socket != null) socket.close();
  }
}