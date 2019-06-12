import 'dart:io';

import 'package:web_socket_channel/io.dart';


class WsInfo {
  WebSocket socket;
  IOWebSocketChannel channel;

  //constructor
  WsInfo({this.socket, this.channel});
}