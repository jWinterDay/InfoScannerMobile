import 'package:info_scanner_mobile/models/redux/app_state.dart';
import 'package:info_scanner_mobile/reducers/auth_reducer.dart';
import 'package:info_scanner_mobile/reducers/ws_reducer.dart';

AppState appReducer(AppState state, action) {
  return state.copyWith(
    loggedUserInfo: authReducer(state.loggedUserInfo, action),
    wsMessage: wsReducer(state.wsMessage, action),
  );
}