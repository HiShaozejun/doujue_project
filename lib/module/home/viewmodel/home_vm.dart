import 'dart:async';

import 'package:djqs/app/app_const.dart';
import 'package:djqs/app/app_notifier.dart';
import 'package:djqs/app/app_push_util.dart';
import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/util/util_countdown.dart';
import 'package:djqs/base/util/util_jpush.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_notification.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_upgrade.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/module/home/entity/app_config_entity.dart';
import 'package:djqs/module/home/test_page.dart';
import 'package:djqs/module/home/util/app_config_util.dart';
import 'package:djqs/module/home/util/home_service.dart';
import 'package:djqs/module/home/util/home_util.dart';
import 'package:djqs/module/oderlist/entity/order_count_entity.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/orderlist_page.dart';
import 'package:djqs/module/oderlist/util/orderlist_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

class HomeVM extends BaseNotifier {
  final List<HomeTabData> tabData = [];
  final List<Widget> tabWidgetList = <Widget>[];
  late final HomeUtil homeUtil = HomeUtil();
  TabController? tabController;

  //
  late final _orderService = OrderListServiceDuo();
  OrderCountEntity? orderCountEntity;
  late final _homeService = HomeService();

  //
  int lastIndex = 0;
  bool isPopShow = false;

  final BaseCountDownUtil refreshCDUtil = BaseCountDownUtil();

  //
  int unreadCount = 0;

  HomeVM(super.baseContext, this.tabController);

  @override
  void init() {
    _initConfig();
    tabData?.add(HomeTabData('新任务', OrderListEntity.LIST_TYPE_NEW, 0));
    tabData?.add(HomeTabData('待取货', OrderListEntity.LIST_TYPE_TAKE, 1));
    tabData?.add(HomeTabData('待完成', OrderListEntity.LIST_TYPE_NOT_FIN, 2));
    tabData?.add(HomeTabData('已完成', OrderListEntity.LIST_TYPE_FINISHED, 3));
    tabData.forEach((item) {
      tabWidgetList.add(OrderListPage(homeTabData: item));
    });

    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      AccountUtil().hasLogined(isCanBack: false, callback: () => _initList());
    });

    initListener();
  }

  void initListener() {
    tabController!.addListener(() {
      if (!tabController!.indexIsChanging) {
        btn_onTabChange(tabController!.index);
      }
    });

    EventBus().on(EventCode.LOCATION_REFRESH, (_) async {
      if (!AccountUtil().isFinishInit && AccountUtil().isRest) {
        AccountUtil().isFinishInit = true;
        btn_onChageUserState(isNeedChangeShowPop: false);
      }
    });
    EventBus().on(EventCode.ACCOUNT_CHANGE, (_) async {
      tabController!.animateTo(0);
      btn_onTabRepeat(0);
      if (!AccountUtil().isFinishInit &&
          AccountUtil().isRest &&
          !ObjectUtil.isEmptyStr(BaseLocationUtil().getLocationData()?.lat)) {
        AccountUtil().isFinishInit = true;
        btn_onChageUserState(isNeedChangeShowPop: false);
      }
    });
    EventBus().on(EventCode.HOME_TAB_CHANGE, (listtype) {
      int index = tabData?.indexWhere(
              (tab) => tab.listType == OrderListEntity.LIST_TYPE_NEW) ??
          -1;
      tabController!.animateTo(index);
      btn_onTabRepeat(index);
    });
    EventBus()
        .on(EventCode.HOME_COUNT_REFRESH, (index) => _refreshOrderCount());

    // EventBus().on(EventCode.MSG_UNREAD_COUNT, (args) async {
    //   if (baseContext!.mounted) {
    //     unreadCount = args;
    //     await Future.delayed(Duration(milliseconds: 500));
    //     notifyListeners();
    //   }
    // });
  }

  void _initConfig() async {
    AppConfigEntity? entity = (await _homeService.getAppConfig())?[0];
    AppConfigUtil().setConfig(entity);
  }

  void _initList() {
    BaseUpgradeUtil().check();
    baseContext!.read<AppNotifier>().startLocation();
    BaseJPushUtil().checkNotificationEnabled(baseContext!);
    refreshCDUtil.init(AppConst.INTERVAL_REFRESH_LIST);
    tabController!.animateTo(lastIndex);
    btn_onTabRepeat(lastIndex);
    _startRefreshTime();
  }

  void onAppResume() {
    tabController!.animateTo(lastIndex);
    btn_onTabRepeat(lastIndex);
    resetRefreshTime();
    _startRefreshTime();
  }

  void resetRefreshTime() =>
      refreshCDUtil.reset = AppConst.INTERVAL_REFRESH_LIST;

  void _startRefreshTime() {
    refreshCDUtil.startTimer(
        callback: () {
          if (ModalRoute.of(baseContext!)?.isFirst == true &&
              baseContext!.mounted) btn_onRefresh(tabController?.index);
        },
        autoReset: true);
  }

  void _refreshOrderCount() async {
    if (!AccountUtil().isHasLogin) return;
    orderCountEntity = await _orderService.getOrderCount();
    // tabData.forEachIndexed((index, item) {});
    // bullshit
    tabData[0].dotStr = orderCountEntity?.type1;
    tabData[1].dotStr = orderCountEntity?.type2;
    tabData[2].dotStr = orderCountEntity?.type3;
    tabData[3].dotStr = orderCountEntity?.type4;
    notifyListeners();
  }

  @override
  void onResume() async {
    resetRefreshTime();
    _startRefreshTime();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    BaseJPushUtil().clearBadge();
  }

  @override
  void onPause() async {
    refreshCDUtil.dispose(isRecycle: false);
    EventBus().on(EventCode.MSG_CHAT_NEW, (args) {
      V2TimMessage msg = args;
      if (msg != null && msg.sender != AccountUtil().getAccount()?.im?.userId) {
        BaseNotificationUtil().showNotification(AppConst.NOTI_MSG, '聊天消息',
            title: msg.nickName,
            body: msg.textElem?.text ?? '',
            playSound: true);
      }
    });
  }

  void goto_changeShowPop(bool isShow) {
    this.isPopShow = isShow;
    notifyListeners();
  }

  void btn_onTabRepeat(int index) {
    if (index == tabController!.index) {
      EventBus().send(EventCode.ORDER_LIST_REFRESH, index);
    }
  }

  void btn_onTabChange(int index) => lastIndex = index;

  void btn_showSetting() => homeUtil.showListBS(baseContext!);

  void btn_onRefresh(int? index) =>
      EventBus().send(EventCode.ORDER_LIST_REFRESH, index ?? 0);

  void btn_onChageUserState({bool isNeedChangeShowPop = true}) async {
    if (isNeedChangeShowPop) goto_changeShowPop(false);
    FuncEntity? result = await _homeService
        .userStateChange(AccountUtil().getAccount()!.restOpsValue);
    if (result?.isSuccess() == true) {
      AccountUtil().getAccount()?.isrest =
          AccountUtil().getAccount()?.restOpsValue;
      await AccountUtil().setAccount(AccountUtil().getAccount());
      notifyListeners();
    } else
      toast(result?.msg ?? '变更失败');
  }

  @override
  void onCleared() {
    EventBus().off(EventCode.HOME_TAB_CHANGE);
    EventBus().off(EventCode.ACCOUNT_CHANGE);
    EventBus().off(EventCode.LOCATION_REFRESH);
    EventBus().off(EventCode.HOME_COUNT_REFRESH);
    refreshCDUtil.dispose(isRecycle: false);
  }
}

class HomeTabData {
  String? title;
  int? listType;
  String? dotStr;
  int index;

  HomeTabData(this.title, this.listType, this.index, {this.dotStr});

  int get dotValue => int.parse(ObjectUtil.strToZero(dotStr));
}
