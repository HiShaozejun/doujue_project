import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/common/module/login/entity/userinfo_entity.dart';
import 'package:djqs/module/mine/entity/user_profile_entity.dart';

class MineService extends BaseService {
  Future<List<UserinfoEntity>?> getUserInfo() => requestSync(
      showLoading: false,
      path: "${BaseNetConst().commonUrl}Rider.User.GetBaseInfo",
      create: (resource) => FuncEntity.parseList(
          resource, (json) => UserinfoEntity.fromJson(json)));

  Future<UserProfileEntity?> getUserProfile() => requestSync(
      path: "${BaseNetConst().passportUrl}/profile/userc",
      create: (resource) => UserProfileEntity.fromJson(resource));

  Future<bool?> updateUserProfile(UserProfileEntity entity) => requestSync(
      data: entity,
      path: "${BaseNetConst().passportUrl}/profile/userc/update",
      create: (resource) => resource);
}
