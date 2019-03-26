import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'dart:async';

import 'package:info_scanner_mobile/resources/auth/auth_repository.dart';
import 'package:info_scanner_mobile/models/logged_user_info.dart';

//Function projectEq = const ListEquality().equals;

//final bloc = ProjectsBloc();

class LoggedUserBloc {
  final _loginRepository = AuthRepository();
  final _loggedUserFetcher = PublishSubject<LoggedUserInfo>();

  StreamSink<LoggedUserInfo> get inSink => _loggedUserFetcher.sink;
  Observable<LoggedUserInfo> get loggedUserStream => _loggedUserFetcher.stream;

  //constructor
  LoggedUserBloc() {
   
  }

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
    getUserLocal();
  }

  dispose() async {
    await _loggedUserFetcher.drain();
    _loggedUserFetcher.close();
  }
}