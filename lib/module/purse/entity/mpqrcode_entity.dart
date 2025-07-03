class MPQRcodeEntity {
/*
{
  "wxacode": "/9j/4AAQSkZJRgABAQAAAQABAAD"
}
*/

  String? wxacode;

  MPQRcodeEntity({
    this.wxacode,
  });

  MPQRcodeEntity.fromJson(Map<String, dynamic> json) {
    wxacode = json['wxacode']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['wxacode'] = wxacode;
    return data;
  }
}
