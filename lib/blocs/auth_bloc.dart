import 'package:flutter/material.dart';
import 'package:info_scanner_mobile/actions/auth_actions.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:info_scanner_mobile/global_store.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/auth/auth_repository.dart';
import 'package:info_scanner_mobile/models/auth/auth_model.dart';


class AuthBloc {
  final _loginRepository = AuthRepository();
  
  PublishSubject<LoggedUserInfo> _authController;

  final TextEditingController emailController = TextEditingController(text: 'jwinterday@mail.ru');
  final TextEditingController passwordController = TextEditingController(text: '123');

  Observable<LoggedUserInfo> _authStream;
  Observable<LoggedUserInfo> get resultStream => _authStream;

  //constructor
  AuthBloc() {
    _authController = new PublishSubject();

    _authStream = _authController
      .switchMap((p) {
        return _doLogin();
      });

    //merged. possible in future many sources of stream
    Observable<Observable<LoggedUserInfo>> streams =
        Observable
          .merge([_authStream])
          .doOnData((data) {
            //print('[MERGED] data = $data');
          })
          .map((p) => Observable.just(p));

    _authStream = Observable.switchLatest(streams);
  }

  String emailValidator(val) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return (val != null && regex.hasMatch(val)) ? null : 'Invalid email format';
  }
  String passwordValidator(val) {
    String psw = val as String;
    return (psw == null || psw.trim().length < 3) ? 'Enter minimum 3 non empty symbols' : null;
  }

  login() {
    
    _authController.sink.add(null);
  }

  Stream<LoggedUserInfo> _doLogin() async* {
    yield new LoggedUserInfo.loading();

    await Future.delayed(Duration(seconds: 1));

    AuthModel authModel = new AuthModel(
      email: emailController.text,
      password: passwordController.text
    );

    try {
      LoggedUserInfo user = await _loginRepository.login(authModel);

      //redux
      globalStore.dispatch(new LoginSuccessAction(user));

      yield user;
    } catch(exc) {
        yield new LoggedUserInfo.error(exc);
        return;
    }
  }

  dispose() async {
    _authController.close();

    emailController.clear();
    emailController.dispose();
    passwordController.clear();
    passwordController.dispose();
  }
}

/*import 'dart:io';

import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:info_scanner_mobile/resources/auth/auth_repository.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';


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
}*/