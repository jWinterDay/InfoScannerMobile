import 'package:flutter/material.dart';
import 'package:info_scanner_mobile/ui/left_panel_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
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