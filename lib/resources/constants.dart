import 'dart:core';


abstract class Constants {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  static const bool isUseStetho = false;

  //navigator
  static const String navRoot = '/';
  static const String navPrefSettings = '/pref_settings';
  static const String navProject = '/project';
  static const String navPalette = '/palette';
  static const String navUserLogin = '/user_login';

  //pref
  static const String prefUser = 'user';
}