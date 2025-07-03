

class UserinfoEntity {
/*
{
  "id": "0",
  "user_nickname": "",
  "avatar": "",
  "avatar_thumb": "",
  "sex": "0",
  "signature": "",
  "balance": "0",
  "balancetotal": "0",
  "mobile": "",
  "orders": "0",
  "income": "0",
  "star": "5.0",
  "evaluates": "0",
  "good": "0",
  "average": "0",
  "bad": "0",
  "mgood": "0",
  "invite_code": ""
}
*/

  String? id;
  String? userNickname;
  String? avatar;
  String? avatarThumb;
  String? sex;
  String? signature;
  String? balance;
  String? balancetotal;
  String? mobile;
  String? orders;
  String? income;
  String? star;
  String? evaluates;
  String? good;
  String? average;
  String? bad;
  String? mgood;
  String? inviteCode;

  UserinfoEntity({
    this.id,
    this.userNickname,
    this.avatar,
    this.avatarThumb,
    this.sex,
    this.signature,
    this.balance,
    this.balancetotal,
    this.mobile,
    this.orders,
    this.income,
    this.star,
    this.evaluates,
    this.good,
    this.average,
    this.bad,
    this.mgood,
    this.inviteCode,
  });

  UserinfoEntity.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userNickname = json['user_nickname']?.toString();
    avatar = json['avatar']?.toString();
    avatarThumb = json['avatar_thumb']?.toString();
    sex = json['sex']?.toString();
    signature = json['signature']?.toString();
    balance = json['balance']?.toString();
    balancetotal = json['balancetotal']?.toString();
    mobile = json['mobile']?.toString();
    orders = json['orders']?.toString();
    income = json['income']?.toString();
    star = json['star']?.toString();
    evaluates = json['evaluates']?.toString();
    good = json['good']?.toString();
    average = json['average']?.toString();
    bad = json['bad']?.toString();
    mgood = json['mgood']?.toString();
    inviteCode = json['invite_code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_nickname'] = userNickname;
    data['avatar'] = avatar;
    data['avatar_thumb'] = avatarThumb;
    data['sex'] = sex;
    data['signature'] = signature;
    data['balance'] = balance;
    data['balancetotal'] = balancetotal;
    data['mobile'] = mobile;
    data['orders'] = orders;
    data['income'] = income;
    data['star'] = star;
    data['evaluates'] = evaluates;
    data['good'] = good;
    data['average'] = average;
    data['bad'] = bad;
    data['mgood'] = mgood;
    data['invite_code'] = inviteCode;
    return data;
  }
}

