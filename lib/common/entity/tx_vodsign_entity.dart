/// appid : "1258783124"
/// signature : "aJIjjVYmz+N5sdXZzhwYvFc6cwFzZWNyZXRJZD1BS0lEVGhuZEJiNkxwTWRodXF6RHpVVEFjc3NkN0twMm9ieDImY3VycmVudFRpbWVTdGFtcD0xNjgzMzk4NTUwJmV4cGlyZVRpbWU9MTY4MzQ4NDk1MCZyYW5kb209MjAwOTYwMTYwNSZjbGFzc0lkPTY5MzAyNw=="
/// current_time : 1683398550
/// expire_time : 1683484950

class TXVodSignEntity {
  TXVodSignEntity({
    String? appid,
    String? signature,
    num? currentTime,
    num? expireTime,
  }) {
    _appid = appid;
    _signature = signature;
    _currentTime = currentTime;
    _expireTime = expireTime;
  }

  TXVodSignEntity.fromJson(dynamic json) {
    _appid = json['appid'];
    _signature = json['signature'];
    _currentTime = json['current_time'];
    _expireTime = json['expire_time'];
  }

  String? _appid;
  String? _signature;
  num? _currentTime;
  num? _expireTime;

  TXVodSignEntity copyWith({
    String? appid,
    String? signature,
    num? currentTime,
    num? expireTime,
  }) =>
      TXVodSignEntity(
        appid: appid ?? _appid,
        signature: signature ?? _signature,
        currentTime: currentTime ?? _currentTime,
        expireTime: expireTime ?? _expireTime,
      );

  String? get appid => _appid;

  String? get signature => _signature;

  num? get currentTime => _currentTime;

  num? get expireTime => _expireTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appid'] = _appid;
    map['signature'] = _signature;
    map['current_time'] = _currentTime;
    map['expire_time'] = _expireTime;
    return map;
  }
}
