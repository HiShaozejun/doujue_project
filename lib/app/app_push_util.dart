import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:djqs/app/app_const.dart';
import 'package:djqs/app/push_trans_entity.dart';
import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_lifecycle_observer.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/route/base_route_manager.dart';
import 'package:djqs/base/route/base_route_oberver.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_notification.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:djqs/main.dart';
import 'package:djqs/module/home/home_page.dart';
import 'package:djqs/module/home/util/home_route.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/order_detail_page.dart';
import 'package:djqs/module/oderlist/util/oder_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPushUtil {
  Map<String, dynamic>? msg;
  AudioPlayer? player;
  Timer? _audioTimer;

  bool _isPlaying = false;
  int _playCount = -1;
  bool _isLoopAllow = false;
  bool _isInnerNotiShowing = false;

  AppPushUtil._internal();

  factory AppPushUtil() => _instance;

  static late final AppPushUtil _instance = AppPushUtil._internal();

  refreshMsg(Map<String, dynamic>? msg) {
    this.msg = msg;
  }

  dealWithReceive(String? title, String? content, dataJson) async {
    PushTransEntity pushEntity = PushTransEntity(
        title: title,
        extras: PushTransEntityExtras(
          content: content,
          data: PushTransEntityExtrasData(
              orderType: dataJson['order_type'],
              noticeType: dataJson['notice_type'],
              orderId: dataJson['order_id'],
              listType: dataJson['list_type']),
        ));

    String? noticeType = pushEntity.extras?.data?.noticeType;
    String? orderType = pushEntity.extras?.data?.orderType;

    if (BaseLifecycleObserver.isAppInForeground) {
      _dealWithInnerNoti(noticeType, pushEntity);
      if (noticeType == PushType.ORDER_DISPATCH && orderType == 'outrider' ||
          noticeType == 'chat')
        BaseNotificationUtil().showNotification(AppConst.NOTI_ORDER, '订单通知',
            id: _getNotiId(noticeType),
            title: pushEntity.title,
            body: pushEntity.extras?.content);
    } else
      BaseNotificationUtil().showNotification(AppConst.NOTI_ORDER, '订单通知',
          id: _getNotiId(noticeType),
          title: pushEntity.title,
          body: pushEntity.extras?.content);

    _dealWithSound(noticeType, orderType);
  }

  int? _getNotiId(String? noticeType) {
    switch (noticeType) {
      case PushType.ORDER_NEW:
        return 2001;
      case PushType.ORDER_DISPATCH:
        return 2002;
      case PushType.ORDER_CANCEL:
        return 2003;
      case PushType.ORDER_TIMEOUT:
        return 2004;
      case PushType.ORDER_GRAB:
        return 2005;
      default:
        return null;
    }
  }

  void _dealWithSound(String? noticeType, String? orderType) async {
    String audioSrc = '';
    if (noticeType == 'chat')
      audioSrc = _getSrc('ringtone');
    else if (noticeType == PushType.ORDER_NEW && orderType == 'outrider')
      audioSrc = _getSrc('ringtone_order_new');
    else if (noticeType == PushType.ORDER_DISPATCH && orderType == 'outrider')
      audioSrc = _getSrc('ringtong_order_dispatch');
    else if (noticeType == PushType.ORDER_CANCEL && orderType == 'outrider')
      audioSrc = _getSrc('ringtone_order_cancel');
    else if (noticeType == PushType.ORDER_TIMEOUT && orderType == 'outrider')
      audioSrc = _getSrc('ringtone_order_time_out');

    if (ObjectUtil.isEmptyStr(audioSrc)) return;

    // _playLoop(noticeType,orderType,audioSrc);
    AssetSource audioAS = AssetSource(audioSrc);
    if (_isPlaying) return;
    player = AudioPlayer();
    _isPlaying = false;
    await player?.play(audioAS);
  }

  @deprecated
  void _playLoop(String? noticeType, String? orderType, String audioSrc) async {
    _isLoopAllow = true;
    AssetSource audioAS = AssetSource(audioSrc);
    if (_playCount != -1) return;

    player = AudioPlayer();
    _isPlaying = true;
    await player?.play(audioAS);
    if (_playCount != -1) return;
    _playCount = 0;
    player?.onPlayerComplete.listen((event) async {
      _playCount++;
      if (_playCount <= 2)
        await player!.play(audioAS);
      else {
        _playCount = -1;
        player?.dispose();
        _isPlaying = false;
        player = AudioPlayer();
        _isPlaying = true;
        _audioTimer = Timer.periodic(
            Duration(seconds: AppConst.INTERVAL_PUSH_AUDIO), (timer) {
          if (_isLoopAllow) player!.play(audioAS);
        });
      }
    });
  }

  String _getSrc(String name, {String suffix = 'mp3'}) =>
      'sound/${name}.${suffix}';

  void stopPushAudio() {
    try {
      _isLoopAllow = false;
      _playCount = -1;
      if (_isPlaying) player?.dispose();
      _isPlaying = false;
    } catch (e) {
      e.toString();
    }
  }

  void dispose() {
    _audioTimer?.cancel();
    _audioTimer = null;
  }

  void _dealWithInnerNoti(String? noticeType, PushTransEntity pushEntity) {
    if (!_isInnerNotiShowing &&
        (noticeType == PushType.ORDER_NEW ||
            noticeType == PushType.ORDER_CANCEL)) {
      _isInnerNotiShowing = true;
      showInnerNoti(AppInitUtil().curContext!,
          '您有一个${noticeType == PushType.ORDER_NEW ? '新' : '取消'}订单，点击跳转',
          () async {
        int? listType = pushEntity.extras?.data?.listType;
        if (ObjectUtil.isEmptyInt(listType)) return;
        if (noticeType == PushType.ORDER_NEW) {
          if (BaseRouteObserver.instance.currentRouteName == HomeRoute.home)
            EventBus().send(EventCode.HOME_TAB_CHANGE, listType);
          else {
            await BaseRouteUtil.pushAndRemoveUntil(
                AppInitUtil().curContext!, HomePage());
          }
        } else {
          OrderEntity orderEntity = OrderEntity();
          orderEntity.id = pushEntity.extras?.data?.orderId;
          OrderItemData data = OrderItemData(orderEntity, null, listType);
          BaseRouteUtil.push(
              AppInitUtil().curContext!, OrderDetailPage(orderItemData: data));
        }
      });
    }
  }

  void showInnerNoti(BuildContext context, String txt, Function()? onTap) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: 40,
            left: 1,
            right: 1,
            child: Container(
                decoration:
                    BoxDecoration(color: BaseColors.c161616.withOpacity(0.8)),
                child: Row(children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      _isInnerNotiShowing = false;
                      onTap?.call();
                      overlayEntry.remove();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: BaseWidgetUtil.getTextWithWidgetH(txt,
                            isLeft: true,
                            primaryStyle: TextStyle(
                                fontSize: 14,
                                color: BaseColors.ffffff,
                                fontWeight: BaseDimens.fw_l),
                            minor: Icon(Icons.featured_play_list_outlined,
                                color: Colors.white, size: 15))),
                  )),
                  InkWell(
                      onTap: () {
                        _isInnerNotiShowing = false;
                        overlayEntry.remove();
                      },
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child:
                              Icon(Icons.close, color: Colors.white, size: 20)))
                ]))));

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted & _isInnerNotiShowing == true) {
        _isInnerNotiShowing = false;
        if (overlayEntry != null) overlayEntry.remove();
      }
    });
  }
}

class PushType {
  static const String ORDER_NEW = 'outrider_new_order';
  static const String ORDER_DISPATCH = 'sub_dispatch_order';
  static const String ORDER_CANCEL = 'user_cancel_order';
  static const String ORDER_TIMEOUT = 'orders_substation_notice';
  static const String ORDER_GRAB = 'orders_grab';
}
