import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:info_scanner_mobile/ui/auth/user_login_screen.dart';
import 'package:info_scanner_mobile/ui/palette/palette_list_screen.dart';
import 'package:info_scanner_mobile/ui/pref/pref_settings.dart';
import 'package:info_scanner_mobile/ui/project/project_list_screen.dart';


Future<Router> initialise() async {
  Router router = new Router();

  //pref settings
  router.define(
    Constants.navPrefSettings,
    handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new PrefSettings();
    }),
    transitionType: TransitionType.inFromBottom
  );

  //login
  router.define(
    Constants.navUserLogin,
    handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new UserLoginScreen();
    }),
    transitionType: TransitionType.inFromBottom
  );

  //project
  router.define(
    Constants.navProject,
    handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new ProjectListScreen();
    }),
    transitionType: TransitionType.inFromBottom
  );

  //palette
  router.define(
    Constants.navPalette,
    handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new PaletteListScreen();
    }),
    transitionType: TransitionType.inFromBottom
  );

  return router;
}