<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## Project Documentation
## Overview
This project provides a custom package that includes various functionalities, such as a custom login method, database configuration, and client setup. This documentation will guide you through initializing and using the key components of the package.

## Getting Started
Prerequisites
Flutter SDK
Required packages (as specified in pubspec.yaml)
Initialization
To start using the package, you first need to initialize the StartupService class. This class is responsible for configuring the database and Dio clients.

## Step 1: Initialize StartupService
In your splash screen, override the initState method and initialize the StartupService as follows:

```dart
void initState() {
  _startupService = StartupService(
    handleTokenExpiry: (error) {},
    dbName: DBConstants.DB_NAME,
    authStoreName: DBConstants.AUTH_STORE_NAME,
    onErrorResponseMessage: (apiErrorResponseMessage) {
      CommonMethods.showErrorMessage(
          GlobalAppContext.navigatorKey.currentContext!,
          apiErrorResponseMessage);
    },
    onSuccessResponseMessage: (apiSuccessResponseMessage) {
      CommonMethods.showSuccessMessage(
          GlobalAppContext.navigatorKey.currentContext!,
          apiSuccessResponseMessage);
    },
    baseURL: Config.baseUrl,
    connectionTimeout: Config.connectionTimeout,
    receiveTimeout: Config.receiveTimeout
  );
  super.initState();
}
```

## Custom Login Setup
To use the custom login functionality, create an instance of the CustomLogin class and set the necessary URLs for the various login methods.

## Step 2: Create CustomLogin Instance
```dart
final CustomLogin _customLogin = CustomLogin();
```
## Step 3: Configure URLs
Initialize the URLs for login in the init method:
```dart
_customLogin.setURLS(
  loginWithPasswordUrl: "loginURL",
  sendOTPUrl: 'Some OTP URL',
  loginWithOTPUrl: 'some login otp url',
  verifyOTPUrl: "Some verify otp URL",
  socialLoginUrl: "Some Social Login URL",
  changePasswordUrl: "Some change password URL",
  reSetPasswordUrl: "Some reset password url",
  registrationUrl: "registration url",
  contentType: Config.contentTypeApp,
  authorization: Config.basicAuth
);
```

## User Input Fields
You can use the methods provided by CustomLogin to create input fields for user credentials.
```dart
// Username Field
_customLogin.userName(
  context: context,
  controller: mailController,
);

// Email Field
_customLogin.email(
  context: context,
  controller: uNameController,
);

// Mobile Field
_customLogin.mobile(
  context: context,
  hintText: 'Mobile Number',
  controller: phoneController,
  showPhoneNumberLength: false
);

// Password Field
_customLogin.password(
  context: context,
  hintText: 'Password',
  controller: passwordController
);
```
## Submitting Login
For auto validation and API calls, utilize the submitButton method.
```dart
_customLogin.submitButton(
  context: context,
  loginMethod: LoginMethod.mobileOTP,
  screenSize: MediaQuery.of(context).size,
  onSubmit: () {
    // Handle submit action
  },
  validate: true,
  onValidationError: (errorMessage) {
    // Handle error
  },
  onValidationSuccess: () {
    // Handle validation success
  },
  buttonText: 'Login',
);
```
## Custom Handler
Apart from submitButton method we can use various handler functions like loginSubmitHandler(), changePasswordHandler(), reSetPasswordHandler(), registrationHandler().
Example of registrationHandler():
```dart
ElevatedButton(
  onPressed: () {
    _customLogin.registrationHandler(
      context: context,
      registrationMethod: RegistrationMethod.mobilePassword,
      onSubmit: () {
        // Handle submit action
      },
      onValidationError: (errorMessage) {
        // Handle validation error
      },
      onValidationSuccess: () {
        // Handle validation success
      },
      onPressSuccessContinue: (Status, Response) {
        // Handle post validation
      },
      onPressErrorContinue: (Status, Response) {
        // Handle post validation
      },
    );
  },
  child: const Text('Register User')
);
```
## Social Login Methods
Before using social login methods, ensure necessary configurations are in place. Here’s how to implement various social logins:

## Google Login:
```dart
_customLogin.googleLogin(
  screenSize: MediaQuery.of(context).size,
  context: context,
  buttonType: ButtonType.icon,
  onGoogleLogin: (apiResponse) {
    if (apiResponse.apiSuccess) {
      // Handle Navigation
    }
  },
);
```
## Facebook Login:
```dart
_customLogin.facebookLogin(
  screenSize: MediaQuery.of(context).size,
  context: context,
  buttonType: ButtonType.icon,
  onFacebookLogin: (apiResponse) {
    if (apiResponse.apiSuccess) {
      // Handle Navigation
    }
  },
);
```
## LinkedIn Login:
```dart
_customLogin.linkedInLogin(
  context: context,
  screenSize: MediaQuery.of(context).size,
  buttonType: ButtonType.icon,
  clientID: 'client ID',
  clientSecret: 'Client secret key',
  redirectURL: 'redirect url link',
  onLinkedInLogin: (apiResponse) {
    // Handle Navigation
  },
);
```
## Apple Login:
```dart
_customLogin.appleLogin(
  screenSize: MediaQuery.of(context).size,
  context: context,
  clientID: "client ID",
  redirectURL: "redirect url",
  buttonType: ButtonType.icon,
  onAppleLogin: (apiResponse) {
    if (apiResponse.apiSuccess) {
      // Handle Navigation
    }
  },
);
```
## OTP Method
Here’s how to set up the OTP method:
```dart
_customLogin.otpField(
  screenSize: MediaQuery.of(context).size,
  otpProjectCode: "project code for auto reading of otp",
  showFieldAsBox: true,
  timerDuration: const Duration(seconds: 16),
  errorText: "error text",
  onResendOTP: () {
    // Handle OTP resend
  },
  onCodeChanged: (value) {
    // Handle code change
  },
  onSubmit: (value) {
    // Handle submit navigation
  },
);
```
## Conclusion
This documentation outlines the basic setup and usage of the custom package. For further details or advanced configurations, refer to the package's source code.
