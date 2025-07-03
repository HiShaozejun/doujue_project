import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/common/module/other/entity/citylist_entity.dart';
import 'package:djqs/common/module/other/entity/oauth_code_entity.dart';

class OtherService extends BaseService {
  Future<CityListEntity?> getCityList() => requestSync(
      path: "${BaseNetConst().commonUrl}/home/operation-city",
      create: (resource) => CityListEntity.fromJson(resource));

  Future<OauthCodeEntity?> oauth(String? clientId, String? token) =>
      requestSync(
          data: {'client_id': clientId, 'token': token},
          path: "${BaseNetConst().passportUrl}/oauth/authorization",
          create: (resource) => OauthCodeEntity.fromJson(resource));
}
