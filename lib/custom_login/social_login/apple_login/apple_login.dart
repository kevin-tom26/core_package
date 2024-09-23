part of core_package;

typedef AppleSignInCallback = void Function(
    {UserCredential? authResult,
    String? appleIDToken,
    String? appleAuthorizationCode,
    String? firebaseToken});

mixin AppleSignInMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late RestResponse appleSignInResponse;
  final BaseService baseService = BaseService();

  Future<RestResponse> signInWithApple({
    required BuildContext context,
    required AppleSignInCallback? onSignInCallback,
    required String clientID,
    required String redirectURL,
    bool isRegistration = false,
    Future<bool> Function(String email)? checkUserExists,
    void Function(String? error)? onSignInError,
    void Function(String? error)? onRegistrationInError,
    Color loadingIndicatorColor = Colors.green,
  }) async {
    try {
      AuthorizationCredentialAppleID appleIDCredential;

      final rawNonce = generateNonce();

      final nonce = sha256ofString(rawNonce);

      if (Platform.isIOS) {
        // Trigger the Apple sign-in flow on iOS
        appleIDCredential = await SignInWithApple.getAppleIDCredential(scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ], nonce: nonce)
            .catchError((onError) {
          appleSignInResponse =
              RestResponse(apiSuccess: false, message: onError.toString());
        });
      } else if (Platform.isAndroid) {
        // Trigger the Apple sign-in flow on Android
        appleIDCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: clientID, // Replace with your client ID
            redirectUri: Uri.parse(redirectURL),
          ),
        ).catchError((onError) {
          appleSignInResponse =
              RestResponse(apiSuccess: false, message: onError.toString());
        });
        ;
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      // Extract the email from the Apple ID credential
      final email = appleIDCredential.email;

      if (isRegistration) {
        if (checkUserExists == null) {
          throw ArgumentError(
              'checkUserExists function is required for Registration.');
        }
        // Check if the user already exists
        if (email != null) {
          bool userExists = await checkUserExists(email);

          if (userExists) {
            if (onRegistrationInError != null) {
              onRegistrationInError(
                  "User already exists. Please login instead.");
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User already exists. Please login instead."),
                    duration: Duration(seconds: 2)));
              }
            }
            appleSignInResponse = RestResponse(
                apiSuccess: false, message: "User already exists !!");
            return appleSignInResponse;
          }
        }
      }

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

      // Create a new credential
      final AuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleIDCredential.identityToken,
        rawNonce: Platform.isIOS ? rawNonce : null,
        accessToken:
            Platform.isIOS ? null : appleIDCredential.authorizationCode,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User? user = authResult.user;

      if (user != null) {
        String? firebaseToken = await user.getIdToken();
        log('Firebase token: $firebaseToken');
        appleSignInResponse =
            await _processAuthenticationAPI(idLocalToken: firebaseToken ?? "");

        if (onSignInCallback != null) {
          onSignInCallback(
            authResult: authResult,
            appleIDToken: appleIDCredential.identityToken,
            appleAuthorizationCode: appleIDCredential.authorizationCode,
            firebaseToken: firebaseToken,
          );
        }

        log("Apple ID: ${user.email}");
        log('Signed in user is : ${user.displayName}');

        if (context.mounted) {
          Navigator.maybePop(context);
        }

        return appleSignInResponse;
      } else {
        appleSignInResponse =
            RestResponse(apiSuccess: false, message: "User is 'null' !!");
        if (onSignInError != null) {
          onSignInError("User is 'null' !!");
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.maybePop(context);
        });
      }
    } catch (error) {
      log('Error during Apple sign-in: $error');
      appleSignInResponse =
          RestResponse(apiSuccess: false, message: error.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.maybePop(context);
      });
      if (onSignInError != null) {
        onSignInError('Error during Apple sign-in: $error');
      } else {
        if (context.mounted) {
          if (error is ArgumentError &&
              error.message ==
                  'checkUserExists function is required for Registration.') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error during Apple sign-in: $error'),
                duration: const Duration(seconds: 2)));
          }
        }
      }
      return appleSignInResponse;
    }
    return appleSignInResponse;
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
      "source": "Apple",
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
    }

    return response;
  }
}

String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
