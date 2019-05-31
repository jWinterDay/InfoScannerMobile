import 'dart:core';


abstract class Constants {
  static final String prefUser = 'user';

  static final String prefUserUserId = 'user.user_id';
  static final String prefUserFirstName = 'user.last_name';
  static final String prefUserLastName = 'user.last_name';
  static final String prefUserFullName = 'user.full_name';
  
  static final String prefUserEmail = 'user.email';
  static final String prefUserToken = 'user.token';
  static final String prefUserRefreshToken = 'user.refresh_token';
  static final String prefUserRoles = 'user.roles';

  //urls
  static final String scheme = 'http';
  static final String wsScheme = 'ws';
  static final String host = '192.168.1.42';
  static final int port = 5342;

  static final String loginUrl = new Uri(scheme: scheme, host: host, port: port, path: '/jwdsrv/login').toString();
  static final String syncAllUrl = new Uri(scheme: scheme, host: host, port: port, path: '/jwdsrv/sync').toString();
  static final String wsUrl = new Uri(scheme: wsScheme, host: host, port: port, path: '/jwdsrv/name').toString();
}