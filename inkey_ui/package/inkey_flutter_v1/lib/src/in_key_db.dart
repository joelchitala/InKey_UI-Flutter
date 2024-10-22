import 'package:inkey_flutter_v1/src/in_key_data_store_manager.dart';
import 'package:inkey_flutter_v1/src/transactional/in_key_store_transactional_manager.dart';
import 'package:inkey_flutter_v1/src/transactional/in_key_transactional.dart';
import 'package:inkey_flutter_v1/src/utilities/fileoperations.dart';
import 'package:inkey_flutter_v1/src/utilities/utils.dart';

class InKeyDB {
  final InKeyDataStoreManager _storeManager = InKeyDataStoreManager();

  InKeyDataStoreManager get storeManger => _storeManager;

  Future<void> setUp({required Map<String, dynamic> jsonData}) async {
    _storeManager.setUp(jsonData: jsonData);
  }

  Future<void> setUpFromFile({required String filePath}) async {
    var jsonData = await readFile(filePath);

    _storeManager.setUp(jsonData: jsonData);
  }

  Future<void> commit({required String filePath}) async {
    var jsonData = await _storeManager.toJson();
    await writeFile(
      filePath,
      jsonData,
    );
  }

  Future<void> cleanFile({required String filePath}) async {
    await cleanFile(
      filePath: filePath,
    );
  }

  Future<void> cleanDataStore() async {
    _storeManager.setUp(jsonData: {
      "_id": _storeManager.id,
      "_runState": RunStates.inMemoryOnly.toString(),
      "_dataStore": {
        "_id": _storeManager.dataStore.id,
        "_store": <String, dynamic>{},
      },
    });
  }

  void setInKeyRunState(RunStates state) {
    _storeManager.setRunState(state);
  }

  InKeyTransactional transaction(
    Future<void> Function() func,
  ) {
    InKeyTransactional transactional = InKeyTransactional(
      id: generateUUID(100000),
      executeFunction: func,
    );

    return transactional;
  }

  Future<void> falsifyTransactional() async {
    return await InKeyStoreTransactionalManager().falsiyTransactional();
  }

  Future<Map<String, dynamic>> getAllEntries() async {
    var datastore = await _storeManager.getCurrentDataStore();
    return datastore.store;
  }

  Future<void> put({required String key, dynamic value}) async {
    var serial = isJsonSerializable(value);

    if (!serial.$1) {
      throw "Value $value is not json serializable. Accepted values are ${serial.$2}";
    }

    var datastore = await _storeManager.getCurrentDataStore();
    datastore.put(key: key, value: value);
  }

  Future<String?> get({required String key}) async {
    var datastore = await _storeManager.getCurrentDataStore();
    return datastore.get(key: key);
  }

  Future<void> update({required String key, dynamic value}) async {
    var serial = isJsonSerializable(value);

    if (!serial.$1) {
      throw "Value $value is not json serializable. Accepted values are ${serial.$2}";
    }

    var datastore = await _storeManager.getCurrentDataStore();
    datastore.update(key: key, value: value);
  }

  Future<void> delete({required String key}) async {
    var datastore = await _storeManager.getCurrentDataStore();
    datastore.delete(key: key);
  }

  Future<Map<String, dynamic>> toJson() async {
    var datastore = await _storeManager.getCurrentDataStore();
    return datastore.toJson();
  }

  Future<Map<String, dynamic>> toJsonDataStoreManager() async {
    return await _storeManager.toJson();
  }
}
