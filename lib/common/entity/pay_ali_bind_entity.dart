class AliBindEntity {
/*
{
  "id": 37,
  "headhunter_id": 9500,
  "headhunter_name": "开发1-公司",
  "position": 1,
  "avatar": "https://tfs.alipayobjects.com/images/partner/T1qtxaXhXjXXXXXXXX",
  "nick_name": "Linda",
  "payee_name": "",
  "alipay_uid": "2088002168876464",
  "payee_identity": "",
  "payee_identity_name": "",
  "bank_deposit": "",
  "phone": "",
  "status": 2,
  "open_id": "",
  "company_id": 0,
  "company_name": "",
  "remarks": "",
  "review_time": "2023-10-18 14:57:10",
  "create_time": "2023-10-18 14:57:10",
  "is_deleted": 0
}
*/

  int? id;
  int? headhunterId;
  String? headhunterName;
  int? position;
  String? avatar;
  String? nickName;
  String? payeeName;
  String? alipayUid;
  String? payeeIdentity;
  String? payeeIdentityName;
  String? bankDeposit;
  String? phone;
  int? status;
  String? openId;
  int? companyId;
  String? companyName;
  String? remarks;
  String? reviewTime;
  String? createTime;
  int? isDeleted;

  AliBindEntity({
    this.id,
    this.headhunterId,
    this.headhunterName,
    this.position,
    this.avatar,
    this.nickName,
    this.payeeName,
    this.alipayUid,
    this.payeeIdentity,
    this.payeeIdentityName,
    this.bankDeposit,
    this.phone,
    this.status,
    this.openId,
    this.companyId,
    this.companyName,
    this.remarks,
    this.reviewTime,
    this.createTime,
    this.isDeleted,
  });

  AliBindEntity.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    headhunterId = json['headhunter_id']?.toInt();
    headhunterName = json['headhunter_name']?.toString();
    position = json['position']?.toInt();
    avatar = json['avatar']?.toString();
    nickName = json['nick_name']?.toString();
    payeeName = json['payee_name']?.toString();
    alipayUid = json['alipay_uid']?.toString();
    payeeIdentity = json['payee_identity']?.toString();
    payeeIdentityName = json['payee_identity_name']?.toString();
    bankDeposit = json['bank_deposit']?.toString();
    phone = json['phone']?.toString();
    status = json['status']?.toInt();
    openId = json['open_id']?.toString();
    companyId = json['company_id']?.toInt();
    companyName = json['company_name']?.toString();
    remarks = json['remarks']?.toString();
    reviewTime = json['review_time']?.toString();
    createTime = json['create_time']?.toString();
    isDeleted = json['is_deleted']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['headhunter_id'] = headhunterId;
    data['headhunter_name'] = headhunterName;
    data['position'] = position;
    data['avatar'] = avatar;
    data['nick_name'] = nickName;
    data['payee_name'] = payeeName;
    data['alipay_uid'] = alipayUid;
    data['payee_identity'] = payeeIdentity;
    data['payee_identity_name'] = payeeIdentityName;
    data['bank_deposit'] = bankDeposit;
    data['phone'] = phone;
    data['status'] = status;
    data['open_id'] = openId;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['remarks'] = remarks;
    data['review_time'] = reviewTime;
    data['create_time'] = createTime;
    data['is_deleted'] = isDeleted;
    return data;
  }
}
