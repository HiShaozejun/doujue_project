class AccountEntityInfoIm {
  String? UserSig;
  String? userId;

  AccountEntityInfoIm({
    this.UserSig,
    this.userId,
  });

  AccountEntityInfoIm.fromJson(Map<String, dynamic> json) {
    UserSig = json['UserSig']?.toString();
    userId = json['userId']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['UserSig'] = UserSig;
    data['userId'] = userId;
    return data;
  }
}

class AccountEntity {
  static const REST_YES = '1';
  static const REST_NO = '0';

/*
{
  "id": "5",
  "openid": "o-cf16-Sw5vgbT4HJ1MMKtsnFU8o",
  "user_nickname": "jodie",
  "avatar": "https://wm-test.kuaimasupin.com/qishou_avatar.png",
  "avatar_thumb": "https://wm-test.kuaimasupin.com/qishou_avatar.png",
  "sex": "2",
  "signature": "",
  "balance": "0.01",
  "balancetotal": "0.01",
  "user_status": "1",
  "mobile": "13718106683",
  "type": "2",
  "cityid": "1",
  "isrest": "0",
  "isreg": "0",
  "token": "8d4af48e3b0731f9fe30610be25852ca",
  "im": {
    "UserSig": "eJwtzE0LgkAUheH-MuuQ68wdS6GFCKl9bYpoJ9KMdTFlmGQwov*eqcvzHHg-7Lw-eU5bFjHuAVuMm5RuO6poZKVdYQexhZzvl6pLY0ixyEeAAJGHYnp0b8jqwaWUHAAm7aj52xID8IWAcK7QfahjnraY1I-kWO1E6Dilm6vAW09lksVvk*E2Xj07aC75Yc2*P4EzMs0_",
    "userId": "dev_rider_5"
  },
  "amount": 0
}
*/

  String? id;
  String? openid;
  String? userNickname;
  String? avatar;
  String? avatarThumb;
  String? sex;
  String? signature;
  String? balance;
  String? balancetotal;
  String? userStatus;
  String? mobile;
  String? type;
  String? cityid;
  String? isrest;
  String? isreg;
  String? token;
  AccountEntityInfoIm? im;
  int? amount;

  AccountEntity({
    this.id,
    this.openid,
    this.userNickname,
    this.avatar,
    this.avatarThumb,
    this.sex,
    this.signature,
    this.balance,
    this.balancetotal,
    this.userStatus,
    this.mobile,
    this.type,
    this.cityid,
    this.isrest,
    this.isreg,
    this.token,
    this.im,
    this.amount,
  });

  AccountEntity.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    openid = json['openid']?.toString();
    userNickname = json['user_nickname']?.toString();
    avatar = json['avatar']?.toString();
    avatarThumb = json['avatar_thumb']?.toString();
    sex = json['sex']?.toString();
    signature = json['signature']?.toString();
    balance = json['balance']?.toString();
    balancetotal = json['balancetotal']?.toString();
    userStatus = json['user_status']?.toString();
    mobile = json['mobile']?.toString();
    type = json['type']?.toString();
    cityid = json['cityid']?.toString();
    isrest = json['isrest']?.toString();
    isreg = json['isreg']?.toString();
    token = json['token']?.toString();
    im = (json['im'] != null) ? AccountEntityInfoIm.fromJson(json['im']) : null;
    amount = json['amount']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['openid'] = openid;
    data['user_nickname'] = userNickname;
    data['avatar'] = avatar;
    data['avatar_thumb'] = avatarThumb;
    data['sex'] = sex;
    data['signature'] = signature;
    data['balance'] = balance;
    data['balancetotal'] = balancetotal;
    data['user_status'] = userStatus;
    data['mobile'] = mobile;
    data['type'] = type;
    data['cityid'] = cityid;
    data['isrest'] = isrest;
    data['isreg'] = isreg;
    data['token'] = token;
    if (im != null) {
      data['im'] = im!.toJson();
    }
    data['amount'] = amount;
    return data;
  }

  String getRestStr(value, {bool isPop = false}) => value == REST_YES
      ? '休息'
      : isPop
          ? '接单'
          : '接单中';

  String get restOpsValue => isrest == REST_YES ? REST_NO : REST_YES;

  bool get isRestBool => isrest == REST_YES ? true : false;
}
