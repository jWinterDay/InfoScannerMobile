import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:device_id/device_id.dart';
import 'dart:io' show Platform;

import 'package:info_scanner_mobile/resources/auth/auth_api_provider.dart';
import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:info_scanner_mobile/resources/project/project_db_api_provider.dart';
import 'package:info_scanner_mobile/resources/sync/sync_api_provider.dart';
import 'package:info_scanner_mobile/resources/ws/ws_api_provider.dart';


Injector globalInjector;


Future<Injector> initialise() async {
  //print(Platform.operatingSystemVersion);

  globalInjector = Injector.getInjector();

  bool isProd = Constants.isProduction;

  String env = isProd ? 'production' : 'development';
  print('---injector init for $env---');

  //host
  globalInjector.map<String>((injector) => isProd ? 'http://192.168.0.107:5342/jwdsrv/' : 'http://192.168.0.116:5342/jwdsrv/', key: 'host');
  
  //device id
  String deviceId = 'Unknown';
  try {
    deviceId = await DeviceId.getID;
  } catch(err) {}
  globalInjector.map<String>((injector) => deviceId, key: 'deviceId');


  globalInjector.map<AuthApiProvider>((injector) =>
    AuthApiProvider(
      isProd ? '' : 'jwinterday@mail.ru',
      isProd ? '' : '123',
      globalInjector.get<String>(key: 'host'))
  );

  //websockets
  globalInjector.map<String>((injector) => isProd ? 'ws://192.168.0.107:5342/jwdsrv/name' : 'ws://192.168.0.116:5342/jwdsrv/name', key: 'wsUrl');
  globalInjector.map<WsApiProvider>((injector) =>
    new WsApiProvider(
      injector.get<String>(key: 'wsUrl'),
    ));

  //project
  globalInjector.map<ProjectDbApiProvider>((injector) => new ProjectDbApiProvider(injector.get<String>(key: 'deviceId')));

  //sync
  globalInjector.map<SyncApiProvider>((injector) =>
    new SyncApiProvider(
      injector.get<ProjectDbApiProvider>(),
      injector.get<String>(key: 'host')
    )
  );


  return globalInjector;
}