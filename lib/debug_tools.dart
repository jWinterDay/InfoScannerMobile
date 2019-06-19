import 'package:flutter_stetho/flutter_stetho.dart';

import 'package:info_scanner_mobile/resources/constants.dart';


Future initialise() async {
  if (!Constants.isProduction && Constants.isUseStetho) {
    Stetho.initialize();
  }
}