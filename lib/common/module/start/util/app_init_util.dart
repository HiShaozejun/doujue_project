import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/const/base_const.dart';
import 'package:djqs/base/frame/base_lifecycle_observer.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_database.dart';
import 'package:djqs/base/util/util_debug.dart';
import 'package:djqs/base/util/util_file.dart';
import 'package:djqs/base/util/util_file_cache.dart';
import 'package:djqs/base/util/util_jpush.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_log.dart';
import 'package:djqs/base/util/util_network.dart';
import 'package:djqs/base/util/util_notification.dart';
import 'package:djqs/base/util/util_permission.dart';
import 'package:djqs/base/util/util_share.dart';
import 'package:djqs/base/util/util_umeng.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/util/common_util_auth_host.dart';
import 'package:djqs/common/util/common_util_im.dart';
import 'package:djqs/common/util/common_util_upload.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppInitUtil {
  late final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();

  AppInitUtil._internal();

  factory AppInitUtil() => _instance;

  static late final AppInitUtil _instance = AppInitUtil._internal();

  Future<void> initConfig() async {
    // AccountEntity? accout = AccountUtil().getAccount();
    // accout?.token='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJwcm9kIiwiYXVkIjoidXNlcmMiLCJpYXQiOiIxNzI4MzYxNTc1LjU3Mzk0NSIsIm5iZiI6IjE3MjgzNjE1NzUuNTczOTQ1IiwiZXhwIjoiMTcyODk2NjM3NS41NzM5NDUiLCJyZWZyZXNoIjowLCJ1aWQiOjEyMTk4LCJpaWQiOjEyNjY3fQ.GSOeutumjkTKk1R9xdc5fjwjviHsSTpQ3pgdwqYG-ZE';
    // accout?.refreshToken='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJwcm9kIiwiYXVkIjoidXNlcmMiLCJpYXQiOiIxNzI4MzYxNTc1LjU3Mzk0NSIsIm5iZiI6IjE3MjgzNjE1NzYuNTczOTQ1IiwiZXhwIjoiMTc1OTg5NzU3NS41NzM5NDUiLCJ1aWQiOjEyMTk4LCJyZWZyZXNoIjoxLCJpaWQiOjEyNjY3fQ.A2wljgA3JVY9TFlfX6edzMNicISHFR_AGOUAtJEPVTU';
    // await AccountUtil().setAccount(accout);
    BasePermissionUtil();
    BaseNetworkUtil();
    BaseLogUtil()
        .init(isDebug: (BaseDebugUtil().isDebug() || BaseDebugUtil.isUAT));
    BaseWidgetUtil.configLoading();
    await Hive.initFlutter();
    await BaseDBUtil().init();
    BaseFileCacheUtil().init();
    BaseFileUtil().init();
    await CommonAuthHostUtil().init();
  }

  ///三方相关
  Future<void> initConfigWithPolicy() async {
    BaseUmengUtil()
        .init(BaseConst.APPKEY_UMENG_ANDROID, BaseConst.APPKEY_UMENG_IOS);
    BaseLocationUtil()
        .init(BaseConst.APPKEY_AMAP_ANDROID, BaseConst.APPKEY_AMAP_IOS);
    BaseJPushUtil()
        .init(BaseConst.APPKEY_JPUSH_ANDROID, BaseConst.APPKEY_JPUSH_IOS);
    if (AccountUtil().isHasLogin) await initConfigWithLogin();
    // await BaseShareUtil()
    //     .init(BaseConst.APPID_WX, unisersalLink: BaseConst.IOS_UNIVERSAL_LINK);
    BaseNotificationUtil().init();
  }

  Future<void> initConfigWithLogin() async {
    await BaseJPushUtil()
        .setJPUshAlias(AccountUtil().getAccount()?.id?? '');
    await CommonIMUtil().init(AppConst.APPID_IM);
    await CommonUploadUtil();
    await CommonUploadUtil().init();
  }

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  BuildContext? get curContext => navigatorKey.currentContext;

  Future<dynamic>? routePage(routName, {arguments}) =>
      _navigatorKey.currentState?.pushNamed(routName, arguments: arguments);
}
