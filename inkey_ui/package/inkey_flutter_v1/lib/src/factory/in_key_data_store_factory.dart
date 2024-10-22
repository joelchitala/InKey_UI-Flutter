import 'package:inkey_flutter_v1/src/utilities/utils.dart';

import '../in_key_data_store.dart';

class InKeyDataStoreFactory {
  static InKeyDataStore create() {
    return InKeyDataStore(id: generateUUID(100000));
  }

  static InKeyDataStore fromJson({required Map<String, dynamic> data}) {
    InKeyDataStore dataStore = InKeyDataStore(id: data["_id"]);

    dataStore.setStore(data["_store"]);

    return dataStore;
  }

  static InKeyDataStore copy({
    required InKeyDataStore dataStore,
    required bool uniqueId,
  }) {
    var jsonData = deepCopyMap(dataStore.toJson());

    if (uniqueId) {
      jsonData["_id"] = generateUUID(100000);
    }

    InKeyDataStore copy = fromJson(data: jsonData);

    return copy;
  }
}
