import 'package:flutter/material.dart';
import 'package:info_scanner_mobile/ui/left_panel_screen.dart';
import 'package:info_scanner_mobile/blocs/logged_user_bloc.dart';//init gUserBloc for global detect

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with WidgetsBindingObserver {
  /*AppLifecycleState _notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() { _notification = state; });
  }*/

  @override
  void dispose() {
    super.dispose();
    gUserBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          //style: TextStyle(color: Colors.black),
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
                onPressed: () => { Navigator.pushNamed(context, '/project') },
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: FlatButton.icon(
                label: Text('Palette'),
                icon: Icon(Icons.color_lens),
                onPressed: () => { Navigator.pushNamed(context, '/palette') },
              )
            )
          ],
        )
      )
    );
  }
}