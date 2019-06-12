import 'package:info_scanner_mobile/actions/ws_actions.dart';
import 'package:info_scanner_mobile/models/redux/ws_info.dart';
import 'package:info_scanner_mobile/models/redux/ws_message.dart';

WsMessage wsReducer(WsMessage wsMessage, action) {
  print('[wsReducer] action = $action');

  if (action is WsTryToConnectAction) {

  }

  if (action is WsSuccessAction) {
    return wsMessage;
  }

  if (action is WsMessageAction) {
    var mess = action.message;

    wsMessage ??= new WsMessage();

    return wsMessage.copyWith(message: mess);
  }

  if (action is WsDisconnect) {

  }

  return wsMessage;
}