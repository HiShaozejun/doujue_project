class ScanInfoEntity {
/*
{
  "uid": 9515,
  "mobile": "18614084665",
  "realname": "开发2-公司",
  "sex": 2,
  "nickname": "测试-公司",
  "avatar": "[{\"img\":\"https://kmsp-qs-bj-1258783124.cos.ap-beijing.myqcloud.com/scaled_Screenshot_20240208_115730_tv.danmaku.bili_compressed.jpg\",\"width\":null,\"height\":null}]"
}
*/

  int? uid;
  String? mobile;
  String? realname;
  int? sex;
  String? nickname;
  String? avatar;
  String? createtime;

  ScanInfoEntity({
    this.uid,
    this.mobile,
    this.realname,
    this.sex,
    this.nickname,
    this.avatar,
    this.createtime,
  });

  ScanInfoEntity.fromJson(Map<String, dynamic> json) {
    uid = json['uid']?.toInt();
    mobile = json['mobile']?.toString();
    realname = json['realname']?.toString();
    sex = json['sex']?.toInt();
    nickname = json['nickname']?.toString();
    createtime = json['create_time']?.toString();
    avatar = json['avatar']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['mobile'] = mobile;
    data['realname'] = realname;
    data['sex'] = sex;
    data['nickname'] = nickname;
    data['create_time'] = createtime;
    data['avatar'] = avatar;
    return data;
  }
}
