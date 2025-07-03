class BaseUpgradeEntity {
  static const int UPGRADE_TYPE_NO = 0;
  static const int UPGRADE_TYPE_NORMAL = 1;
  static const int UPGRADE_TYPE_MANDATORY = 2;

/*
{
  "title": "",
  "app_type": "android",
  "app_url": "https://kmspwx-1258783124.cos.ap-nanjing.myqcloud.com/dms/app/com.bfhd.kmsp_3.0.0.apk",
  "server_version": 123,
  "new_feature": "",
  "upgrade_type": 0
}
*/

  String? title;
  String? appType;
  String? appUrl;
  int? serverVersion;
  String? newFeature;
  int? upgradeType;
  String? sha256;

  BaseUpgradeEntity(
      {this.title,
      this.appType,
      this.appUrl,
      this.serverVersion,
      this.newFeature,
      this.upgradeType,
      this.sha256});

  BaseUpgradeEntity.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    appType = json['app_type']?.toString();
    appUrl = json['app_url']?.toString();
    serverVersion = json['server_version']?.toInt();
    newFeature = json['new_feature']?.toString();
    upgradeType = json['upgrade_type']?.toInt();
    sha256 = json['sha256']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['app_type'] = appType;
    data['app_url'] = appUrl;
    data['server_version'] = serverVersion;
    data['new_feature'] = newFeature;
    data['upgrade_type'] = upgradeType;
    data['sha256'] = sha256;
    return data;
  }

  get isForceUpdate => upgradeType == BaseUpgradeEntity.UPGRADE_TYPE_MANDATORY;
}
