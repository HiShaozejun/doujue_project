import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/webview/base_webview.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:flutter/material.dart';

class BaseRouteUtil {
  String? getCurPageName(BuildContext context) {
    ModalRoute? currentRoute = ModalRoute.of(context);
    return currentRoute?.settings.name;
  }

  static Future<dynamic?> push(BuildContext? context, page) => Navigator.push(
      context ?? AppInitUtil().curContext!,
      MaterialPageRoute(builder: (context) => page));

  static Future<dynamic?> pushNamed(BuildContext context, String routeName) =>
      Navigator.pushNamed(context, routeName);

  static Future<dynamic?> pushH5(BuildContext context,
          {required String? url,
          String? title,
          bool showHeader = true,
          bool showLeft = true,
          bool fromHome = false,
          bool showDivider = true,
          Color? appbarColor}) =>
      push(
          context,
          BaseWebViewPage(
              url: url,
              title: title,
              showHeader: showHeader,
              showLeft: showLeft,
              fromHome: fromHome,
              showDivider: showDivider));

  //逻辑等同于popAndPushNamed,适用于pop之后还要跳转的情况，pop后的vm context被清空
  static Future<dynamic?> pushReplacement(BuildContext context, page) =>
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => page));

  static void pop(BuildContext context, {params}) {
    BaseUIUtil().hideKeyboardWithUnfocus();
    Navigator.pop(context, params);
  }

  static Future<dynamic?> pushAndRemoveUntil(BuildContext context, page,
      {String? endRouterName}) {
    BaseUIUtil().hideKeyboardWithUnfocus();
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (router) {
        if (endRouterName == null)
          return true;
        else {
          return router.settings.name == endRouterName;
        }
      },
    );
  }

  static void popUntil(BuildContext context, String endRouterName) {
    BaseUIUtil().hideKeyboardWithUnfocus();
    Navigator.popUntil(
        context, ModalRoute.withName(endRouterName)); //RoutePredicate
  }
}
