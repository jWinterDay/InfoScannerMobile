import 'package:info_scanner_mobile/models/auth/auth_model.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:info_scanner_mobile/models/redux/logged_user_info.dart';
import 'package:info_scanner_mobile/resources/auth/auth_api_provider.dart';


//actions
class LoginIsStartingAction {}

class LogoutAction {}

class LoginSuccessAction {
  final LoggedUserInfo user;
  LoginSuccessAction(this.user);
}

class LoginFailedAction {
  Object exception;
  LoginFailedAction(this.exception);
}

//thunk actions
ThunkAction logoutReduxAction() {
  AuthApiProvider authApiProvider = new AuthApiProvider();

  return (Store store) async {
    new Future(() async {
      await authApiProvider.logout();
      store.dispatch(new LogoutAction());
    });
  };
}