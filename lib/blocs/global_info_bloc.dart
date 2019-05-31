import 'dart:io';

import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:info_scanner_mobile/resources/auth/auth_repository.dart';
import 'package:info_scanner_mobile/models/logged_user_info.dart';


class GlobalInfoBloc {
  final _loginRepository = AuthRepository();
  final _loggedUserFetcher = PublishSubject<LoggedUserInfo>();

  //logged user stream
  StreamSink<LoggedUserInfo> get inSink => _loggedUserFetcher.sink;
  Observable<LoggedUserInfo> get loggedUserStream => _loggedUserFetcher.stream;

  //websocket stream
  IOWebSocketChannel _channel;
  WebSocket _socket;
  //WebSocketSink get wsInSink => _channel.sink;
  Stream get wsStream => _channel.stream;


  createWebSocketChannel({Map<String, dynamic> headers}) async {
    try {
      _socket = await WebSocket
        .connect(Constants.wsUrl)
        .timeout(Duration(seconds: 5));

      _channel = IOWebSocketChannel(_socket);

      _channel.stream.listen((data) {
        print('stream data = $data');
      });
    } catch(ex) {
      print('ws exception = $ex');
    }
  }

  sendWebSocketMessage(Object obj) {
    if (_channel == null) {
      return;
    }

    _channel.sink.add(obj);
  }


  //singleton instance
  static final GlobalInfoBloc _instance = new GlobalInfoBloc._internal();
  factory GlobalInfoBloc() => _instance;
  //constructor
  GlobalInfoBloc._internal();

  getInitial() {
    inSink.add(null);
  }

  //first, create in progress user (LoggedUserInfo user = LoggedUserInfo.inprogress();) with status 'inprogress'
  //when we receive http answer status is 'done'
  login(String email, String password) async {
    LoggedUserInfo user = LoggedUserInfo.inprogress();
    
    inSink.add(user);
    try {
      user = await _loginRepository.login(email, password);
      inSink.add(user);
    } catch(err) {
      inSink.addError(err);
    }
  }

  getUserLocal() async {
    LoggedUserInfo user = await _loginRepository.getUserLocal();
    inSink.add(user);
  }

  removeUser() async {
    await _loginRepository.removeUserLocal();
    await getUserLocal();
  }

  dispose() async {
    if (_loggedUserFetcher != null) await _loggedUserFetcher.close();
    if (_socket != null) await _socket.close();
  }
}