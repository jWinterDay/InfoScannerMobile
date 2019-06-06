import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:info_scanner_mobile/models/redux/app_state.dart';


Widget persistentFooter() {
  return StoreConnector<AppState, AppState>(
    converter: (store) {
      return store.state;
    },
    builder: (BuildContext context, appState) {
      String loggedTxt = (appState.loggedUserInfo == null) ? 'You are not logged' : 'Logged as ${appState.loggedUserInfo.email}';
      return Text(loggedTxt, style: TextStyle(color: Colors.green));
    }
  );
}