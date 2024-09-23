part of core_package;

typedef FacebookSignInCallback = void Function({
  UserCredential? authResult,
  String? facebookAccessToken,
  String? firebaseToken,
});

mixin FacebookSignInMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AccessToken? accessToken;
  late RestResponse facebookSignInResponse;
  final BaseService baseService = BaseService();

  Future<RestResponse> signInWithFacebook({
    bool isRegistration = false,
    Future<bool> Function(String email)? checkUserExists,
    void Function(String? error)? onSignInError,
    void Function(String? error)? onRegistrationInError,
    Color loadingIndicatorColor = Colors.blue,
    required BuildContext context,
    required FacebookSignInCallback? onSignInCallback,
  }) async {
    try {
      final AccessToken? fbAccessToken =
          await FacebookAuth.instance.accessToken;

      if (fbAccessToken != null) {
        await FacebookAuth.instance.logOut();
      }

      /// Log out from previous session

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        accessToken = result.accessToken!;
      } else {
        facebookSignInResponse =
            RestResponse(apiSuccess: false, message: "Facebook Loging failed.");
        if (onSignInError != null) {
          onSignInError("Status: ${result.status}, Error: ${result.message}");
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Status: ${result.status}, Error: ${result.message}"),
                duration: const Duration(seconds: 1)));
          }
        }
        return facebookSignInResponse;
      }

      if (accessToken != null) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(
                  color: loadingIndicatorColor,
                ),
              );
            },
          );
        }

        if (isRegistration) {
          if (checkUserExists == null) {
            throw ArgumentError(
                'checkUserExists function is required for Registration.');
          }
          final userData = await FacebookAuth.instance.getUserData();
          if (await checkUserExists(userData['email'])) {
            if (onRegistrationInError != null) {
              onRegistrationInError("User already exists");
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User already exists"),
                    duration: Duration(seconds: 2)));
              }
            }
            FacebookAuth.instance.logOut();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.maybePop(context);
            });
            facebookSignInResponse = RestResponse(
                apiSuccess: false, message: "User already exists !!");
            return facebookSignInResponse;
          }
        }

        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken!.tokenString);

        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        User? user = authResult.user;

        if (user != null) {
          String? firebaseToken = await user.getIdToken();
          log('Firebase token: $firebaseToken');

          facebookSignInResponse = await _processAuthenticationAPI(
              idLocalToken: firebaseToken ?? "");

          if (onSignInCallback != null) {
            onSignInCallback(
              authResult: authResult,
              facebookAccessToken: accessToken!.tokenString,
              firebaseToken: firebaseToken,
            );
          }

          log("Facebook id: ${user.email}");
          log('Signed in user is : ${user.displayName}');

          if (context.mounted) {
            Navigator.maybePop(context);
          }
          return facebookSignInResponse;
        } else {
          facebookSignInResponse =
              RestResponse(apiSuccess: false, message: "User is 'null' !!");
          if (onSignInError != null) {
            onSignInError("User is 'null' !!");
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.maybePop(context);
          });
          FacebookAuth.instance.logOut();
        }
      } else {
        facebookSignInResponse =
            RestResponse(apiSuccess: false, message: "Facebook Sign in failed");
        if (onSignInError != null) {
          onSignInError("Facebook Sign in failed");
        }
      }
    } catch (error) {
      log('Error during Facebook sign-in: $error');
      facebookSignInResponse =
          RestResponse(apiSuccess: false, message: error.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.maybePop(context);
      });
      if (onSignInError != null) {
        onSignInError('Error during Facebook sign-in: $error');
      } else {
        if (context.mounted) {
          if (error is ArgumentError &&
              error.message ==
                  'checkUserExists function is required for Registration.') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$error'), duration: const Duration(seconds: 2)));
          }
        }
      }
      return facebookSignInResponse;
    }
    return facebookSignInResponse;
  }

  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
  }

  Future<RestResponse> _processAuthenticationAPI({
    required String idLocalToken,
  }) async {
    AuthData userData = AuthData(
      access_token: idLocalToken,
      expires_in: DateTime.now().add(const Duration(days: 30)),
    );
    Map<String, dynamic> queryParms;
    log("ID Tokenn Local:: ${(idLocalToken).toString()}");
    queryParms = {
      "auth_token": userData.access_token,
      "source": "Facebook",
    };
    log(queryParms.toString());

    // Hitting Our API
    if (CustomLogin.socialLoginURL == null ||
        CustomLogin.socialLoginURL!.isEmpty) {
      throw Exception(
          "social Login URL cannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }

    // final usData = await FacebookAuth.instance.getUserData();

    // final RestResponse sample =
    //     RestResponse(apiSuccess: true, message: 'social login success', data: {
    //   "status": {"code": 200, "message": "social login success"},
    //   "response": {"username": usData['name']}
    // });
    // return sample;
    final RestResponse response = await baseService.dioClient.post(
      CustomLogin.socialLoginURL!,
      data: queryParms,
    );

    if (response.apiSuccess) {
      userData = AuthData.fromMap(response.data['response']);
      userData.expires_in = userData.expires_in ??
          DateTime.now().add(const Duration(days: 30)).toIso8601String();
      CoreLocalData().localUserData = userData;
      CoreLocalData().accessToken = userData.access_token;
      CoreLocalData().refreshToken = userData.refresh_token;
      CoreLocalData().userType = userData.user_type;
      CoreLocalData().userId = userData.user_id;
      CoreLocalData().userName = userData.user_name;

      CoreLocalData().tokenType = userData.token_type;
      CoreLocalData().scope = userData.scope;
      CoreLocalData().userRole = userData.user_role;
      CoreLocalData().tenantID = userData.tenant_id;
      CoreLocalData().tenantName = userData.tenant_name;
      CoreLocalData().emailPresent = userData.email_present;
      CoreLocalData().isNew = userData.isNew;
      CoreLocalData().userFirstName = userData.user_f_name;

      await baseService.dataSource.setAuthData(userData);
      // await baseService.dataSource.getAuthData().then((authData) async {
      //   print("Indise database");
      //   // ignore: unnecessary_null_comparison
      //   if (authData != null) {
      //     print("Auth data exists!!");
      //     log("${authData.user_f_name}");
      //   }
      // });

      // if (userData.access_token.isNotEmpty) {
      //   final DeviceInfoForPushService _deviceService =
      //       DeviceInfoForPushService();
      //   final _responsePush = await _deviceService.addPushNotificationToken();
      //   response.apiSuccess = _responsePush.apiSuccess;
      // }
    }

    return response;
  }
}
