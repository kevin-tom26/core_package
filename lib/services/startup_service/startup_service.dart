part of core_package;

class StartupService extends BaseService {
  // Factory constructor to ensure static variables are initialized before proceeding
  factory StartupService({
    String? dbEncryptionKeyValue,
    required Function(DioException) handleTokenExpiry,
    required String dbName,
    required String authStoreName,
    required void Function(String apiSuccessResponseMessage)
        onSuccessResponseMessage,
    required void Function(String apiErrorResponseMessage)
        onErrorResponseMessage,
    required String baseURL,
    required int connectionTimeout,
    required int receiveTimeout,
  }) {
    // Initialize the static variables in BaseService
    BaseService.baseServicesInitailization(
      dbEncryptionKeyValue,
      handleTokenExpiry: handleTokenExpiry,
      dbName: dbName,
      authStoreName: authStoreName,
      onErrorResponseMessage: onErrorResponseMessage,
      onSuccessResponseMessage: onSuccessResponseMessage,
      baseURL: baseURL,
      connectionTimeout: connectionTimeout,
      receiveTimeout: receiveTimeout,
    );

    // After initialization, return an instance of StartupService
    return StartupService._internal();
  }

  // Private named constructor to be used only after static variables initialization
  StartupService._internal() : super();
  // StartupService({
  //   String? dbEncryptionKeyValue,
  //   required Function(DioException) handleTokenExpiry,
  //   required String dbName,
  //   required String authStoreName,
  //   required void Function(String apiSuccessResponseMessage)
  //       onSuccessResponseMessage,
  //   required void Function(String apiErrorResponseMessage)
  //       onErrorResponseMessage,
  //   required String baseURL,
  //   required int connectionTimeout,
  //   required int receiveTimeout,
  // }) : super.baseServicesInitailization(dbEncryptionKeyValue,
  //           dbName: dbName,
  //           handleTokenExpiry: handleTokenExpiry,
  //           authStoreName: authStoreName,
  //           onSuccessResponseMessage: onSuccessResponseMessage,
  //           onErrorResponseMessage: onErrorResponseMessage,
  //           baseURL: baseURL,
  //           connectionTimeout: connectionTimeout,
  //           receiveTimeout: receiveTimeout);
  //  {
  //   BaseService.initialize(
  //     dbEncryptionKeyValue: dbEncryptionKeyValue,
  //     handleTokenExpiry: handleTokenExpiry,
  //     dbName: dbName,
  //     authStoreName: authStoreName,
  //     onSuccessResponseMessage: onSuccessResponseMessage,
  //     onErrorResponseMessage: onErrorResponseMessage,
  //     baseURL: baseURL,
  //     connectionTimeout: connectionTimeout,
  //     receiveTimeout: receiveTimeout,
  //   );
  // }
  Future<bool> doesTokenExist() async {
    int count = await dataSource.countUserdata();

    if (count > 0) {
      return await dataSource.getAuthData().then((authData) async {
        log("Called Does Token Exist");
        // ignore: unnecessary_null_comparison
        if (authData != null) {
          log("Auth data exists!!");
          CoreLocalData().localUserData = authData;
          CoreLocalData().accessToken = authData.access_token;
          CoreLocalData().refreshToken = authData.refresh_token;
          CoreLocalData().userId = authData.user_id;

          CoreLocalData().userType = authData.user_type;
          CoreLocalData().userName = authData.user_name;

          CoreLocalData().tokenType = authData.token_type;
          CoreLocalData().expiresIn = authData.expires_in;
          CoreLocalData().scope = authData.scope;
          CoreLocalData().userRole = authData.user_role;
          CoreLocalData().tenantID = authData.tenant_id;
          CoreLocalData().tenantName = authData.tenant_name;
          CoreLocalData().emailPresent = authData.email_present;
          CoreLocalData().isNew = authData.isNew;
          CoreLocalData().userFirstName = authData.user_f_name;

          return true;
        } else {
          return false;
        }
      }).catchError((error) {
        return false;
      });
    } else {
      return false;
    }
  }
}
