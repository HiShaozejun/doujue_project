import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_log.dart';
import 'package:djqs/module/home/entity/app_config_entity.dart';

class HomeService extends BaseService {
  Future<FuncEntity?> userStateChange(String value) => requestSync(
      showLoading: false,
      returnBaseEntity: true,
      data: {
        'rest': value,
        'lng': BaseLocationUtil().getLocationData()?.lng,
        'lat': BaseLocationUtil().getLocationData()?.lat
      },
      path: "${BaseNetConst().commonUrl}Rider.User.UpRest",
      create: (resource) => resource);

  Future<List<AppConfigEntity>?> getAppConfig() => requestSync(
      showLoading: false,
      path: "${BaseNetConst().commonUrl}Home.GetConfig",
      create: (resource) => FuncEntity.parseList(
          resource, (json) => AppConfigEntity.fromJson(json)));
}
