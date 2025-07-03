/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkZXYiLCJhdWQiOiJ1c2VyYyIsImlhdCI6MTY4MzYxNjA1MC40NzI1NDksIm5iZiI6MTY4MzYxNjA1MC40NzI1NDksImV4cCI6MTY4MzY0NDg1MC40NzI1NDksInJlZnJlc2giOjAsInVpZCI6OTUwMCwiaWlkIjo5NjQxfQ.j6B9noR6luU5O7dQ1MBwaerY5kH1kEA2ndOmTXC3WCQ"
/// refresh_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkZXYiLCJhdWQiOiJ1c2VyYyIsImlhdCI6MTY4MzYxNjA1MC40NzI1NDksIm5iZiI6MTY4MzYxNjA1MS40NzI1NDksImV4cCI6MTcxNTE1MjA1MC40NzI1NDksInVpZCI6OTUwMCwicmVmcmVzaCI6MSwiaWlkIjo5NjQxfQ.vvJxKav2OdNbhPSW02yYSEz9Iptad-Omv77_-LNMl_g"
/// is_register : 1

class RefreshTokenEntity {
  RefreshTokenEntity({
    String? token,
    String? refreshToken,
    int? isRegister,
  }) {
    _token = token;
    _refreshToken = refreshToken;
    _isRegister = isRegister;
  }

  RefreshTokenEntity.fromJson(dynamic json) {
    _token = json['token'];
    _refreshToken = json['refresh_token'];
    _isRegister = json['is_register'];
  }

  String? _token;
  String? _refreshToken;
  int? _isRegister;

  RefreshTokenEntity copyWith({
    String? token,
    String? refreshToken,
    int? isRegister,
  }) =>
      RefreshTokenEntity(
        token: token ?? _token,
        refreshToken: refreshToken ?? _refreshToken,
        isRegister: isRegister ?? _isRegister,
      );

  String? get token => _token;

  String? get refreshToken => _refreshToken;

  int? get isRegister => _isRegister;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['refresh_token'] = _refreshToken;
    map['is_register'] = _isRegister;
    return map;
  }
}
