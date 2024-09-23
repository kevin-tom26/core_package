part of core_package;

class BaseService {
  static String? _dbEncryptionKeyValue;
  static String? _dbName;
  static String? _authStoreName;
  static void Function(String apiErrorResponseMessage)? _onErrorResponseMessage;
  static void Function(String apiSuccessResponseMessage)?
      _onSuccessResponseMessage;
  static void Function(DioException)? _handleTokenExpiry;
  static String? _baseURL;
  static int? _connectionTimeout;
  static int? _receiveTimeout;
  late DioClient dioClient;
  late DataSource dataSource;

  // Private internal constructor for actual initialization
  BaseService() {
    if (_handleTokenExpiry == null) {
      throw Exception("handleTokenExpiry callback is not initialized.");
    }
    if (_onErrorResponseMessage == null) {
      throw Exception("onErrorResponseMessage callback is not initialized.");
    }
    if (_onSuccessResponseMessage == null) {
      throw Exception("onSuccessResponseMessage callback is not initialized.");
    }
    if (_baseURL == null) {
      throw Exception("Base URL is not initialized.");
    }
    if (_connectionTimeout == null) {
      throw Exception("Connection TimeOut is not initialized.");
    }
    if (_receiveTimeout == null) {
      throw Exception("Receive TimeOut is not initialized.");
    }
    if (_authStoreName == null) {
      throw Exception("authStoreName is not initialized.");
    }
    if (_dbName == null) {
      throw Exception("DataBase Name (dbName) is not initialized.");
    }

    dioClient = NetworkModule().provideDioClient(_handleTokenExpiry!,
        onSuccessResponseMessage: _onSuccessResponseMessage!,
        onErrorResponseMessage: _onErrorResponseMessage!,
        baseURL: _baseURL!,
        connectionTimeout: _connectionTimeout!,
        receiveTimeout: _receiveTimeout!);

    dataSource = LocalModule().provideLocalModule(
      _dbEncryptionKeyValue,
      dbName: _dbName!,
      authStoreName: _authStoreName!,
    );
  }

  BaseService.baseServicesInitailization(
    String? dbEncryptionKeyValue, {
    required Function(DioException) handleTokenExpiry,
    required String dbName,
    required String authStoreName,
    required void Function(String apiErrorResponseMessage)
        onErrorResponseMessage,
    required void Function(String apiSuccessResponseMessage)
        onSuccessResponseMessage,
    required String baseURL,
    required int connectionTimeout,
    required int receiveTimeout,
  }) {
    _dbEncryptionKeyValue = dbEncryptionKeyValue;
    _handleTokenExpiry = handleTokenExpiry;
    _dbName = dbName;
    _authStoreName = authStoreName;
    _onErrorResponseMessage = onErrorResponseMessage;
    _onSuccessResponseMessage = onSuccessResponseMessage;
    _baseURL = baseURL;
    _connectionTimeout = connectionTimeout;
    _receiveTimeout = receiveTimeout;
  }

  // Static initialization method
  static void initialize({
    required String? dbEncryptionKeyValue,
    required Function(DioException) handleTokenExpiry,
    required String dbName,
    required String authStoreName,
    required void Function(String apiErrorResponseMessage)
        onErrorResponseMessage,
    required void Function(String apiSuccessResponseMessage)
        onSuccessResponseMessage,
    required String baseURL,
    required int connectionTimeout,
    required int receiveTimeout,
  }) {
    _dbEncryptionKeyValue = dbEncryptionKeyValue;
    _handleTokenExpiry = handleTokenExpiry;
    _dbName = dbName;
    _authStoreName = authStoreName;
    _onErrorResponseMessage = onErrorResponseMessage;
    _onSuccessResponseMessage = onSuccessResponseMessage;
    _baseURL = baseURL;
    _connectionTimeout = connectionTimeout;
    _receiveTimeout = receiveTimeout;
  }
}
