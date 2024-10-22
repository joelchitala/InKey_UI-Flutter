import 'package:inkey_flutter_v1/src/in_key_data_store.dart';
import 'package:inkey_flutter_v1/src/transactional/in_key_transactional.dart';

class InKeyStoreTransactionalObjectRef {
  bool _results = true;
  final InKeyTransactional inKeyTransactional;
  final InKeyDataStore _dataStore;

  InKeyStoreTransactionalObjectRef({
    required this.inKeyTransactional,
    required InKeyDataStore dataStore,
  }) : _dataStore = dataStore;

  bool get results => _results;
  InKeyDataStore get datastore => _dataStore;

  void falsify() {
    _results = false;
  }
}
