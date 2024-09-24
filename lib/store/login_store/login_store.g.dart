// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStore, Store {
  late final _$loadingAtom =
      Atom(name: '_LoginStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$mobileOrEmailAtom =
      Atom(name: '_LoginStore.mobileOrEmail', context: context);

  @override
  String get mobileOrEmail {
    _$mobileOrEmailAtom.reportRead();
    return super.mobileOrEmail;
  }

  @override
  set mobileOrEmail(String value) {
    _$mobileOrEmailAtom.reportWrite(value, super.mobileOrEmail, () {
      super.mobileOrEmail = value;
    });
  }

  late final _$otpAtom = Atom(name: '_LoginStore.otp', context: context);

  @override
  String get otp {
    _$otpAtom.reportRead();
    return super.otp;
  }

  @override
  set otp(String value) {
    _$otpAtom.reportWrite(value, super.otp, () {
      super.otp = value;
    });
  }

  late final _$otpIdAtom = Atom(name: '_LoginStore.otpId', context: context);

  @override
  String get otpId {
    _$otpIdAtom.reportRead();
    return super.otpId;
  }

  @override
  set otpId(String value) {
    _$otpIdAtom.reportWrite(value, super.otpId, () {
      super.otpId = value;
    });
  }

  late final _$messageAtom =
      Atom(name: '_LoginStore.message', context: context);

  @override
  String get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  late final _$isObscureAtom =
      Atom(name: '_LoginStore.isObscure', context: context);

  @override
  bool get isObscure {
    _$isObscureAtom.reportRead();
    return super.isObscure;
  }

  @override
  set isObscure(bool value) {
    _$isObscureAtom.reportWrite(value, super.isObscure, () {
      super.isObscure = value;
    });
  }

  late final _$isConfirmObscureAtom =
      Atom(name: '_LoginStore.isConfirmObscure', context: context);

  @override
  bool get isConfirmObscure {
    _$isConfirmObscureAtom.reportRead();
    return super.isConfirmObscure;
  }

  @override
  set isConfirmObscure(bool value) {
    _$isConfirmObscureAtom.reportWrite(value, super.isConfirmObscure, () {
      super.isConfirmObscure = value;
    });
  }

  late final _$isSignWithOtpAtom =
      Atom(name: '_LoginStore.isSignWithOtp', context: context);

  @override
  bool get isSignWithOtp {
    _$isSignWithOtpAtom.reportRead();
    return super.isSignWithOtp;
  }

  @override
  set isSignWithOtp(bool value) {
    _$isSignWithOtpAtom.reportWrite(value, super.isSignWithOtp, () {
      super.isSignWithOtp = value;
    });
  }

  late final _$errorTextAtom =
      Atom(name: '_LoginStore.errorText', context: context);

  @override
  String? get errorText {
    _$errorTextAtom.reportRead();
    return super.errorText;
  }

  @override
  set errorText(String? value) {
    _$errorTextAtom.reportWrite(value, super.errorText, () {
      super.errorText = value;
    });
  }

  late final _$userLoginWithPasswordAsyncAction =
      AsyncAction('_LoginStore.userLoginWithPassword', context: context);

  @override
  Future<bool> userLoginWithPassword(
      String emailOrMobile, String password, bool encryptPassword) {
    return _$userLoginWithPasswordAsyncAction.run(() =>
        super.userLoginWithPassword(emailOrMobile, password, encryptPassword));
  }

  late final _$checkUserExistsAsyncAction =
      AsyncAction('_LoginStore.checkUserExists', context: context);

  @override
  Future<RestResponse> checkUserExists(String emailOrMobile,
      {required String checkUserExistUrl}) {
    return _$checkUserExistsAsyncAction.run(() => super
        .checkUserExists(emailOrMobile, checkUserExistUrl: checkUserExistUrl));
  }

  late final _$userLoginWithOTPAsyncAction =
      AsyncAction('_LoginStore.userLoginWithOTP', context: context);

  @override
  Future<bool> userLoginWithOTP() {
    return _$userLoginWithOTPAsyncAction.run(() => super.userLoginWithOTP());
  }

  late final _$sendOTPAsyncAction =
      AsyncAction('_LoginStore.sendOTP', context: context);

  @override
  Future<bool> sendOTP() {
    return _$sendOTPAsyncAction.run(() => super.sendOTP());
  }

  late final _$verifyOTPAsyncAction =
      AsyncAction('_LoginStore.verifyOTP', context: context);

  @override
  Future<bool> verifyOTP() {
    return _$verifyOTPAsyncAction.run(() => super.verifyOTP());
  }

  late final _$guestLoginAsyncAction =
      AsyncAction('_LoginStore.guestLogin', context: context);

  @override
  Future<bool> guestLogin() {
    return _$guestLoginAsyncAction.run(() => super.guestLogin());
  }

  late final _$changePasswordAsyncAction =
      AsyncAction('_LoginStore.changePassword', context: context);

  @override
  Future<bool> changePassword(
      {required String currentPassword,
      required String newPassword,
      bool encryptPassword = true}) {
    return _$changePasswordAsyncAction.run(() => super.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        encryptPassword: encryptPassword));
  }

  late final _$reSetPasswordAsyncAction =
      AsyncAction('_LoginStore.reSetPassword', context: context);

  @override
  Future<bool> reSetPassword(
      {required String newPassword, bool encryptPassword = true}) {
    return _$reSetPasswordAsyncAction.run(() => super.reSetPassword(
        newPassword: newPassword, encryptPassword: encryptPassword));
  }

  late final _$registerUserAsyncAction =
      AsyncAction('_LoginStore.registerUser', context: context);

  @override
  Future<bool> registerUser(String emailOrMobile, String password,
      {bool encryptPassword = true,
      String referralCode = '',
      required void Function(int?, RestResponse?)? onPressSuccessContinue,
      required void Function(int?, RestResponse?)? onPressErrorContinue}) {
    return _$registerUserAsyncAction.run(() => super.registerUser(
        emailOrMobile, password,
        encryptPassword: encryptPassword,
        referralCode: referralCode,
        onPressSuccessContinue: onPressSuccessContinue,
        onPressErrorContinue: onPressErrorContinue));
  }

  late final _$_LoginStoreActionController =
      ActionController(name: '_LoginStore', context: context);

  @override
  void setObscure() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setObscure');
    try {
      return super.setObscure();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmObscure() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setConfirmObscure');
    try {
      return super.setConfirmObscure();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setmobileOrEmail(String value) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setmobileOrEmail');
    try {
      return super.setmobileOrEmail(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOTP(String otpVal) {
    final _$actionInfo =
        _$_LoginStoreActionController.startAction(name: '_LoginStore.setOTP');
    try {
      return super.setOTP(otpVal);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMessage(String msg) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setMessage');
    try {
      return super.setMessage(msg);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
mobileOrEmail: ${mobileOrEmail},
otp: ${otp},
otpId: ${otpId},
message: ${message},
isObscure: ${isObscure},
isConfirmObscure: ${isConfirmObscure},
isSignWithOtp: ${isSignWithOtp},
errorText: ${errorText}
    ''';
  }
}
