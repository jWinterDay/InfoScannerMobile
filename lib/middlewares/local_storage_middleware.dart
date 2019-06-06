import 'package:redux/redux.dart';

import 'package:info_scanner_mobile/models/redux/app_state.dart';


class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  call(Store<AppState> store, action, NextDispatcher next) {
    print('${new DateTime.now()}: $action');

    next(action);
  }
}