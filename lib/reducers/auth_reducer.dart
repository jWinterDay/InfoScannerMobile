import 'package:info_scanner_mobile/actions/auth_actions.dart';
import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';


/*final userReducer = combineReducers<LoggedUserInfo>([
  TypedReducer<LoggedUserInfo, AuthActions>(_loginFailed),
]);

LoggedUserInfo _loginFailed(LoggedUserInfo state, AuthActions action) {
  return null;//state.copyWith();
  //return state.copyWith(user: null, isLoading: false, loginError: true);
}*/


LoggedUserInfo authReducer(LoggedUserInfo currentLoggedUser, action) {
  print('[authReducer] action = $action');
  //print('[authReducer] currentLoggedUser = $currentLoggedUser');

  if (action is LoginSuccessAction) {
    return action.user;
  }

  if (action is LoginFailedAction) {
    return currentLoggedUser;
  }
  
  if (action is LogoutAction) {
    return null;
  }

  return currentLoggedUser;
}