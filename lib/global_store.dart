import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:info_scanner_mobile/models/redux/app_state.dart';
import 'package:info_scanner_mobile/reducers/app_reducer.dart';

Store<AppState> globalStore;

Future<Store<AppState>> createStore() async {
  AppState state = await AppState.initAsync();

  globalStore = Store(
    appReducer,
    initialState: state,
    middleware: [
      thunkMiddleware
    ],
  );

  return globalStore;
}