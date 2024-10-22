import 'package:inkey_flutter_v1/src/transactional/in_key_store_transactional_manager.dart';

class InKeyTransactional {
  String id;
  bool _hasExecuted = false;

  final InKeyStoreTransactionalManager _inKeyStoreTransactionalManager =
      InKeyStoreTransactionalManager();

  final Future<void> Function() _executeFunction;

  InKeyTransactional({
    required this.id,
    required Future<void> Function() executeFunction,
  }) : _executeFunction = executeFunction;

  bool get hasExecuted => _hasExecuted;

  Future<bool> execute() async {
    if (_hasExecuted) {
      return false;
    }

    await _inKeyStoreTransactionalManager.mount(this);

    if (!await _inKeyStoreTransactionalManager
        .getRunningTransactionalResults()) {
      return false;
    }

    try {
      await _executeFunction();
    } catch (e) {
      await _inKeyStoreTransactionalManager.falsiyTransactional();
    }

    _hasExecuted = true;

    await _inKeyStoreTransactionalManager.unmount(this);

    return await _inKeyStoreTransactionalManager
        .getRunningTransactionalResults();
  }

  Future<void> commit() async {
    _inKeyStoreTransactionalManager.commit(this);
  }
}
