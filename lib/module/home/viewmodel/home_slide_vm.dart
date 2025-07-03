import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/login/entity/userinfo_entity.dart';
import 'package:djqs/common/module/setting/setting_page.dart';
import 'package:djqs/module/message/chatlist_page.dart';
import 'package:djqs/module/mine/util/mine_service.dart';
import 'package:djqs/module/purse/purse_page.dart';
import 'package:djqs/module/stat/stat_order_page.dart';
import 'package:flutter/material.dart';

class HomeSlideVM extends BaseNotifier {
  late UserinfoEntity? userInfoEntity;

  late final List<NormalListItem> gridTopData = [];
  late final List<NormalListItem> listData = [];

  var lastLeftIndex = 0;
  late final MineService _service = MineService();

  HomeSlideVM(super.baseContext);

  @override
  void init() {
    gridTopData.add(NormalListItem(
        primary: '今日完成单',
        minor: '0',
        prefixIconData: Icons.chevron_right_outlined));
    gridTopData.add(NormalListItem(
        primary: '今日配送费',
        minor: '0.00',
        prefixIconData: Icons.chevron_right_outlined));
    gridTopData.add(NormalListItem(primary: '本月差评', minor: '0'));

    //
    listData.add(_getListItem('我的消息', Icons.chat_outlined, MineType.msg));
    listData.add(_getListItem('订单统计', Icons.list, MineType.order));
    listData.add(_getListItem('我的收入', Icons.wallet, MineType.purse));
    listData.add(_getListItem('设置', Icons.settings, MineType.setting));
  }

  @override
  void onResume() async {
    userInfoEntity = (await _service.getUserInfo())?[0];

    gridTopData[0].minor = userInfoEntity?.orders;
    gridTopData[1].minor = userInfoEntity?.income;

    // accountEntity?.userNickname=userInfoEntity?.info?[0]?.userNickname;
    // accountEntity?.avatar=userInfoEntity?.info?[0]?.avatar;
    // accountEntity?.mobile=userInfoEntity?.info?[0]?.mobile;
    // AccountUtil().setAccount(accountEntity);

    notifyListeners();
  }

  NormalListItem _getListItem(String title, IconData icon, MineType type) =>
      NormalListItem(
          type: type,
          primary: title,
          prefixIconData: icon,
          primaryStyle: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
          rightType: ItemType.IMG);

  void btn_onBottomListItemClick(NormalListItem item) {
    switch (item.type) {
      case MineType.msg:
        pagePush(ChatListPage());
        break;
      case MineType.order:
        pagePush(OrderStatPage());
      case MineType.purse:
        pagePush(PursePage());
        break;
      case MineType.setting:
        pagePush(SettingPage());
        break;
    }
  }

  void btn_onTopGridItemClick(int index) {
    if (index == 0)
      pagePush(OrderStatPage());
    else if (index == 1) pagePush(PursePage());
  }

  @override
  void onCleared() {}
}

enum MineType { msg, order, purse, setting }
