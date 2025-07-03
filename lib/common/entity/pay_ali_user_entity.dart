class AliUserInfo {
/*
{
  "code": "10000",
  "msg": "Success",
  "avatar": "https://tfs.alipayobjects.com/images/partner/T1qtxaXhXjXXXXXXXX",
  "nick_name": "Linda",
  "user_id": "2088002168876464"
}
*/

  String? code;
  String? msg;
  String? avatar;
  String? nickName;
  String? userId;

  AliUserInfo({
    this.code,
    this.msg,
    this.avatar,
    this.nickName,
    this.userId,
  });

  AliUserInfo.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    msg = json['msg']?.toString();
    avatar = json['avatar']?.toString();
    nickName = json['nick_name']?.toString();
    userId = json['user_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['avatar'] = avatar;
    data['nick_name'] = nickName;
    data['user_id'] = userId;
    return data;
  }
}

class AliTokenInfo {
/*
{
  "access_token": "authusrB7606fae824e944c28950a43f60bedX46",
  "alipay_user_id": "20881046655017564151829511416546",
  "auth_start": "2023-10-17 17:38:49",
  "expires_in": 1296000,
  "re_expires_in": 2592000,
  "refresh_token": "authusrB18144baafc46495bb2fd83fdeb070X46",
  "user_id": "2088002168876464"
}
*/

  String? accessToken;
  String? alipayUserId;
  String? authStart;
  int? expiresIn;
  int? reExpiresIn;
  String? refreshToken;
  String? userId;

  AliTokenInfo({
    this.accessToken,
    this.alipayUserId,
    this.authStart,
    this.expiresIn,
    this.reExpiresIn,
    this.refreshToken,
    this.userId,
  });

  AliTokenInfo.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token']?.toString();
    alipayUserId = json['alipay_user_id']?.toString();
    authStart = json['auth_start']?.toString();
    expiresIn = json['expires_in']?.toInt();
    reExpiresIn = json['re_expires_in']?.toInt();
    refreshToken = json['refresh_token']?.toString();
    userId = json['user_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['alipay_user_id'] = alipayUserId;
    data['auth_start'] = authStart;
    data['expires_in'] = expiresIn;
    data['re_expires_in'] = reExpiresIn;
    data['refresh_token'] = refreshToken;
    data['user_id'] = userId;
    return data;
  }
}

class AliUserEntity {
/*
{
  "token_info": {
    "access_token": "authusrB7606fae824e944c28950a43f60bedX46",
    "alipay_user_id": "20881046655017564151829511416546",
    "auth_start": "2023-10-17 17:38:49",
    "expires_in": 1296000,
    "re_expires_in": 2592000,
    "refresh_token": "authusrB18144baafc46495bb2fd83fdeb070X46",
    "user_id": "2088002168876464"
  },
  "user_info": {
    "code": "10000",
    "msg": "Success",
    "avatar": "https://tfs.alipayobjects.com/images/partner/T1qtxaXhXjXXXXXXXX",
    "nick_name": "Linda",
    "user_id": "2088002168876464"
  }
}
*/

  AliTokenInfo? tokenInfo;
  AliUserInfo? userInfo;

  AliUserEntity({
    this.tokenInfo,
    this.userInfo,
  });

  AliUserEntity.fromJson(Map<String, dynamic> json) {
    tokenInfo = (json['token_info'] != null)
        ? AliTokenInfo.fromJson(json['token_info'])
        : null;
    userInfo = (json['user_info'] != null)
        ? AliUserInfo.fromJson(json['user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (tokenInfo != null) {
      data['token_info'] = tokenInfo!.toJson();
    }
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    return data;
  }
}
