class BaseAnalysisData {
/*
{
  "device_id": "",
  "version": "",
  "platform": "",
  "brand": "",
}
*/

  String? deviceId;
  String? version;
  String? platform;
  String? brand;

  BaseAnalysisData({
    this.deviceId,
    this.version,
    this.platform,
    this.brand,
  });

  BaseAnalysisData.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id']?.toString();
    version = json['version']?.toString();
    platform = json['platform']?.toString();
    brand = json['brand']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['device_id'] = deviceId;
    data['version'] = version;
    data['platform'] = platform;
    data['brand'] = brand;

    return data;
  }
}
