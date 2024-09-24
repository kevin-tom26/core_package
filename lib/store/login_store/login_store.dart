//part of core_package;
import 'dart:convert';
import 'dart:developer';
//import 'package:core_package/core_package.dart';
import 'package:core_package/core_package.dart';
import 'package:crypto/crypto.dart';
import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  late LoginService loginService;

  _LoginStore() {
    loginService = LoginService();
  }

  late List<ReactionDisposer> _disposers;

  // store variables:-----------------------------------------------------------

  @observable
  bool loading = false;

  @observable
  String mobileOrEmail = '';

  // @observable
  // String password = '';

  @observable
  String otp = '';

  @observable
  String otpId = '';

  @observable
  String message = '';

  @observable
  bool isObscure = true;

  @observable
  bool isConfirmObscure = true;

  @observable
  bool isSignWithOtp = false;

  @observable
  String? errorText;

  // @computed
  // bool get isMobileOrEmailFilled => emailOrMobile.isNotEmpty;

  // @computed
  // bool get canLoginWithPassword => isMobileOrEmailFilled && password.isNotEmpty;

  // @computed
  // bool get canLoginWithOTP =>
  //     isMobileOrEmailFilled && otp.isNotEmpty && otp.length == 4;

  // actions:-------------------------------------------------------------------

  @action
  void setObscure() {
    isObscure = !isObscure;
    print(isObscure);
  }

  @action
  void setConfirmObscure() {
    isConfirmObscure = !isConfirmObscure;
    print(isConfirmObscure);
  }

  @action
  void setmobileOrEmail(String value) {
    mobileOrEmail = value;
  }

  // @action
  // void setPassword(String passwordVal) {
  //   password = passwordVal;
  // }

  @action
  void setOTP(String otpVal) {
    otp = otpVal;
  }

  @action
  void setMessage(String msg) {
    message = msg;
  }

  @action
  Future<bool> userLoginWithPassword(
      String emailOrMobile, String password, bool encryptPassword) async {
    final userName = emailOrMobile;
    final encypPassword = sha256.convert(utf8.encode(password)).toString();
    Map<String, dynamic> data = {
      'username': userName,
      'password': encryptPassword ? encypPassword : password,
      'grant_type': 'password',
    };

    final RestResponse _future = await loginService.userLoginWithPassword(data);
    // await Future.delayed(Duration(seconds: 2));
    if (_future.apiSuccess) {
      message = _future.message;
      log('mess 1 :$message');
    } else {
      message = _future.message;
      log('mess 2 :$message');
    }
    return _future.apiSuccess;
  }

  @action
  Future<RestResponse> checkUserExists(String emailOrMobile,
      {required String checkUserExistUrl}) async {
    final RestResponse _future = await loginService.checkUserExists(
        emailorMobile: emailOrMobile, checkUserExistUrl: checkUserExistUrl);
    if (_future.apiSuccess) {
      // message = _future.message;
      return _future;
    } else {
      // message = _future.message;
      return _future;
    }
  }

  @action
  Future<bool> userLoginWithOTP() async {
    final userName = mobileOrEmail;
    final channelName = isNumeric(userName) ? "SMS" : "Email";
    Map<String, dynamic> data = {
      "otpId": otpId,
      if (!isNumeric(userName)) "email": userName,
      if (isNumeric(userName)) "mobileNumber": userName,
      "otp": otp,
      "otpChannel": channelName,
    };

    final RestResponse _future = await loginService.userLoginWithOTP(data);
    if (_future.apiSuccess) {
      message = _future.message;
    } else {
      message = _future.message;
    }
    return _future.apiSuccess;
  }

  @action
  Future<bool> sendOTP() async {
    final userName = mobileOrEmail;
    final channelName = isNumeric(userName) ? "SMS" : "Email";
    Map<String, dynamic> data = {
      if (!isNumeric(userName)) "email": userName,
      if (isNumeric(userName)) "mobileNumber": userName,
      "otpChannel": channelName
    };
    final RestResponse _future = await loginService.sendOTPRequest(data);
    if (_future.apiSuccess) {
      otpId = _future.data['response']['otpId'];
    }
    return _future.apiSuccess;
  }

  @action
  Future<bool> verifyOTP() async {
    final userName = mobileOrEmail;
    final channelName = isNumeric(userName) ? "SMS" : "Email";
    Map<String, dynamic> data = {
      'otpId': otpId,
      'otp': otp,
      if (!isNumeric(userName)) "email": userName,
      if (isNumeric(userName)) "mobileNumber": userName,
      "otpChannel": channelName,
      "additionalData": {
        "verify_only_otp_request": true,
      },
    };
    final RestResponse _future = await loginService.verifyOTPRequest(data);
    if (_future.apiSuccess) {}
    return _future.apiSuccess;
  }

  @action
  Future<bool> guestLogin() async {
    final RestResponse _future = await loginService.guestLogin();
    await Future.delayed(const Duration(seconds: 3));
    return _future.apiSuccess;
  }

  @action
  Future<bool> changePassword(
      {required String currentPassword,
      required String newPassword,
      bool encryptPassword = true}) async {
    final currentPasswordEncrypt =
        sha256.convert(utf8.encode(currentPassword)).toString();
    final newPasswordEncrypt =
        sha256.convert(utf8.encode(newPassword)).toString();
    Map<String, dynamic> data = {
      "oldPassword": encryptPassword ? currentPasswordEncrypt : currentPassword,
      "newPassword": encryptPassword ? newPasswordEncrypt : newPassword,
    };
    final RestResponse _future = await loginService.changePassword(data);

    return _future.apiSuccess;
  }

  @action
  Future<bool> reSetPassword(
      {required String newPassword, bool encryptPassword = true}) async {
    loading = true;
    final userName = mobileOrEmail;
    final channelName = isNumeric(userName) ? "SMS" : "Email";
    final encypPassword = sha256.convert(utf8.encode(newPassword)).toString();
    if (otpId.isEmpty || otp.isEmpty || mobileOrEmail.isEmpty) {
      throw Exception('User not validated by sending OTP before resetting!!');
    }
    Map<String, dynamic> data = {
      "otpId": otpId,
      "otp": otp,
      "otpChannel": channelName,
      "password": encryptPassword ? encypPassword : newPassword,
    };
    if (isNumeric(userName)) {
      data['mobileNumber'] = mobileOrEmail;
    }
    if (!isNumeric(userName)) {
      data['email'] = mobileOrEmail;
    }

    final RestResponse _future = await loginService.reSetPassword(data);
    if (_future.apiSuccess) {
      loading = false;
      // message = _future.message;
      return _future.apiSuccess;
    } else {
      loading = false;
      // message = _future.message;
      return _future.apiSuccess;
    }
  }

  @action
  Future<bool> registerUser(
    String emailOrMobile,
    String password, {
    bool encryptPassword = true,
    String referralCode = '',
    required void Function(int?, RestResponse?)? onPressSuccessContinue,
    required void Function(int?, RestResponse?)? onPressErrorContinue,
  }) async {
    loading = true;
    final userName = emailOrMobile;
    final encypPassword = sha256.convert(utf8.encode(password)).toString();
    Map<String, dynamic> data = {
      if (!isNumeric(userName)) "email": userName,
      if (isNumeric(userName)) "mobileNo": userName,
      if (referralCode.isNotEmpty) "referralCode": referralCode,
      "password": encryptPassword ? encypPassword : password,
    };
    // return false;
    final RestResponse _future = await loginService.registerUser(
      requestData: data,
      onPressSuccess: onPressSuccessContinue,
      onPressError: onPressErrorContinue,
    );
    if (_future.apiSuccess) {
      loading = false;
      final _ress = await loginService.userLoginWithPassword({
        'username': userName,
        'password': encryptPassword ? encypPassword : password,
        'grant_type': 'password',
      });
      // message = _future.message;
      return _ress.apiSuccess;
    } else {
      loading = false;
      // message = _future.message;
      return _future.apiSuccess;
    }
  }

  //API calls-------------------------------------------------------------------

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

// class LoginErrorStore = _LoginErrorStore with _$LoginErrorStore;

// abstract class _LoginErrorStore with Store {
//   @observable
//   String? password;

//   @observable
//   String? email;

//   @computed
//   bool get hasErrorsInLogin => password == null && email == null;
// }
