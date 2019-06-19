import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
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
              //Navigator.pushNamed(context, Constants.navRoot);
              break;
            case 1:
              if(isNavigator) {
                Navigator.pushNamed(context, Constants.navUserLogin);
              }
              break;
            case 2:
              if(isNavigator) {
                Navigator.pushNamed(context, Constants.navPrefSettings);
              }
              break;
            default:
          }
        },
        //fixedColor: Colors.orangeAccent,
        items: [
          //BottomNavigationBarItem(
          //  icon: new Icon(Icons.home),
          //  title: new Text("Home"),
          //),

          BottomNavigationBarItem(
            icon: new Icon(Icons.email),
            title: new Text("Events: $wsMessage"),
          ),

          BottomNavigationBarItem(
            icon: !isLogged ? _animatedLoggedInfo() : new Icon(Icons.account_circle, color: loggedColor),//new Icon(Icons.account_circle, color: loggedColor),
            title: new Text(loggedTxt, style: TextStyle(color: loggedColor)),
          ),

          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            title: new Text('pref'),
          ),
        ]
      );
    }
  );
}

Widget _animatedLoggedInfo() {
    return Animator(
      //tween: Tween<double>(begin: 0, end: 1),
      tweenMap: {
        'opacity': Tween<double>(begin: 0, end: 1),
        'rotation': Tween<double>(begin: 0, end: 2),
      },
      cycles: 0,
      curve: Curves.easeOutCubic,
      duration: Duration(seconds: 1),
      builderMap: (anim) => Center(
        child: RotationTransition(
          turns: anim["opacity"],
          child: Opacity(
            opacity: anim['opacity'].value,//math.min(1, anim.value),
            child: Icon(Icons.account_circle),
          ),
          
          //Text("\u{26BE}"),//Icon(Icons.account_circle),//, color: loggedColor)
        ),
      ),
    );
  }