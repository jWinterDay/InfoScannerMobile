import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:redux/redux.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

//import 'package:kiwi/kiwi.dart' as kiwi;

import 'models/redux/app_state.dart';
import 'ui/project/project_list_screen.dart';
import 'ui/home_screen.dart';
import 'ui/palette/palette_list_screen.dart';
import 'ui/auth/user_login_screen.dart';
import 'global_store.dart' as gStore;

//
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';


void main() async {
  //Stetho.initialize();

  await gStore.createStore();

  runApp(App());
}

//root
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: gStore.globalStore,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder> {
          Constants.navRoot: (context) => HomeScreen(),
          Constants.navProject: (context) => new ProjectListScreen(),
          Constants.navPalette: (context) => new PaletteListScreen(),
          Constants.navUserLogin: (context) => new UserLoginScreen(),
        },
      )
    );
  }
}