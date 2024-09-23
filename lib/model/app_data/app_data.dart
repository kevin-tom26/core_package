part of core_package;

class AuthData {
  dynamic access_token;
  dynamic token_type;
  dynamic refresh_token;
  dynamic expires_in;
  dynamic scope;
  dynamic user_role;
  dynamic tenant_id;
  dynamic tenant_name;
  dynamic user_type;
  dynamic user_id;
  dynamic user_name;
  dynamic email_present;
  dynamic isNew;
  dynamic user_f_name;

  AuthData({
    this.access_token,
    this.token_type,
    this.refresh_token,
    this.expires_in,
    this.scope,
    this.user_role,
    this.tenant_id,
    this.tenant_name,
    this.user_type,
    this.user_id,
    this.user_name,
    this.email_present,
    this.isNew = false,
    this.user_f_name,
  });

  factory AuthData.fromMap(Map<String, dynamic> json) => AuthData(
        access_token: json['access_token'],
        token_type: json['token_type'],
        refresh_token: json['refresh_token'],
        expires_in: json['expires_in'],
        scope: json['scope'],
        user_role: json['user_role'],
        tenant_id: json['tenant_id'],
        tenant_name: json['tenant_name'],
        user_type: json['user_type'],
        user_id: json['user_id'],
        user_name: json['user_name'],
        email_present: json['email_present'],
        isNew: json['isNew'],
        user_f_name: json['user_f_name'],
      );

  Map<String, dynamic> toMap() => {
        "access_token": access_token,
        "token_type": token_type,
        "refresh_token": refresh_token,
        "expires_in": expires_in,
        "scope": scope,
        "user_role": user_role,
        "tenant_id": tenant_id,
        "tenant_name": tenant_name,
        "user_type": user_type,
        "user_id": user_id,
        "user_name": user_name,
        'email_present': email_present,
        "isNew": isNew,
        "user_f_name": user_f_name,
      };
}
