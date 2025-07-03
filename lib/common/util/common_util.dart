import 'package:djqs/base/util/util_sharepref.dart';

class CommonUtil {
  static const String SP_FIRST_LOGIN = 'sp_first_login';
  static const String SP_SETTING_PUSH = 'sp_setting_push';
  static const String SP_SETTING_RECOMMEND = 'sp_setting_recommend';

  CommonUtil._internal();

  factory CommonUtil() => _instance;

  static late final CommonUtil _instance = CommonUtil._internal();

  void set firstLogin(bool value) =>
      BaseSPUtil().putBool(SP_FIRST_LOGIN, value);

  bool get isFirstLogin => BaseSPUtil().getBool(SP_FIRST_LOGIN, defValue: true);

  void set pushAvailable(bool value) =>
      BaseSPUtil().putBool(SP_SETTING_PUSH, value);

  bool get isPushAvailable =>
      BaseSPUtil().getBool(SP_SETTING_PUSH, defValue: false);

  void set recommend(bool value) =>
      BaseSPUtil().putBool(SP_SETTING_RECOMMEND, value);

  bool get isRecommendAvailable =>
      BaseSPUtil().getBool(SP_SETTING_RECOMMEND, defValue: false);
}
