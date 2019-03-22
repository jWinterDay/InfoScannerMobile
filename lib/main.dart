import 'package:flutter/material.dart';

//import 'dart:async' as async;
//import 'package:threading/threading.dart';
//import 'dart:isolate';
//import 'package:flutter/foundation.dart' as foundation;

import 'ui/project/project_list_screen.dart';
import 'ui/home_screen.dart';
import 'ui/palette/palette_list_screen.dart';
import 'ui/auth/user_login_screen.dart';
import 'ui/auth/user_register_screen.dart';


void main() => runApp(App());

//root
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/project': (context) => ProjectListScreen(),
        '/palette': (context) => PaletteListScreen(),
        '/user_login': (context) => UserLoginScreen(),
        '/user_register': (context) => UserRegisterScreen(),
      },
      //home: Scaffold(
      //  body: HomeScreen()//ProjectListScreen()
      //)
    );
  }
}