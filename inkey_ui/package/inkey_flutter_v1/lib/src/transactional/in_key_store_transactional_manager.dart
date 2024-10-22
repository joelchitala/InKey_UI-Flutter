import 'package:inkey_flutter_v1/src/factory/in_key_data_store_factory.dart';
import 'package:inkey_flutter_v1/src/in_key_data_store_manager.dart';
import 'package:inkey_flutter_v1/src/transactional/in_key_store_transactional_object_ref.dart';
import 'package:inkey_flutter_v1/src/transactional/in_key_transactional.dart';

class InKeyStoreTransactionalManager {
  final InKeyDataStoreManager dataStoreManager = InKeyDataStoreManager();
  InKeyStoreTransactionalObjectRef? _inKeyStoreTransactionalObjectRef,
      _commitObjectRef;

  InKeyStoreTransactionalManager._();

  static final _instance = InKeyStoreTransactionalManager._();

  factory InKeyStoreTransactionalManager() {
    return _instance;
  }

  InKeyStoreTransactionalObjectRef? get inKeyStoreTransactionalObjectRef =>
      _inKeyStoreTransactionalObjectRef;

  Future<bool> getRunningTransactionalResults() async {
    if (_inKeyStoreTransactionalObjectRef == null) {
      return false;
    }

    return _inKeyStoreTransactionalObjectRef!.results;
  }

  Future<void> falsiyTransactional() async {
    if (_inKeyStoreTransactionalObjectRef == null) {
      return;
    }

    _inKeyStoreTransactionalObjectRef?.falsify();
  }

  Future<bool> inTransaction() async {
    if (_inKeyStoreTransactionalObjectRef == null) {
      return false;
    }

    return true;
  }

  Future<bool> mount(InKeyTransactional inKeyTransactional) async {
    if (_inKeyStoreTransactionalObjectRef != null) {
      return false;
    }

    _inKeyStoreTransactionalObjectRef = InKeyStoreTransactionalObjectRef(
      inKeyTransactional: inKeyTransactional,
      dataStore: InKeyDataStoreFactory.copy(
        uniqueId: true,
        dataStore: dataStoreManager.dataStore,
      ),
    );

    return true;
  }

  Future<bool> unmount(InKeyTransactional inkeyTransactional) async {
    if (_inKeyStoreTransactionalObjectRef == null) {
      return false;
    }

    if (_inKeyStoreTransactionalObjectRef!.inKeyTransactional.id
            .compareTo(inkeyTransactional.id) !=
        0) {
      return false;
    }

    _commitObjectRef = _inKeyStoreTransactionalObjectRef;
    _inKeyStoreTransactionalObjectRef = null;

    return true;
  }

  Future<void> commit(InKeyTransactional inKeyTransactional) async {
    if (_commitObjectRef == null) {
      return;
    }

    if (_commitObjectRef!.inKeyTransactional.id
            .compareTo(inKeyTransactional.id) !=
        0) {
      return;
    }

    if (!_commitObjectRef!.results) {
      return;
    }

    dataStoreManager.commit(_commitObjectRef!.datastore);
    _commitObjectRef = null;
  }
}
