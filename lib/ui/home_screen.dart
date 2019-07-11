import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:info_scanner_mobile/ui/components/footer_common_info.dart';
import 'package:info_scanner_mobile/ui/left_panel_screen.dart';
import 'package:info_scanner_mobile/global_store.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  //EventChannel _accelerometerEventChannel = EventChannel('plugins.flutter.io/sensors/accelerometer');

  _HomeState() {
    //_accelerometerEventChannel
    //  .receiveBroadcastStream()
    //  .listen((d) {
    //    print('received: $d');
    //  });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }


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
        ],
      )
    );
  }
}