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
  TextEditingController emailController;
  TextEditingController passwordController;

  Observable<LoggedUserInfo> _authStream;
  Observable<LoggedUserInfo> get resultStream => _authStream;

  //constructor
  AuthBloc() {
    emailController = TextEditingController(text: _loginRepository.initEmail);
    passwordController = TextEditingController(text: _loginRepository.initPassword);

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