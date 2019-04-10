import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:info_scanner_mobile/resources/sync/sync_repositiry.dart';
import 'package:info_scanner_mobile/models/sync_model.dart';
import 'package:info_scanner_mobile/resources/Exceptions.dart';

class SyncBloc {
  final _syncRepository = SyncRepository();
  final _syncFetcher = PublishSubject<SyncModel>();

  StreamSink<SyncModel> get inSink => _syncFetcher.sink;
  Observable<SyncModel> get syncStream => _syncFetcher.stream;

  getInitial() {
    inSink.add(null);
  }

  syncAll() async {
    SyncModel syncModel;

    syncModel = new SyncModel.inprogress(message: 'synchronizing....');
    inSink.add(syncModel);

    try {
      syncModel = await _syncRepository.syncAll();
      //await Future.delayed(Duration(seconds: 2));//TODO test
      inSink.add(syncModel);
    } on AuthException catch(err) {
      //gUserBloc.removeUser();
      //print('AuthException. err = $err');
      inSink.addError(err);
    } catch(err) {
      //print('sync error: $err');
      inSink.addError(err);
    }
  }

  dispose() async {
    await _syncFetcher.drain();
    _syncFetcher.close();
  }
}