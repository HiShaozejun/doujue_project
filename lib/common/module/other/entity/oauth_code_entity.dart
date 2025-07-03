class OauthCodeEntity {
/*
{
  "code": "fb6b857009243aa63ce2e84978ad2c9b"
}
*/

  String? code;

  OauthCodeEntity({
    this.code,
  });

  OauthCodeEntity.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    return data;
  }
}
