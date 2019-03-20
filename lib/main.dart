import 'package:flutter/material.dart';

//import 'dart:async' as async;
//import 'package:threading/threading.dart';
//import 'dart:isolate';
//import 'package:flutter/foundation.dart' as foundation;

import 'ui/project_list_screen.dart';


void main() => runApp(App());

//root
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        body: ProjectListScreen()
      )
    );
  }
}