import 'package:djqs/base/util/util_debug.dart';

class BaseNetConst {
  BaseNetConst._internal();

  factory BaseNetConst() => _instance;

  static late final BaseNetConst _instance = BaseNetConst._internal();

  static const int PAGE_SIZE = 10;
  static const int PAGE_SIZE_MAX = 10000;

  static const int DIO_TIMEOUT = 5; //second

  static const int REQUEST_AGAIN = 1027; //token刷新后再次执行接口
  static const int REQUEST_OK = 200;
  static const int REQUEST_APP_OK = 0;

  //
  static const int REQUEST_LOGIN_EXPIRED = 700;

  //

  static const String REQUEST_GET = 'get';
  static const String REQUEST_POST = 'post';

  get passportUrl => BaseDebugUtil().isDebug()
      ? "https://passport-test.kuaimasupin.com"
      : "https://passport.kuaimasupin.com";

  get commonUrl => BaseDebugUtil().isDebug()
      ? "https://wm-loc-test.kuaimasupin.com/api/?s="
      : "https://wm-loc.kuaimasupin.com/api/?s=";

  get djCommonUrl => BaseDebugUtil().isDebug()
      ? "https://dj-common-test.kuaimasupin.com"
      : "https://dj-common.kuaimasupin.com";
}

enum HeaderMenuUrl {
  lead('lead', 'recruitManagement/handleResumeReceivedList');

  const HeaderMenuUrl(this.name, this.value);

  final String name;
  final String value;
}

enum HeaderMenuCode {
  lead('lead', 'handleResumeReceivedList');

  const HeaderMenuCode(this.name, this.value);

  final String name;
  final String value;
}
