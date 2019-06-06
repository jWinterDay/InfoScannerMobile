import 'dart:async';
import 'sync_api_provider.dart';
import 'package:info_scanner_mobile/models/sync/sync_model.dart';

class SyncRepository {
  final SyncApiProvider _syncProvider = new SyncApiProvider();

  Future<SyncModel> syncAll() => _syncProvider.syncAll();
}