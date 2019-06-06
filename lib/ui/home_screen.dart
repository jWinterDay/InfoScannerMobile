import 'package:flutter/material.dart';

import 'package:info_scanner_mobile/models/redux/app_state.dart';
import 'package:info_scanner_mobile/resources/constants.dart';
//import 'package:redux/redux.dart' as redux;
import 'package:flutter_redux/flutter_redux.dart';

//import 'package:info_scanner_mobile/models/app_state.dart';
import 'package:info_scanner_mobile/ui/left_panel_screen.dart';
//import 'package:info_scanner_mobile/blocs/global_info_bloc.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  //GlobalInfoBloc _bloc = new GlobalInfoBloc();

  @override
  void dispose() {
    super.dispose();

    //get singleton of global settings instance
    //GlobalInfoBloc().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      onInit: (store) {},
      converter: (store) {
        return store.state;
      },
      builder: (BuildContext context, appState) {
        String loggedTxt = (appState.loggedUserInfo == null) ? 'You are not logged' : 'Logged as ${appState.loggedUserInfo.email}';

        return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          drawer: Drawer(
            child: LeftPanelScreen(),
          ),
          body: _buildHomeBody(appState),
          persistentFooterButtons: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pushNamed(context, Constants.navUserLogin),
              child: Text(loggedTxt),
            ),
          ],
        );
      }
    );
  }

  Widget _buildHomeBody(AppState appState) {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 5),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: FlatButton.icon(
              label: Text('Projects'),
              icon: Icon(Icons.compare),
              onPressed: () => Navigator.pushNamed(context, Constants.navRoot),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: FlatButton.icon(
              label: Text('Palette'),
              icon: Icon(Icons.color_lens),
              onPressed: () => Navigator.pushNamed(context, Constants.navPalette),
            )
          ),
          //Text(appState.loggedUserInfo.toString()),
        ],
      )
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
      ),
      drawer: Drawer(
        child: LeftPanelScreen(),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, top: 16),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: FlatButton.icon(
                label: Text('Projects'),
                icon: Icon(Icons.compare),
                onPressed: () => Navigator.pushNamed(context, '/project'),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: FlatButton.icon(
                label: Text('Palette'),
                icon: Icon(Icons.color_lens),
                onPressed: () => Navigator.pushNamed(context, '/palette'),
              )
            ),

            //websocket
            Align(
              alignment: Alignment.topLeft,
              child: FlatButton.icon(
                label: Text('Connect with websocket'),
                icon: Icon(Icons.color_lens),
                onPressed: () => _bloc.createWebSocketChannel()
              )
            ),

            Align(
              alignment: Alignment.topLeft,
              child: FlatButton.icon(
                label: Text('send message'),
                icon: Icon(Icons.color_lens),
                onPressed: () {
                  _bloc.sendWebSocketMessage('{"name": "i am dart"}');
                }
              )
            ),

            //redux
            Align(
              alignment: Alignment.topLeft,
              child: FlatButton.icon(
                label: Text('redux test'),
                icon: Icon(Icons.color_lens),
                onPressed: () {
                  //store.dispatch(Actions.increment);
                }
              )
            ),
          ],
        )
      )
    );
  }*/
}