import 'dart:convert';
import 'dart:io';

import 'package:djqs/app/app_push_util.dart';
import 'package:djqs/app/push_trans_entity.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/util/util_debug.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';

/**
 * https://docs.jiguang.cn/jpush/client/Android/android_code
 * error code
 */
class BaseJPushUtil {
  late final JPushFlutterInterface _jPush = JPush.newJPush();
  late final AppPushUtil appPushUtil = AppPushUtil();

  factory BaseJPushUtil() => _instance;

  static late final BaseJPushUtil _instance = BaseJPushUtil._internal();

  BaseJPushUtil._internal() {}

  void init(String androidAppKey, String iosAppkey) {
    _jPush.setAuth(enable: true);
    _jPush.setup(
        appKey: Platform.isAndroid ? androidAppKey : iosAppkey,
        production: !BaseDebugUtil().isDebug(),
        debug: BaseDebugUtil().isDebug());
    _jPush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    _dealWithJpush();
  }

  void _dealWithJpush() async {
    await _resetAlias();
    _jPush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        message.toString();
      },
      onReceiveMessage: (Map<String, dynamic> message) async {
        try {
          // correct transmit data
          // String? extra = message['message'];
          // var json = jsonDecode(extra!);
          // PushTransEntity entity = PushTransEntity.fromJson(json);

          final extras = message['extras'];
          final extraData = extras?['cn.jpush.android.EXTRA'];
          final dataJson = jsonDecode(extraData['data']);
          appPushUtil.dealWithReceive(
              message['alert'], extraData['content'], dataJson);
        } catch (e) {
          e.toString();
        }
      },
      onOpenNotification: (Map<String, dynamic> message) async {
        appPushUtil.stopPushAudio();
        clearBadge();

        // String extra = message['extras']['cn.jpush.android.EXTRA'];
        // var json = jsonDecode(extra);
        // json.toString();
      },
    );
  }

  Future _resetAlias() async {
    if (AccountUtil().isHasLogin) return;
    String id = await _jPush.getRegistrationID();
    await deleteAlias();
    var alaias = await _jPush.getAlias();
    alaias.toString();
  }

  void clearBadge() {
    //_jPush.setBadge(0);
    FlutterAppBadger.removeBadge();
  }

  void checkPermission() async {
    bool result = await _jPush.isNotificationEnabled();
    if (!result) _jPush.openSettingsForNotification();
  }

  Future<String?>? getJPushRegister() async => await _jPush.getRegistrationID();

  /**
   *6027	别名绑定的设备数超过限制,最多允许绑定 10 个设备
   */
  Future<void> setJPUshAlias(String uid) async {
    try {
      await _jPush.setAlias(uid);
      var s = await _jPush.getRegistrationID();
      s.toString();
    } catch (e) {
      e.toString();
    }
  }

  Future<void> deleteAlias() async {
    try {
      await _jPush.deleteAlias();
    } catch (e) {
      e. toString();
    }
  }

  Future<void> setTag() async {
    // try {
    //   await _jPush.setTags(tags);
    // } catch (e) {
    //   e.toString();
    // }
  }

  setJpushSwitch(isStop) => isStop ? _jPush.stopPush() : _jPush.resumePush();

  void checkNotificationEnabled(BuildContext context) =>
      _jPush.isNotificationEnabled().then((bool result) {
        if (!result) {
          BaseDialogUtil.showCommonDialog(context,
              title: '重要通知提示',
              content: '开启通知后才能将订单相关的最新状态通知给您，是否开启？', onPosBtn: () {
            _jPush.openSettingsForNotification();
          });
        }
      });
}
