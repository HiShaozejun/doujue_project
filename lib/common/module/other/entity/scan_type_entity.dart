class ScanTypeEntity {
/*
{
  "type": 1,
  "permission_code": "can_scan_userinfo",
  "name": "扫码用户信息"
}
*/

  int? type;
  String? permissionCode;
  String? name;

  ScanTypeEntity({
    this.type,
    this.permissionCode,
    this.name,
  });

  ScanTypeEntity.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toInt();
    permissionCode = json['permission_code']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['permission_code'] = permissionCode;
    data['name'] = name;
    return data;
  }
}
