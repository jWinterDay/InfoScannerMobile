import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:info_scanner_mobile/models/redux/app_state.dart';
import 'package:info_scanner_mobile/reducers/app_reducer.dart';


//Store<AppState> globalStore;
DevToolsStore<AppState> globalStore;

Future<Store<AppState>> createStore() async {
  AppState state = await AppState.initAsync();

  globalStore = new DevToolsStore<AppState>(
    appReducer,
    initialState: state,
    middleware: [
      thunkMiddleware
    ],
  );

  /*globalStore = Store(
    appReducer,
    initialState: state,
    middleware: [
      thunkMiddleware
    ],
  );*/

  return globalStore;
}