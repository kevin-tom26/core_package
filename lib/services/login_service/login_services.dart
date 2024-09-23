part of core_package;
// import 'dart:developer';

// import 'package:core_package/core_package.dart';

// import 'package:dio/dio.dart';

class LoginService extends BaseService {
  LoginService() : super();

  Future<RestResponse> userLoginWithPassword(requestData) async {
    if (CustomLogin.loginWithPasswordURL == null ||
        CustomLogin.loginWithPasswordURL!.isEmpty) {
      throw Exception(
          "loginWithPasswordUrl cannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }
    if (CustomLogin.apiContentType == null ||
        CustomLogin.apiContentType!.isEmpty ||
        CustomLogin.apiAuthorization == null ||
        CustomLogin.apiAuthorization!.isEmpty) {
      throw Exception(
          "contentType and Authorization value cannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }
    final String url = CustomLogin.loginWithPasswordURL!;
    try {
      RestResponse _response = await dioClient.post(
        url,
        data: requestData,
        onHandleSuccessDisplay: (_, __) {},
        options: Options(headers: {
          'Content-Type': CustomLogin.apiContentType,
          'Authorization': CustomLogin.apiAuthorization,
        }),
      );
      if (_response.apiSuccess) {
        await _processLogin(_response);
      }
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }

  Future<RestResponse> userLoginWithOTP(requestData) async {
    if (CustomLogin.loginWithOTPURL == null ||
        CustomLogin.loginWithOTPURL!.isEmpty) {
      throw Exception(
          "login With OTP URL cannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }
    final String url = CustomLogin.loginWithOTPURL!;
    try {
      // RestResponse sample = RestResponse(
      //     statusCode: 200, apiSuccess: true, message: 'Verified Successfully');
      RestResponse _response = await dioClient.post(
        url,
        data: requestData,
        onHandleSuccessDisplay: (_, __) {},
      );
      if (_response.apiSuccess) {
        await _processLogin(_response);
      }
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }

  Future<RestResponse> guestLogin() async {
    if (CustomLogin.guestLoginURL == null ||
        CustomLogin.guestLoginURL!.isEmpty) {
      throw Exception(
          "guest Login URLcannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }
    final String url = CustomLogin.guestLoginURL!;
    try {
      RestResponse _response = await dioClient.post(
        url,
        onHandleSuccessDisplay: (_, __) {},
      );
      if (_response.apiSuccess) {
        await _processLogin(_response);
      }
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }

  Future<RestResponse> sendOTPRequest(requestData) async {
    if (CustomLogin.sendOTPURL == null || CustomLogin.sendOTPURL!.isEmpty) {
      throw Exception(
          "send OTP URL cannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }
    final String url = CustomLogin.sendOTPURL!;
    try {
      // RestResponse sample = RestResponse(
      //     message: 'Successfullt send OTP',
      //     apiSuccess: true,
      //     statusCode: 200,
      //     data: {
      //       "status": {
      //         "code": 200,
      //         "message": "Vehicle is successfully fetched"
      //       },
      //       "response": {"otpId": "6587"}
      //     });
      RestResponse _response = await dioClient.post(
        url,
        data: requestData,
        onHandleSuccessDisplay: (_, __) {},
      );
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }

  Future<void> _processLogin(RestResponse response) async {
    AuthData userData = AuthData();
    CoreLocalData().cleanUp();
    userData = AuthData.fromMap(response.data['response']);
    CoreLocalData().localUserData = userData;
    CoreLocalData().accessToken = userData.access_token;
    CoreLocalData().refreshToken = userData.refresh_token;
    CoreLocalData().userType = userData.user_type ?? "GUEST";
    CoreLocalData().userId = userData.user_id;
    CoreLocalData().userName = userData.user_name;

    CoreLocalData().tokenType = userData.token_type;
    CoreLocalData().expiresIn = userData.expires_in;
    CoreLocalData().scope = userData.scope;
    CoreLocalData().userRole = userData.user_role;
    CoreLocalData().tenantID = userData.tenant_id;
    CoreLocalData().tenantName = userData.tenant_name;
    CoreLocalData().emailPresent = userData.email_present;
    CoreLocalData().isNew = userData.isNew;
    CoreLocalData().userFirstName = userData.user_f_name;

    await dataSource.setAuthData(userData);

    // if (userData.user_id.isNotEmpty) {
    //   final DeviceInfoForPushService _deviceService =
    //       DeviceInfoForPushService(deviceDataStorageUrl: 'https://some/url');
    //   final _responsePush = await _deviceService.addPushNotificationToken();
    //   response.apiSuccess = _responsePush.apiSuccess;
    //   FirebaseMessageHandling().initNotifications(
    //     onNotificationTap: (message) {
    //       if (message != null) {
    //         //! Create the pushResponse model Here if needed.
    //         log('Message data${message.data}');
    //         GlobalAppContext.navigatorKey.currentState?.pushNamed(
    //           Routes.nav_screen,
    //           arguments: message,
    //         );
    //       }
    //     },
    //   );
    // }
  }

  Future<RestResponse> changePassword(requetData) async {
    if (CustomLogin.changePasswordURL == null ||
        CustomLogin.changePasswordURL!.isEmpty) {
      throw Exception(
          "change Password URL cannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }
    final String url = CustomLogin.changePasswordURL!;
    try {
      RestResponse _response = await dioClient.put(
        url,
        data: requetData,
        // onHandleSuccessDisplay: (_, __) {},
      );
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }

  Future<RestResponse> checkUserExists(
      {required String? emailorMobile,
      required String checkUserExistUrl}) async {
    CustomLogin.checkUserExistURL = checkUserExistUrl;
    if (checkUserExistUrl.isEmpty) {
      throw Exception("check User Exist URL cannot be empty.");
    }
    final String url = CustomLogin.checkUserExistURL!;
    try {
      // RestResponse sample = RestResponse(
      //     message: 'Successfullt send OTP',
      //     apiSuccess: true,
      //     statusCode: 200,
      //     data: {
      //       "status": {"code": 200, "message": "Checked User"},
      //       "response": {"exists": false}
      //     });
      RestResponse _response = await dioClient.get(
        url,
        onHandleSuccessDisplay: (_, __) {},
      );
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }

  Future<RestResponse> verifyOTPRequest(requestData) async {
    if (CustomLogin.verifyOTPURL == null || CustomLogin.verifyOTPURL!.isEmpty) {
      throw Exception("verify OTP URL cannot be null or empty.");
    }
    final String url = CustomLogin.verifyOTPURL!;
    try {
      RestResponse _response = await dioClient.post(
        url,
        data: requestData,
        onHandleSuccessDisplay: (_, __) {},
      );
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }

  Future<RestResponse> reSetPassword(requestData) async {
    if (CustomLogin.reSetPasswordURL == null ||
        CustomLogin.reSetPasswordURL!.isEmpty) {
      throw Exception("Re-Set Password URL cannot be null or empty.");
    }
    final String url = CustomLogin.reSetPasswordURL!;
    try {
      RestResponse _response = await dioClient.post(
        url,
        data: requestData,
        onHandleSuccessDisplay: (_, __) {},
      );
      return _response;
    } on DioException catch (e) {
      return RestResponse(
        message: DioExceptionUtil.handleError(e),
        apiSuccess: false,
      );
    }
  }
}
