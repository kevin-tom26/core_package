part of core_package;

class DataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  late StoreRef<int, Map<String, Object?>> _authDataStore;

  // database instance
  final Future<Database> _db;
  final String authStoreName;

  // Constructor
  DataSource(this._db, {required this.authStoreName}) {
    _authDataStore = intMapStoreFactory.store(authStoreName);
  }

  // DB functions:--------------------------------------------------------------
  // AUTH fuctions:-------------------------------------------------------------
  Future<int> setAuthData(AuthData authData) async {
    return await _authDataStore.add(await _db, authData.toMap());
  }

  Future<int> countUserdata() async {
    return await _authDataStore.count(await _db);
  }

  Future<AuthData> getAuthData() async {
    var finder = Finder(sortOrders: [SortOrder(Field.key, false)]);
    var record = await _authDataStore.findFirst(await _db, finder: finder);
    return AuthData.fromMap(record!.value);
  }

  Future deleteAuthData() async {
    await _authDataStore.drop(
      await _db,
    );
  }
}
