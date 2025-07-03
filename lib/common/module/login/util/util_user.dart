import 'package:djqs/base/util/util_sharepref.dart';
import 'package:djqs/common/module/login/entity/userinfo_entity.dart';
import 'package:djqs/common/module/login/util/util_account.dart';

class UserUtil {
  static const String SP_USER = 'sp_user';
  late final AccountUtil accoutUtil = AccountUtil();

  UserUtil._internal();

  factory UserUtil() => _instance;

  static late final UserUtil _instance = UserUtil._internal();

  UserinfoEntity? _userEntity;

  setUser(UserinfoEntity? entity) async {
    _userEntity = entity;
    await BaseSPUtil().putEntity(SP_USER, _userEntity);
    //
    // final AccountEntity? account = accoutUtil.getAccount();
    // if (entity?.isUserb != account?.isUserb) {
    //   account?.isUserb = entity?.isUserb;
    //   await accoutUtil.setAccount(account);
    // }
  }

  UserinfoEntity? getUser() {
    if (_userEntity != null) return _userEntity;
    dynamic resource = BaseSPUtil().getEntity(SP_USER);
    if (resource != null) _userEntity = UserinfoEntity.fromJson(resource);
    return _userEntity;
  }

  Future<void> clear() async {
    _userEntity = null;
    await BaseSPUtil().putEntity(SP_USER, null);
  }
}
