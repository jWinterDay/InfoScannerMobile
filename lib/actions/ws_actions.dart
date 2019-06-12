import 'package:info_scanner_mobile/global_injector.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

import 'package:info_scanner_mobile/resources/ws/ws_api_provider.dart';


class WsTryToConnectAction {}

class WsSuccessAction {}

class WsMessageAction {
  Object message;
  WsMessageAction(this.message);
}

class WsDisconnect {}


ThunkAction wsConnectAction() {
  WsApiProvider wsApiProvider = globalInjector.get<WsApiProvider>();

  return (Store store) async {
    new Future(() async {
      await wsApiProvider.createWebSocketChannel();
      store.dispatch(new WsSuccessAction());
    });
  };
}