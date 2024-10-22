import 'package:inkey_flutter_v1/src/factory/in_key_data_store_factory.dart';
import 'package:inkey_flutter_v1/src/in_key_data_store.dart';
import 'package:inkey_flutter_v1/src/transactional/in_key_store_transactional_manager.dart';
import 'package:inkey_flutter_v1/src/utilities/utils.dart';

enum RunStates {
  inMemoryOnly,
  inMemoryAndDisk,
}

RunStates? toRunStates(String value) {
  for (var state in RunStates.values) {
    if (value == state.toString()) {
      return state;
    }
  }

  return null;
}

class InKeyDataStoreManager {
  late String _id;
  // ignore: prefer_final_fields
  RunStates _runState = RunStates.inMemoryOnly;

  late InKeyDataStore _dataStore;

  InKeyDataStoreManager._() {
    _id = generateUUID(100000);
    _dataStore = InKeyDataStoreFactory.create();
  }

  static final _instance = InKeyDataStoreManager._();

  factory InKeyDataStoreManager() {
    return _instance;
  }

  String get id => _id;
  RunStates get runState => _runState;

  void setUp({required Map<String, dynamic> jsonData}) {
    _id = jsonData["_id"];
    _runState = toRunStates(jsonData["_runState"])!;
    _dataStore = InKeyDataStoreFactory.fromJson(data: jsonData["_dataStore"]);
  }

  void setRunState(RunStates state) {
    if (_runState == state) {
      throw "Already in ${_runState.name} run-state";
    }

    _runState = state;
  }

  InKeyDataStore get dataStore => _dataStore;

  Future<InKeyDataStore> getCurrentDataStore() async {
    InKeyStoreTransactionalManager transactionalManager =
        InKeyStoreTransactionalManager();

    if (await transactionalManager.inTransaction()) {
      return transactionalManager.inKeyStoreTransactionalObjectRef!.datastore;
    }

    return _dataStore;
  }

  void commit(InKeyDataStore newDataStoreState) {
    if (_dataStore == newDataStoreState) {
      return;
    }

    _dataStore = newDataStoreState;
  }

  Future<Map<String, dynamic>> toJson() async {
    var store = await getCurrentDataStore();

    return {
      "_id": _id,
      "_runState": _runState.toString(),
      "_dataStore": store.toJson(),
    };
  }
}
