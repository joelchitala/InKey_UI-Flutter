class InKeyDataStore {
  // ignore: prefer_final_fields
  String _id;

  Map<String, dynamic> _store = {};

  InKeyDataStore({required String id}) : _id = id;

  String get id => _id;
  Map<String, dynamic> get store => _store;

  void setStore(Map<String, dynamic> data) {
    _store = data;
  }

  void put({required String key, dynamic value}) {
    if (_store[key] != null) {
      throw "Key and Value is already in store. Use update method to update the value";
    }

    _store[key] = value;
  }

  String? get({required String key}) {
    return _store[key];
  }

  void update({required String key, dynamic value}) {
    if (_store[key] == null) {
      throw "Key is not in _store. Use put method to add the key and value pair to store";
    }

    _store[key] = value;
  }

  void delete({required String key}) {
    if (_store[key] == null) {
      throw "Key is not in store. Failed to delete";
    }

    _store.remove(key);
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": _id,
      "_store": _store,
    };
  }
}
