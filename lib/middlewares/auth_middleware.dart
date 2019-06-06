import 'package:redux/redux.dart';

import 'package:info_scanner_mobile/actions/auth_actions.dart';
import 'package:info_scanner_mobile/models/redux/app_state.dart';


class AuthMiddleware extends MiddlewareClass<AppState> {
  call(Store<AppState> store, action, NextDispatcher next) {
    print('[AuthMiddleware] ${new DateTime.now()}: $action');

    next(action);
  }
}