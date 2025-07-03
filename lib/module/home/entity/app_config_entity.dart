class AppConfigEntity {
  static const String REACH_STORE_KM='200';

/*
{
  "site_name": "快小业",
  "apk_ver": "3.0.0",
  "apk_url": "",
  "apk_des": "版本更新，是否前往更新？",
  "ipa_ver": "3.0.0",
  "ios_shelves": "1.0.0",
  "ipa_url": "",
  "ipa_des": "版本更新，是否前往更新？",
  "small_shelves": "1.0.0",
  "share_title": "同城跑腿",
  "share_des": "跑腿系统",
  "share_img": "",
  "share_type": [
    "qq"
  ],
  "service_url": "",
  "delivery_km": "1000000",
  "coerce_delivery_km": "20000000",
  "reach_store_km": "200",
  "chatserver": "?hhqDD?TQKchKCJws:Tshw&:8CxtTD?h"
}
*/

  String? siteName;
  String? apkVer;
  String? apkUrl;
  String? apkDes;
  String? ipaVer;
  String? iosShelves;
  String? ipaUrl;
  String? ipaDes;
  String? smallShelves;
  String? shareTitle;
  String? shareDes;
  String? shareImg;
  List<String?>? shareType;
  String? serviceUrl;
  String? deliveryKm;
  String? coerceDeliveryKm;
  String? reachStoreKm;
  String? chatserver;

  AppConfigEntity({
    this.siteName,
    this.apkVer,
    this.apkUrl,
    this.apkDes,
    this.ipaVer,
    this.iosShelves,
    this.ipaUrl,
    this.ipaDes,
    this.smallShelves,
    this.shareTitle,
    this.shareDes,
    this.shareImg,
    this.shareType,
    this.serviceUrl,
    this.deliveryKm,
    this.coerceDeliveryKm,
    this.reachStoreKm,
    this.chatserver,
  });
  AppConfigEntity.fromJson(Map<String, dynamic> json) {
    siteName = json['site_name']?.toString();
    apkVer = json['apk_ver']?.toString();
    apkUrl = json['apk_url']?.toString();
    apkDes = json['apk_des']?.toString();
    ipaVer = json['ipa_ver']?.toString();
    iosShelves = json['ios_shelves']?.toString();
    ipaUrl = json['ipa_url']?.toString();
    ipaDes = json['ipa_des']?.toString();
    smallShelves = json['small_shelves']?.toString();
    shareTitle = json['share_title']?.toString();
    shareDes = json['share_des']?.toString();
    shareImg = json['share_img']?.toString();
    if (json['share_type'] != null) {
      final v = json['share_type'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      shareType = arr0;
    }
    serviceUrl = json['service_url']?.toString();
    deliveryKm = json['delivery_km']?.toString();
    coerceDeliveryKm = json['coerce_delivery_km']?.toString();
    reachStoreKm = json['reach_store_km']?.toString();
    chatserver = json['chatserver']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['site_name'] = siteName;
    data['apk_ver'] = apkVer;
    data['apk_url'] = apkUrl;
    data['apk_des'] = apkDes;
    data['ipa_ver'] = ipaVer;
    data['ios_shelves'] = iosShelves;
    data['ipa_url'] = ipaUrl;
    data['ipa_des'] = ipaDes;
    data['small_shelves'] = smallShelves;
    data['share_title'] = shareTitle;
    data['share_des'] = shareDes;
    data['share_img'] = shareImg;
    if (shareType != null) {
      final v = shareType;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['share_type'] = arr0;
    }
    data['service_url'] = serviceUrl;
    data['delivery_km'] = deliveryKm;
    data['coerce_delivery_km'] = coerceDeliveryKm;
    data['reach_store_km'] = reachStoreKm;
    data['chatserver'] = chatserver;
    return data;
  }

  double get reachStoreNum=>double.parse(reachStoreKm??REACH_STORE_KM);
  double get deliveryNum=>double.parse(deliveryKm??REACH_STORE_KM);

}
