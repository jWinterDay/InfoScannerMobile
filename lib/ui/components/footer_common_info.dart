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
      //logged user
      bool isLogged = appState?.loggedUserInfo != null;
      String loggedTxt = isLogged ? appState.loggedUserInfo.email : 'You are not logged';
      MaterialColor loggedColor = isLogged ? Colors.green : Colors.grey;

      //websocket
      //var wsInfo = appState?.wsInfo?.channel;
      var wsMessage = appState?.wsMessage;


      return BottomNavigationBar(
        onTap: (indx) {
          switch (indx) {
            case 0:
              Navigator.pushNamed(context, Constants.navRoot);
              break;
            case 1:
              break;
            case 2:
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
            icon: new Icon(Icons.email),
            title: new Text("Events: $wsMessage"),
          ),

          /*BottomNavigationBarItem(
            title: Text('Events'),
            icon: StreamBuilder(
              stream: wsInfo.stream,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                var color = snapshot.hasData ? Colors.redAccent : null;
                return Icon(Icons.mail, color: color);
              }
            ),
          ),*/

          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle, color: loggedColor),
            title: new Text(loggedTxt, style: TextStyle(color: loggedColor)),
          ),
        ]
      );
    }
  );
}