/// nickname : "年O4"
/// avatar : "[{\"img\":\"https://kmsp-qs-bj-1258783124.cos.ap-beijing.myqcloud.com/687A/687A3BFBCD2E802B30B8A424CF97FC22.jpg\",\"width\":null,\"height\":null}]"

class UserProfileEntity {
  UserProfileEntity({
    String? nickname,
    String? avatar,
  }) {
    _nickname = nickname;
    _avatar = avatar;
  }

  UserProfileEntity.fromJson(dynamic json) {
    _nickname = json['nickname'];
    _avatar = json['avatar'];
  }

  String? _nickname;
  String? _avatar;

  UserProfileEntity copyWith({
    String? nickname,
    String? avatar,
  }) =>
      UserProfileEntity(
        nickname: nickname ?? _nickname,
        avatar: avatar ?? _avatar,
      );

  String? get nickname => _nickname;

  String? get avatar => _avatar;

  set avatar(String? avatar) => _avatar = avatar;

  set nickname(String? nickname) => _nickname = nickname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nickname'] = _nickname;
    map['avatar'] = _avatar;
    return map;
  }
}
