part of core_package;

// @module
class NetworkModule {
  static NetworkModule? _instance;
  factory NetworkModule() => _instance ??= NetworkModule._();
  NetworkModule._();

  Dio provideDio({
    required String baseURL,
    required int connectionTimeout,
    required int receiveTimeout,
  }) {
    final dio = Dio();
    dio
      ..options.baseUrl = baseURL
      ..options.connectTimeout = Duration(milliseconds: connectionTimeout)
      ..options.receiveTimeout = Duration(milliseconds: receiveTimeout)
      ..interceptors.add(LogInterceptor(
        request: kDebugMode ? true : false,
        responseBody: kDebugMode ? true : false,
        requestBody: kDebugMode ? true : false,
        requestHeader: kDebugMode ? true : false,
      ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (
            RequestOptions options,
            RequestInterceptorHandler handler,
          ) async {
            var token = CoreLocalData().accessToken;
            if (!isNull(token)) {
              options.headers.putIfAbsent('access_token', () => token);
            }
            handler.next(options);
          },
        ),
      );

    return dio;
  }

  // @provide
  // @singleton
  DioClient provideDioClient(
    Function(DioException) handleTokenExpiry, {
    required void Function(String apiSuccessResponseMessage)
        onSuccessResponseMessage,
    required void Function(String apiErrorResponseMessage)
        onErrorResponseMessage,
    required String baseURL,
    required int connectionTimeout,
    required int receiveTimeout,
  }) =>
      DioClient(
          provideDio(
              baseURL: baseURL,
              connectionTimeout: connectionTimeout,
              receiveTimeout: receiveTimeout),
          handleTokenExpiry,
          onErrorResponseMessage,
          onSuccessResponseMessage);

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  // @provide
  // @singleton
  // DioClient provideDioClient(Dio dio) => DioClient(provideDio());

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
}
