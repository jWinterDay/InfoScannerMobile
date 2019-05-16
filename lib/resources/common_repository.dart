import 'package:info_scanner_mobile/global_settings.dart';

class CommonRepository {
  bool _isProduction = false;
  bool get isProduction => _isProduction;

  //constructor
  CommonRepository() {
    _isProduction = GlobalSettings.isProduction;
  }
}