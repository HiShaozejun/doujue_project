import 'dart:convert';

import 'package:djqs/base/net/base_dio_util.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/webview/js_channel_entity.dart';
import 'package:djqs/base/webview/webview_bundledata.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/login/util/util_user.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';


//仿basentity抽基类
// {method:''  //用于app回传给h5数据
// callback:'' //用于h5召唤app
// data:       //数据，类型是单一string，bool,int，（对象直接转为jsonstr）
// }
// 将上面的json封成json字符串，然后用jschannel 发送出来

class JSChannelUtil {
  JSChannelUtil._internal();

  factory JSChannelUtil() => _instance;

  static late final JSChannelUtil _instance = JSChannelUtil._internal();

  void dealwithMsg(String msg,
      {BaseWVBundleData? wvBundleData,
        Function(String? name, dynamic data)? jsCallback}) async {
    JsChannelEntity entity = JsChannelEntity.fromJson(jsonDecode(msg));
    switch (entity.method) {
    ///H5获取数据
      case 'getTokenInfo':
        jsCallback?.call(entity.callback, AccountUtil().getAccount());
        break;
      case 'refreshToken':
        await BaseDioUtil().refreshTokenSync(needReqAgain: false);
        Future.delayed(Duration(microseconds: 500), () {
          jsCallback?.call(entity.callback, AccountUtil()
              .getAccount()
              ?.token);
        });
        break;
      case 'getLocation': //useless
        BaseLocationUtil().startLocation();
        Future.delayed(Duration(microseconds: 200), () {
          jsCallback?.call(
              entity.callback, BaseLocationUtil().getLocationData());
        });
        break;
      case 'getDark':
        bool isDark = BaseUIUtil().isThemeDark();
        jsCallback?.call(entity.callback, isDark);
        break;

    ///触发事件
      case 'onBack':
        BaseRouteUtil.pop(AppInitUtil().curContext!);
        break;
      case 'onShowToast':
        String? str = entity.data['content'];
        if (!ObjectUtil.isEmptyStr(str)) BaseWidgetUtil.showToast(str!);
        break;
      case 'onShowDialog':
        String title = entity.data['title'];
        String content = entity.data['content'];
        BaseDialogUtil.showCommonDialog(null,
            title: title, leftBtnStr: null, content: content);
        break;

    }
  }
}