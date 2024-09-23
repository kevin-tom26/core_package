part of core_package;

class LocalModule {
  static LocalModule? _instance;
  factory LocalModule() => _instance ??= LocalModule._();
  LocalModule._();

  /// A singleton database provider.
  ///
  /// Calling it multiple times will return the same instance.

  Future<Database> provideDatabase(
      String dbName, String? encryptionKeyValue) async {
    // Key for encryption
    var encryptionKey = encryptionKeyValue ?? "";

    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = path.join(
      appDocumentDir.path,
      // "flog.db",
      dbName,
    );
    // this was written as per constant name
    // db name can be changed later as per our own accord

    // Check to see if encryption is set, then provide codec
    // else init normal db with path
    var database;
    if (encryptionKey.isNotEmpty) {
      // Initialize the encryption codec with a user password
      var codec = getXXTeaCodec(password: encryptionKey);
      database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
    } else {
      database = await databaseFactoryIo.openDatabase(dbPath);
    }

    // Return database instance
    return database;
  }

  // DataSources:---------------------------------------------------------------
  // Define all your data sources here
  DataSource provideLocalModule(String? encryptionKeyValue,
          {required String dbName, required String authStoreName}) =>
      DataSource(provideDatabase(dbName, encryptionKeyValue),
          authStoreName: authStoreName);
  // DataSources End:-----------------------------------------------------------
}
