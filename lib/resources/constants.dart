import 'dart:core';


abstract class Constants {
  static const bool isProduction = false;

  //navigator
  static const String navRoot = '/';
  static const String navProject = '/project';
  static const String navPalette = '/palette';
  static const String navUserLogin = '/user_login';

  //pref
  static const String prefUser = 'user';

  //urls
  static const String scheme = 'http';
  static const String wsScheme = 'ws';
  static const String host = '192.168.1.42';
  static const int port = 5342;

  static final String loginUrl = new Uri(scheme: scheme, host: host, port: port, path: '/jwdsrv/login').toString();
  static final String syncAllUrl = new Uri(scheme: scheme, host: host, port: port, path: '/jwdsrv/sync').toString();
  static final String wsUrl = new Uri(scheme: wsScheme, host: host, port: port, path: '/jwdsrv/name').toString();
}