import 'package:djqs/base/util/util_sharepref.dart';
import 'package:djqs/module/home/entity/app_config_entity.dart';

class AppConfigUtil {
  static const String SP_APP_CONFIG = 'sp_app_config';

  AppConfigUtil._internal();

  factory AppConfigUtil() => _instance;

  static late final AppConfigUtil _instance = AppConfigUtil._internal();

  AppConfigEntity? _configEntity;

  setConfig(AppConfigEntity? entity) async {
    _configEntity = entity;
    await BaseSPUtil().putEntity(SP_APP_CONFIG, _configEntity);
  }

  AppConfigEntity? getConfig() {
    if (_configEntity != null) return _configEntity;
    dynamic resource = BaseSPUtil().getEntity(SP_APP_CONFIG);
    if (resource != null) _configEntity = AppConfigEntity.fromJson(resource);
    return _configEntity;
  }
}
