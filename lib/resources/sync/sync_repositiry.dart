import 'dart:async';
import 'package:info_scanner_mobile/global_injector.dart';

import 'sync_api_provider.dart';
import 'package:info_scanner_mobile/models/sync/sync_model.dart';

class SyncRepository {
  final SyncApiProvider _syncProvider = globalInjector.get<SyncApiProvider>();

  Future<SyncModel> syncAll() => _syncProvider.syncAll();
}