import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:preferences/preferences.dart';

//ui
import 'ui/home_screen.dart';

//settings
import 'models/redux/app_state.dart';
import 'global_store.dart' as gStore;
import 'global_injector.dart' as gInjector;
import 'debug_tools.dart' as gDebugTools;
import 'route_settings.dart' as gRouteSettings;


void main() async {
  await PrefService.init(prefix: 'pref_');

  var router = await gRouteSettings.initialise();
  await gDebugTools.initialise();
  await gInjector.initialise();
  await gStore.createStore();

  runApp(StoreProvider<AppState>(
    store: gStore.globalStore,
    child: MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
      onGenerateRoute: router.generator
    )
  ));
}