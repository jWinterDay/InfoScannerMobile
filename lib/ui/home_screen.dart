import 'package:flutter/material.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:info_scanner_mobile/ui/components/footer_common_info.dart';
import 'package:info_scanner_mobile/ui/left_panel_screen.dart';

import 'package:info_scanner_mobile/global_store.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: LeftPanelScreen(),
      ),
      endDrawer: Constants.isProduction ? null : ReduxDevTools(globalStore),
      body: _buildHomeBody(),
      bottomNavigationBar: footerCommonInfo(isNavigator: true),
      //persistentFooterButtons: <Widget>[
      //  footerCommonInfo(),
      //],
    );
  }

  Widget _buildHomeBody() {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 5),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: FlatButton.icon(
              label: Text('Projects'),
              icon: Icon(Icons.compare),
              onPressed: () => Navigator.pushNamed(context, Constants.navProject),
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