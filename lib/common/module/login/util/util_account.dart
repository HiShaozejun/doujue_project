import 'dart:async';

import 'package:djqs/app/app_push_util.dart';
import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_jpush.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_sharepref.dart';
import 'package:djqs/common/module/login/entity/account_entity.dart';
import 'package:djqs/common/module/login/util/login_route.dart';
import 'package:djqs/common/module/login/util/util_user.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:djqs/common/util/common_util_im.dart';
import 'package:djqs/module/home/util/home_route.dart';
import 'package:flutter/material.dart';

class AccountUtil {
  static const String SP_ACCOUNT = 'sp_account';
  bool isLogouting = false;
  bool isFinishInit = false;

  AccountUtil._internal();

  factory AccountUtil() => _instance;

  static late final AccountUtil _instance = AccountUtil._internal();

  AccountEntity? _accountEntity;

  setAccount(AccountEntity? entity) async {
    if (entity != null) isLogouting = false;
    _accountEntity = entity;
    await BaseSPUtil().putEntity(SP_ACCOUNT, _accountEntity);
  }

  AccountEntity? getAccount() {
    if (_accountEntity != null) return _accountEntity;
    dynamic resource = BaseSPUtil().getEntity(SP_ACCOUNT);
    if (resource != null) _accountEntity = AccountEntity.fromJson(resource);
    return _accountEntity;
  }

  bool isSelf(int? uid) {
    if (uid == AccountUtil().getAccount()?.id &&
        AccountUtil().getAccount()?.id != null) return true;
    return false;
  }

  bool get isRest => getAccount()?.isRestBool == true;

  Future<void> dealWithLogin(
      BuildContext context, AccountEntity? entity) async {
    await AccountUtil().setAccount(entity);
    await AppInitUtil().initConfigWithLogin();
    EventBus().send(EventCode.ACCOUNT_CHANGE);
    Navigator.pop(context);
  }

  bool get isHasLogin => getAccount() != null;

  //使用FutureOr还需在回调时进行类型判断处理
  FutureOr<bool> awaitHasLogined({bool isShowToast = true}) async {
    if (isHasLogin) {
      return true;
    }

    if (isShowToast) BaseWidgetUtil.showToast('请先登录');
    await AppInitUtil().routePage(LoginRoute.login);
    return isHasLogin;
  }

  void hasLogined(
      {bool showToast = true,
      Function()? callback,
      Function()? callbackNo,
      bool? isCanBack = false}) async {
    if (isHasLogin) {
      callback?.call();
      return;
    }

    if (showToast) BaseWidgetUtil.showToast('请先登录');
    await AppInitUtil().routePage(LoginRoute.login, arguments: isCanBack);
    if (isHasLogin)
      callback?.call();
    else
      callbackNo?.call();
  }

  Future<void> logout() async {
    await BaseWidgetUtil.showLoading();
    await AccountUtil().setAccount(null);
    //await UserUtil().clear(); //no use
    //
    await BaseLocationUtil().clear();
    // await SearchDBUtil().clear();
    await BaseJPushUtil().deleteAlias();
    AppPushUtil().stopPushAudio();
    await CommonIMUtil().logoutIm();
    await BaseWidgetUtil.cancelLoading();
    isFinishInit = false;
    BaseRouteUtil.popUntil(AppInitUtil().curContext!, HomeRoute.home);
    AccountUtil().hasLogined(showToast: false);
  }
}
