import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/const/base_const.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/test/test_pigeon_page.dart';
import 'package:djqs/base/test/test_webview_page.dart';
import 'package:djqs/base/ui/base_theme_notifier.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_debug.dart';
import 'package:djqs/base/util/util_file_cache.dart';
import 'package:djqs/base/util/util_jpush.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/base/util/util_upgrade.dart';
import 'package:djqs/common/module/login/reset_mobile_page.dart';
import 'package:djqs/common/module/login/util/account_service.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/setting/cancel_account_page.dart';
import 'package:djqs/common/util/common_util.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_controller/volume_controller.dart';

class SettingVM extends BaseNotifier {
  late final List<NormalListItem> listData = [];

  //
  late final tapRecognizer;
  int clickCount = 0;
  DateTime lastClickTime = DateTime.now();

  SettingVM(super.context);

  @override
  void init() {
    refreshData();
    tapRecognizer = TapGestureRecognizer()..onTap = () => btn_onDebug();
  }

  void refreshData() async {
    listData.clear();
    listData.add(_getListItem('接受推送通知',
        type: SettingType.push,
        rightType: ItemType.SWITCH,
        isChecked: CommonUtil().isPushAvailable));
    // listData.add(_getListItem('深色模式',
    //     type: SettingType.theme,
    //     rightType: ItemType.SWITCH,
    //     isChecked: BaseThemeNotifier.isDark(baseContext!)));
    listData.add(_getListItem('更换手机号',
        type: SettingType.restPW, rightType: ItemType.TEXT, suffixStr: '>'));

    listData.add(_getListItem('清除缓存',
        type: SettingType.cache,
        rightType: ItemType.TEXT,
        suffixStr: '${BaseFileCacheUtil().getCacheSize()}'));
    // listData.add(_getListItem('清除其他缓存',
    //     type: SettingType.otherCache,
    //     rightType: ItemType.TEXT,
    //     suffixStr: '${BaseFileCacheUtil().getWebViewCacheSize()}'));
    if (AccountUtil().isHasLogin)
      listData.add(_getListItem('退出登录', type: SettingType.logout));

    listData.add(_getListItem(
        '版本 ${BaseSystemUtil().versionName}${BaseDebugUtil().isDebug() ? '_测试' : ''}',
        type: SettingType.version,
        rightType: ItemType.TEXT,
        suffixStr: '检查更新>'));
    listData.add(_getListItem('用户协议', type: SettingType.agreement));
    listData.add(_getListItem('隐私协议', type: SettingType.privacy));
    if (AccountUtil().isHasLogin)
      listData.add(_getListItem('注销账户', type: SettingType.closeAccount));
    //
    // if (BaseDebugUtil().isDebug())
    //   listData.add(_getListItem('webview测试', type: SettingType.testWebview));
    // if (BaseDebugUtil().isDebug())
    //   listData.add(_getListItem('pigeon测试', type: SettingType.testPigeon));
    if (BaseDebugUtil().isDebug())
      listData.add(_getListItem('切换到release', type: SettingType.testDebug));

    notifyListeners();
  }

  NormalListItem _getListItem(String title,
          {ItemType rightType = ItemType.NONE,
          String? suffixStr,
          bool isChecked = false,
          required SettingType? type}) =>
      NormalListItem(
          primary: title,
          suffixStr: suffixStr,
          itemChecked: isChecked,
          rightType: rightType,
          primaryStyle: BaseUIUtil().getTheme().primaryTextTheme.titleSmall,
          type: type);

  void btn_onListItemClick(SettingType type, int index) async {
    switch (type) {
      case SettingType.push:
        bool value = !listData[index].itemChecked;
        listData[index].itemChecked = value;
        CommonUtil().pushAvailable = value;
        BaseJPushUtil().setJpushSwitch(value);
        notifyListeners();
        break;

      case SettingType.theme: //no use
        bool value = !listData[index].itemChecked;
        listData[index].itemChecked = value;
        BaseThemeNotifier.changeSettingDark(baseContext!, value);
        notifyListeners();
        break;
      case SettingType.agreement:
        pagePushH5(title: '用户协议', url: AppConst().H5_AGREEMENT);
        break;
      case SettingType.privacy:
        pagePushH5(title: '隐私协议', url: AppConst().H5_PRIVACY);
        break;
      case SettingType.version:
        BaseUpgradeUtil().check(newedShow: true);
        break;
      case SettingType.cache:
        await clearCache(SettingType.cache, index);
        break;
      case SettingType.otherCache:
        await clearCache(SettingType.otherCache, index);
        break;
      case SettingType.logout:
        FuncEntity entity = await AccountService().logout();
        if (entity.isSuccess()) await AccountUtil().logout();
        break;
      case SettingType.closeAccount:
        bool? isNeedRefresh = await pagePush(CancelAccountPage());
        if (isNeedRefresh == true) refreshData();
        break;
      case SettingType.testWebview:
        pagePush(TestWebviewPage());
        break;
      case SettingType.testPigeon:
        pagePush(TestPigeonPage());
        break;
      case SettingType.testDebug:
        switchDebug(false);
        break;
      case SettingType.restPW:
        pagePush(ResetMobilePage());
        break;
    }
  }

  void btn_onDebug() {
    DateTime now = DateTime.now();
    if (now.difference(lastClickTime).inMilliseconds < 500)
      clickCount++;
    else
      clickCount = 1;

    lastClickTime = now;
    if (clickCount >= 5) {
      switchDebug(!BaseDebugUtil().isDebug());
      clickCount = 0;
    }
  }

  void btn_onFile() => BaseSystemUtil().launchLink('https://beian.miit.gov.cn',
      mode: LaunchMode.externalApplication);

  void switchDebug(bool isDebug) async {
    BaseDebugUtil().setDebug(isDebug);
    toast('退出账号中..');
    await AccountUtil().logout();
    toast('已切换到${isDebug ? '测试' : '正式'}环境');
    BaseSystemUtil().exitApp();
  }

  Future<void> clearCache(SettingType type, int index) async {
    NormalListItem item = listData[index];
    if (item.suffixStr == BaseConst.CACHE_EMPTY) return;
    await BaseWidgetUtil.showLoading();
    if (type == SettingType.cache)
      await BaseFileCacheUtil().clearCache();
    else if (type == SettingType.otherCache)
      await BaseFileCacheUtil().clearWebviewCache();
    if (BaseSystemUtil().isAndroid)
      listData[index].suffixStr = BaseConst.CACHE_EMPTY;
    else
      listData[index].suffixStr = '';
    notifyListeners();
    await BaseWidgetUtil.cancelLoading();
  }

  @override
  void onCleared() {
    VolumeController.instance.removeListener();
  }
}

enum SettingType {
  push,
  agreement,
  privacy,
  theme,
  version,
  cache,
  otherCache,
  logout,
  closeAccount,
  testWebview,
  testPigeon,
  testDebug,
  restPW
}
