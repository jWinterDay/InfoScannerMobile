import 'package:flutter/material.dart';

import 'package:flutter_stetho/flutter_stetho.dart';

import 'ui/project/project_list_screen.dart';
import 'ui/home_screen.dart';
import 'ui/palette/palette_list_screen.dart';
import 'ui/auth/user_login_screen.dart';

void main() {
  Stetho.initialize();
  runApp(App());
} 

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
      },
      //home: Scaffold(
      //  body: HomeScreen()//ProjectListScreen()
      //)
    );
  }
}