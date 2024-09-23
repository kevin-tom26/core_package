part of core_package;

typedef GoogleSignInCallback = void Function(
    {UserCredential? authResult,
    String? googleAccessToken,
    String? googleIDToken,
    String? firebaseToken});

mixin GoogleSignInMixin {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late RestResponse googleSignInResponse;
  final BaseService baseService = BaseService();

  Future<RestResponse> signInWithGoogle(
      {bool isRegistration = false,
      Future<bool> Function(String email)? checkUserExists,
      void Function(String? error)? onSignInError,
      void Function(String? error)? onRegistrationInError,
      Color loadingIndicatorColor = Colors.green,
      required BuildContext context,
      required GoogleSignInCallback? onSignInCallback}) async {
    try {
      await _googleSignIn.signOut(); // Ensure no previous session
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn().catchError((onError) {
        googleSignInResponse =
            RestResponse(apiSuccess: false, message: onError.toString());
        if (onSignInError != null) {
          onSignInError(onError.toString());
        }
      });
      if (googleUser != null) {
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
            _googleSignIn.disconnect();
            throw ArgumentError(
                'checkUserExists function is required for Registration.');
          }
          if (await checkUserExists(googleUser.email)) {
            if (onRegistrationInError != null) {
              onRegistrationInError("User already exists");
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User already exists"),
                    duration: Duration(seconds: 2)));
              }
            }
            _googleSignIn.disconnect();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.maybePop(context);
            });
            googleSignInResponse = RestResponse(
                apiSuccess: false, message: "User already exists !!");
            return googleSignInResponse;
          }
        }

        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        User? user = authResult.user;

        if (user != null) {
          String? firebaseToken = await user.getIdToken();
          log('Firebase token: $firebaseToken');

          googleSignInResponse = await _processAuthenticationAPI(
              idLocalToken: firebaseToken ?? "");

          if (onSignInCallback != null) {
            onSignInCallback(
              authResult: authResult,
              googleAccessToken: googleSignInAuthentication.accessToken,
              googleIDToken: googleSignInAuthentication.idToken,
              firebaseToken: firebaseToken,
            );
          }

          log("gmail id: ${googleUser.email}");
          log('Signed in user is : ${googleUser.displayName}');

          if (context.mounted) {
            Navigator.maybePop(context);
          }

          return googleSignInResponse;
        } else {
          googleSignInResponse =
              RestResponse(apiSuccess: false, message: "User is 'null' !!");
          if (onSignInError != null) {
            onSignInError("User is 'null' !!");
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.maybePop(context);
          });
          _googleSignIn.disconnect();
        }
      } else {
        googleSignInResponse =
            RestResponse(apiSuccess: false, message: "Google Sign in failed");
        if (onSignInError != null) {
          onSignInError("Google Sign in failed");
        }
      }
    } catch (error) {
      log('Error during Google sign-in: $error');
      googleSignInResponse =
          RestResponse(apiSuccess: false, message: error.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.maybePop(context);
      });
      if (onSignInError != null) {
        onSignInError('Error during Google sign-in: $error');
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
      return googleSignInResponse;
    }
    return googleSignInResponse;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
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
      "source": "Google",
    };
    log(queryParms.toString());

    // Hitting Our API
    if (CustomLogin.socialLoginURL == null ||
        CustomLogin.socialLoginURL!.isEmpty) {
      throw Exception(
          "social Login URL cannot be null or empty. Define them by calling setURLs in CustomLogin.");
    }

    // final RestResponse sample =
    //     RestResponse(apiSuccess: true, message: 'social login success', data: {
    //   "status": {"code": 200, "message": "social login success"},
    //   "response": {"username": googleUser!.displayName}
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

      _googleSignIn.disconnect();
    } else {
      _googleSignIn.disconnect();
    }

    return response;
  }
}
