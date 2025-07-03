import 'package:djqs/base/util/util_sharepref.dart';

class BaseDebugUtil {
  static const bool defaultDebug = true;
  static const bool isUIDebug = false;
  static const bool isUAT = false;

  static const String SP_DEBUG = 'sp_debug';

  bool? _isDebug;

  BaseDebugUtil._internal();

  factory BaseDebugUtil() => _instance;

  static late final _instance = BaseDebugUtil._internal();

  void setDebug(bool isDebug) async {
    _isDebug = isDebug;
    await BaseSPUtil().putBool(SP_DEBUG, isDebug);
  }

  bool isDebug() {
    if (_isDebug != null) return _isDebug!;
    return BaseSPUtil().getBool(SP_DEBUG, defValue: defaultDebug);
  }
}
