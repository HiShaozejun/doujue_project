class ClipboardEntity {
  int? mediaId;
  String? packageName;

  ClipboardEntity({this.mediaId, this.packageName});

  ClipboardEntity.fromJson(Map<String, dynamic> json) {
    mediaId = json['mediaId']?.toInt();
    packageName = json['packageName']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['mediaId'] = mediaId;
    data['packageName'] = packageName;
    return data;
  }
}
