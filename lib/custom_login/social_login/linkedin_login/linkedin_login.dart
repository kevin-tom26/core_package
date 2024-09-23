part of core_package;

enum Scopes { openid, profile, email }

typedef SignInCallback = void Function({
  LinkedInProfile? userDetail,
  String? linkedInAccessToken,
  String? linkedInAuthorizationCode,
});

class LinkedInSignIn extends StatefulWidget {
  final BuildContext ctxt;
  final Size screenSize;
  final String clientID;
  final String clientSecret;
  final String redirectUri;
  final List<Scopes> scopes;
  final void Function(RestResponse apiResponse) onLinkedInLogin;
  final SignInCallback? onSignInCallback;
  final bool isRegistration;
  final Future<bool> Function(String email)? checkUserExists;
  final void Function(String? error)? onSignInError;
  final void Function(String? error)? onRegistrationInError;
  final Color loadingIndicatorColor;

  final ButtonType buttonType;
  final String buttonText;
  final double? widthMultiplier;
  final double? heightMultiplier;
  final double? iconImageScale;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Decoration? decoration;
  final EdgeInsets? padding;
  final double? iconSize;
  final Color? iconColor;
  final Color? disabledIconColor;
  final bool autofocus;
  final BoxConstraints? iconConstraints;
  final ButtonStyle? iconStyle;
  final bool? isIconSelected;
  final Widget? selectedIcon;
  final Widget? icon;
  final AlignmentGeometry? iconAlignment;
  final TextAlign? buttonTextAlignment;

  const LinkedInSignIn({
    super.key,
    required this.ctxt,
    required this.screenSize,
    required this.clientID,
    required this.clientSecret,
    required this.redirectUri,
    required this.onLinkedInLogin,
    required this.onSignInCallback,
    required this.scopes,
    required this.isRegistration,
    required this.loadingIndicatorColor,
    this.checkUserExists,
    this.onSignInError,
    this.onRegistrationInError,
    ////
    required this.buttonType,
    required this.buttonText,
    this.widthMultiplier,
    this.heightMultiplier,
    this.iconImageScale,
    this.backgroundColor,
    this.textStyle,
    this.decoration,
    this.padding,
    this.iconSize,
    this.iconColor,
    this.disabledIconColor,
    required this.autofocus,
    this.iconConstraints,
    this.iconStyle,
    this.isIconSelected,
    this.selectedIcon,
    this.icon,
    this.iconAlignment,
    this.buttonTextAlignment,
  });

  @override
  State<LinkedInSignIn> createState() => _LinkedInSignInState();
}

class _LinkedInSignInState extends State<LinkedInSignIn> {
  final appLinks = AppLinks();
  final Dio _dio = Dio();
  late RestResponse linkedInSignInResponse;
  final BaseService baseService = BaseService();

  late String state;
  late String scope;

  @override
  void initState() {
    super.initState();
    listenForAuthRedirect(); // Start listening for the auth redirect
  }

  @override
  Widget build(BuildContext context) {
    return (widget.buttonType == ButtonType.icon
        ? IconButton(
            onPressed: () async {
              RestResponse _resp = await signInWithLinkedIn();
              if (!_resp.apiSuccess) {
                widget.onLinkedInLogin(_resp);
              }
            },
            icon: widget.icon ??
                Container(
                  //padding: padding,
                  decoration: widget.decoration ??
                      BoxDecoration(
                          color: widget.backgroundColor ??
                              Colors.grey.withOpacity(0.5),
                          shape: BoxShape.circle),
                  child: Image.asset(
                    'packages/core_package/assets/images/application/login/linkedin.png',
                    scale: widget.iconImageScale ?? 1.3,
                  ),
                ),
            iconSize: widget.iconSize,
            color: widget.iconColor,
            disabledColor: widget.disabledIconColor,
            autofocus: widget.autofocus,
            constraints: widget.iconConstraints,
            style: widget.iconStyle,
            isSelected: widget.isIconSelected,
            selectedIcon: widget.selectedIcon,
          )
        : Container(
            //margin: EdgeInsets.symmetric(horizontal: widthMultiplier ?? 0),
            width: widget.screenSize.width * (widget.widthMultiplier ?? 1),
            height:
                widget.screenSize.height * (widget.heightMultiplier ?? 0.06),
            padding: widget.padding,
            decoration: widget.decoration ??
                BoxDecoration(
                    color:
                        widget.backgroundColor ?? Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(28)),
            child: GestureDetector(
              onTap: () async {
                RestResponse _resp = await signInWithLinkedIn();
                if (!_resp.apiSuccess) {
                  widget.onLinkedInLogin(_resp);
                }
              },
              child: Row(
                children: [
                  Container(
                    width: (widget.screenSize.width *
                            (widget.widthMultiplier ?? 1)) *
                        0.25,
                    alignment: widget.iconAlignment,
                    child: Image.asset(
                      'packages/custom_login/assets/images/application/login/linkedin_c.png',
                      scale: widget.iconImageScale ?? 1.8,
                    ),
                  ),
                  Expanded(
                    child: Text(widget.buttonText,
                        textAlign: widget.buttonTextAlignment,
                        style: widget.textStyle ??
                            const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis)),
                  )
                ],
              ),
            )));
    // ElevatedButton(
    //   onPressed: () => signInWithLinkedIn(),
    //   child: Text('Sign in with LinkedIn'),
    // );
  }

  Future<RestResponse> signInWithLinkedIn() async {
    state = generateRandomString(16);
    scope = convertScopesToString(widget.scopes);

    final String authUrl = 'https://www.linkedin.com/oauth/v2/authorization'
        '?response_type=code'
        '&client_id=${widget.clientID}'
        '&redirect_uri=${widget.redirectUri}'
        '&state=$state'
        '&scope=$scope';

    try {
      final Uri uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      linkedInSignInResponse =
          RestResponse(apiSuccess: true, message: "Opening auth page");
    } catch (onError) {
      linkedInSignInResponse =
          RestResponse(apiSuccess: false, message: onError.toString());
      if (widget.onSignInError != null) {
        widget.onSignInError!(onError.toString());
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(onError.toString()),
              duration: const Duration(seconds: 1)));
        }
      }
    }
    return linkedInSignInResponse;
  }

  // Call this in initState to start listening for the incoming link
  void listenForAuthRedirect() {
    appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        widget.onLinkedInLogin(await handleIncomingLink(uri));
      }
    });
  }

  // Function to handle the incoming link
  Future<RestResponse> handleIncomingLink(Uri uri) async {
    final String? returnedState = uri.queryParameters['state'];
    final String? code = uri.queryParameters['code'];

    if (returnedState == state && code != null) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: widget.loadingIndicatorColor,
              ),
            );
          },
        );
      }
      try {
        final String token = await _fetchAccessToken(code);
        final LinkedInProfile profileData = await _fetchUserProfile(token);

        if (widget.isRegistration) {
          if (widget.checkUserExists == null) {
            throw ArgumentError(
                'checkUserExists function is required for Registration.');
          }
          if (await widget.checkUserExists!(profileData.email)) {
            if (widget.onRegistrationInError != null) {
              widget.onRegistrationInError!("User already exists");
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("User already exists"),
                  duration: Duration(seconds: 2),
                ));
              }
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.maybePop(context);
            });
            linkedInSignInResponse = RestResponse(
                apiSuccess: false, message: "User already exists !!");
            return linkedInSignInResponse;
          }
        }

        linkedInSignInResponse = await _processAuthenticationAPI(
            idLocalToken: token,
            linkedInAuthorizationCode: code,
            userDetail: profileData);

        if (widget.onSignInCallback != null) {
          widget.onSignInCallback!(
            userDetail: profileData,
            linkedInAccessToken: token,
            linkedInAuthorizationCode: code,
          );
        }

        if (mounted) {
          Navigator.maybePop(context);
        }
        return linkedInSignInResponse;
      } catch (error) {
        log("$error");
        linkedInSignInResponse =
            RestResponse(apiSuccess: false, message: error.toString());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.maybePop(context);
        });
        if (widget.onSignInError != null) {
          widget.onSignInError!('$error');
        } else {
          if (mounted) {
            if (error is ArgumentError &&
                error.message ==
                    'checkUserExists function is required for Registration.') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$error'),
                  duration: const Duration(seconds: 2)));
            }
          }
        }
        return linkedInSignInResponse;
      }
    } else {
      // Handle invalid state or missing code (potential CSRF attack or error)
      linkedInSignInResponse = RestResponse(
          apiSuccess: false,
          message: "Invalid state or missing authorization code.");
      if (widget.onSignInError != null) {
        widget.onSignInError!("Invalid state or missing authorization code.");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid state or missing authorization code."),
            duration: Duration(seconds: 1)));
      }
    }
    return linkedInSignInResponse;
  }

  // Function to fetch the access token
  Future<String> _fetchAccessToken(String code) async {
    try {
      final Response response = await _dio.post(
        'https://www.linkedin.com/oauth/v2/accessToken',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': widget.redirectUri,
          'client_id': widget.clientID,
          'client_secret': widget.clientSecret,
        },
      );

      final Map<String, dynamic> responseBody = response.data;
      return responseBody['access_token'];
    } catch (e) {
      // if (widget.onSignInError != null) {
      //   widget.onSignInError!("Failed to fetch access token: $e");
      // } else {
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text("Failed to fetch access token: $e"),
      //         duration: const Duration(seconds: 1)));
      //   }
      // }
      throw Exception('Failed to fetch access token: $e');
    }
  }

  // Function to fetch the user's LinkedIn profile
  Future<LinkedInProfile> _fetchUserProfile(String accessToken) async {
    try {
      final Response profileResponse = await _dio.get(
        'https://api.linkedin.com/v2/userinfo',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final LinkedInProfile profileData =
          LinkedInProfile.fromJson(profileResponse.data);

      final String firstName = profileData.name;
      final String lastName = profileData.familyName;
      final String email = profileData.email;

      log('First Name: $firstName');
      log('Last Name: $lastName');
      log('Email: $email');

      return profileData;
      // Handle the fetched profile data (store in state, navigate, etc.)
    } catch (e) {
      // if (widget.onSignInError != null) {
      //   widget.onSignInError!("Failed to fetch user profile: $e");
      // } else {
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text("Failed to fetch user profile: $e"),
      //         duration: const Duration(seconds: 1)));
      //   }
      // }
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  static String convertScopesToString(List<Scopes> scopes) {
    // Define a map from enum to its string representation
    final Map<Scopes, String> scopeToString = {
      Scopes.openid: 'openid',
      Scopes.profile: 'profile',
      Scopes.email: 'email',
    };

    // Convert the list of enums to a list of strings
    final List<String> scopeStrings =
        scopes.map((scope) => scopeToString[scope]!).toList();

    // Join the list with '%20' and return the result
    return scopeStrings.join('%20');
  }

  // Function to generate a random string (for state parameter)
  static String generateRandomString(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = math.Random.secure();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }

  Future<RestResponse> _processAuthenticationAPI(
      {required String idLocalToken,
      required String linkedInAuthorizationCode,
      required LinkedInProfile? userDetail}) async {
    AuthData userData = AuthData(
      access_token: idLocalToken,
      expires_in: DateTime.now().add(const Duration(days: 30)),
    );
    Map<String, dynamic> queryParms;
    log("ID Tokenn Local:: ${(idLocalToken).toString()}");
    queryParms = {
      "auth_token": userData.access_token,
      "source": "Linkedin",
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
    //   "response": {"username": userDetail?.name}
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

class LinkedInProfile {
  String sub;
  String name;
  String givenName;
  String familyName;
  String picture;
  String email;
  bool emailVerified;

  LinkedInProfile({
    required this.sub,
    required this.name,
    required this.givenName,
    required this.familyName,
    required this.picture,
    required this.email,
    required this.emailVerified,
  });

  factory LinkedInProfile.fromJson(Map<String, dynamic> json) =>
      LinkedInProfile(
        sub: json["sub"],
        name: json["name"],
        givenName: json["given_name"],
        familyName: json["family_name"],
        picture: json["picture"],
        email: json["email"],
        emailVerified: json["email_verified"],
      );
}
