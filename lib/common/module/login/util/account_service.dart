import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/login/entity/account_entity.dart';

class AccountService extends BaseService {
  static const int SMS_TYPE_LOGIN = 1;
  static const int SMS_TYPE_REGISTER = 2;
  static const int SMS_TYPE_RESET_PWD = 3;
  static const int SMS_TYPE_RESET_MOBILE = 4;

  Future<List<AccountEntity>?> loginWithPW(String? mobile, String? password) =>
      requestSync(
          data: {
            "username": mobile,
            "pass": password,
            "platform": BaseSystemUtil().platform,
          },
          path: "${BaseNetConst().commonUrl}Rider.Login.LoginByPass",
          create: (resource) => FuncEntity.parseList(
              resource, (json) => AccountEntity.fromJson(json)));

  Future<List<AccountEntity>?> loginWithSMS(String? mobile, String? smscode) =>
      requestSync(
          data: {
            "username": mobile,
            "code": smscode,
            "platform": BaseSystemUtil().platform,
          },
          path: "${BaseNetConst().commonUrl}Rider.Login.LoginByCode",
          create: (resource) => FuncEntity.parseList(
              resource, (json) => AccountEntity.fromJson(json)));

  Future<dynamic?> sendSmS(String? mobile, int? type) => requestSync(
          data: {
            "account": mobile,
            'type': type,
            'platform': BaseSystemUtil().platform,
            'code': "+86",
          },
          path: "${BaseNetConst().commonUrl}Rider.Login.GetCode",
          create: (resource) => resource);

  Future<FuncEntity> logout() => requestSync(
      path: "${BaseNetConst().commonUrl}Rider.User.LogOut",
      returnBaseEntity: true,
      create: (resource) => resource);

  Future<FuncEntity> resetPwd(
          String? mobile, String? smscode, String? password) =>
      requestSync(
          returnBaseEntity: true,
          data: {
            "mobile": mobile,
            'code': smscode,
            'pass': password,
            'platform': BaseSystemUtil().platform,
          },
          path: "${BaseNetConst().commonUrl}Rider.Login.Forget",
          create: (resource) => resource);

  Future<FuncEntity> resetMobile(String? mobile, String? smscode) =>
      requestSync(
          returnBaseEntity: true,
          data: {
            "mobile": mobile,
            'code': smscode,
            'platform': BaseSystemUtil().platform
          },
          path: "${BaseNetConst().commonUrl}Rider.User.UpMobile",
          create: (resource) => FuncEntity.fromJson(resource));

  Future<AccountEntity> register(
          String? mobile, String? smscode, String? password) =>
      requestSync(
          data: {
            "mobile": mobile,
            "smscode": smscode,
            "password": password,
            "platform": BaseSystemUtil().platform,
          },
          path: "${BaseNetConst().passportUrl}/account/userc/signup-smscode",
          create: (resource) => AccountEntity.fromJson(resource));

  //to-do
  Future<dynamic?> cancelAccount() => requestSync(
      returnBaseEntity: true,
      path: "${BaseNetConst().commonUrl}Rider.User.cancel",
      create: (resource) => resource);
}
