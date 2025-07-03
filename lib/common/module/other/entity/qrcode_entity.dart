class QrcodeEntity {
  static const int QRTYPE_VERIFY = 1;
  static const int QRTYPE_SCORE = 2;

/*
{
  "type": 1,
  "uid": "11111",
  "create_time": 11111111111
}
*/

  int? type;
  String? uid;
  int? createTime;

  QrcodeEntity({
    this.type,
    this.uid,
    this.createTime,
  });

  QrcodeEntity.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toInt();
    uid = json['uid']?.toString();
    createTime = json['create_time']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['uid'] = uid;
    data['create_time'] = createTime;
    return data;
  }
}
