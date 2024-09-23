part of core_package;

mixin UserLocalData {
  String? userType = '';
  String? accessToken;
  String? refreshToken;
  String? userName;
  String? userId = '';

  dynamic tokenType;
  dynamic expiresIn;
  dynamic scope;
  dynamic userRole;
  dynamic tenantID;
  dynamic tenantName;
  dynamic emailPresent;
  dynamic isNew;
  dynamic userFirstName;

  AuthData localUserData = AuthData();

  userCleanUp() {
    userType = '';
    accessToken = null;
    refreshToken = null;
    userId = '';
    userName = null;

    tokenType = null;
    expiresIn = null;
    scope = null;
    userRole = null;
    tenantID = null;
    tenantName = null;
    emailPresent = null;
    isNew = null;
    userFirstName = null;

    localUserData = AuthData();
  }
}
