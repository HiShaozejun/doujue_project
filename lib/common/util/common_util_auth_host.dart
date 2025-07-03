import 'dart:async';

import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/other/auth_guset_page.dart';
import 'package:uni_links/uni_links.dart';

class CommonAuthHostUtil {
  late AuthEntity? authEntity;

  CommonAuthHostUtil._internal() {
    authEntity = AuthEntity();
  }

  factory CommonAuthHostUtil() => _instance;

  static late final CommonAuthHostUtil _instance =
      CommonAuthHostUtil._internal();

  Future init() async {
    try {
      final initialUri = await getInitialUri();
      _dealWithUri(initialUri);
    } catch (e) {
      e.toString();
    }

    uriLinkStream.listen((Uri? uri) {
      _dealWithUri(uri!);
    }, onError: (e) {
      e.toString();
    });
  }

  _dealWithUri(Uri? uri) {
    if (uri == null) return;
    if (uri.scheme == authEntity!.scheme) {
      if (uri.path == authEntity!.path) {
        AccountUtil().hasLogined(
            callbackNo: () => BaseSystemUtil().exitApp(),
            callback: () {
              authEntity = AuthEntity.fromJson(uri.queryParameters);
              BaseRouteUtil.push(null, AuthGuestPage(authEntity: authEntity));
            });
      }
    }
  }
}

class AuthEntity {
  String scheme = 'djsp';
  String path = 'auth';

  String? appName;
  String? appIcon;
  String? cliendId;
  String? code;

  AuthEntity({this.appName, this.appIcon, this.cliendId, this.code});

  AuthEntity.fromJson(Map<String, dynamic> json) {
    appName = json['app_name']?.toString();
    appIcon = json['app_icon']?.toString();
    cliendId = json['client_id']?.toString();
    code = json['code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['app_name'] = appName;
    data['app_icon'] = appIcon;
    data['client_id'] = cliendId;
    data['code'] = code;
    return data;
  }
}
