import 'dart:core';


abstract class Constants {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  //navigator
  static const String navRoot = '/';
  static const String navProject = '/project';
  static const String navPalette = '/palette';
  static const String navUserLogin = '/user_login';

  //pref
  static const String prefUser = 'user';
}