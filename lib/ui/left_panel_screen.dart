import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart' as shared;

class LeftPanelScreen extends StatefulWidget {
  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanelScreen> {
  //constructor
  _LeftPanelState() {
    //var sp = shared.SharedPreferences.getInstance();
    //sp.
    //Navigator.pushNamed(context, '/user_login')
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(Icons.settings),
            Text('Settings'),
          ],
        )
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: FlatButton.icon(
              label: Text('Login'),
              icon: Icon(Icons.accessibility),
              onPressed: () => { Navigator.pushNamed(context, '/user_login') },
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: FlatButton.icon(
              label: Text('Register'),
              icon: Icon(Icons.account_circle),
              onPressed: () => { Navigator.pushNamed(context, '/user_register') },
            )
          )
        ],
      )
      //Center(child: CircularProgressIndicator())
    );
  }
}