class AppConst {
  static const String APP_NAME = '顺单侠';
  static const String APP_ANDROID_PACKAGENAME = 'com.kmsp.djqs';
  static const String APP_IOS_BUNDLE_ID = 'com.kmsp.djqs';
  static final int IOS_APP_ID = 6743156073;
  //
  static const int APPID_IM = 1400644293;
  static const String TM_MAP_KEY = '3AMBZ-U5U6J-ZLDFX-XHX4V-5G45V-EEBFS';
  static const String TM_MAP_SECRET = 'OwbEDa8svZYIvSvfWX5c5LtbZNlvEAgP';

  //
  static const String IMAGE_DEFAULT =
      'https://app-1258783124.cos.ap-beijing.myqcloud.com/res/tt_user_cover_default.png';
  static const int INT_MAX = 0x7FFFFFFF; // 2147483647

  //
  static const int INTERVAL_UPLOAD_LOCATION = 30;
  static const int INTERVAL_REFRESH_LIST = 20;
  static const int INTERVAL_PUSH_AUDIO = 10;
  static const int LIMIT_TEXT_COUNT = 150;
  //
  static const String NOTI_ORDER='0';
  static const String NOTI_LOCATION='1';
  static const String NOTI_MSG='2';
  static const String NOTI_OTHER='3';




  AppConst._internal();

  factory AppConst() => _instance;

  static late final AppConst _instance = AppConst._internal();

  get H5_AGREEMENT => 'https://dj-common.kuaimasupin.com/wm/rider-index.html';

  get H5_PRIVACY => 'https://dj-common.kuaimasupin.com/wm/rider-privacy.html';
}
