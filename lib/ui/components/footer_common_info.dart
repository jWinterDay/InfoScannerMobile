import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:info_scanner_mobile/models/redux/app_state.dart';
import 'package:info_scanner_mobile/resources/constants.dart';


Widget footerCommonInfo({@required bool isNavigator}) {
  return StoreConnector<AppState, AppState>(
    converter: (store) {
      return store.state;
    },
    builder: (BuildContext context, appState) {
      bool isLogged = appState?.loggedUserInfo != null;
      String loggedTxt = isLogged ? appState.loggedUserInfo.email : 'You are not logged';
      MaterialColor loggedColor = isLogged ? Colors.green : Colors.grey;
      //var onPressedAction = isNavigator ? () => Navigator.pushNamed(context, Constants.navUserLogin) : null;

      return BottomNavigationBar(
        onTap: (indx) {
          switch (indx) {
            case 0:
              Navigator.pushNamed(context, Constants.navRoot);
              break;
            case 1:
              if(isNavigator) {
                Navigator.pushNamed(context, Constants.navUserLogin);
              }
              break;
            default:
          }
        },
        //fixedColor: Colors.orangeAccent,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle, color: loggedColor),
            title: new Text(loggedTxt, style: TextStyle(color: loggedColor)),
          ),
        ]
      );

      /*return Row(
        children: <Widget>[
          FlatButton.icon(
            disabledTextColor: Colors.green,
            icon: Icon(Icons.account_circle),
            label: Text('f'),
            onPressed: onPressedAction
          ),
          FlatButton.icon(
            disabledTextColor: Colors.green,
            icon: Icon(Icons.account_circle),
            label: Text(loggedTxt, style: Theme.of(context).textTheme.subhead),
            onPressed: onPressedAction
          ),
        ],
      );*/
      /*return FlatButton.icon(
        disabledTextColor: Colors.green,
        icon: Icon(Icons.account_circle),
        label: Text(loggedTxt, style: Theme.of(context).textTheme.subhead),
        onPressed: onPressedAction
      );*/
    }
  );
}