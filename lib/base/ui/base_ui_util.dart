import 'dart:async';

import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_theme.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseUIUtil {
  BaseUIUtil._internal();

  factory BaseUIUtil() => _instance;

  static late final BaseUIUtil _instance = BaseUIUtil._internal();

  //强制竖屏
  void setOrientationPortrait() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  void setOrientationLandscape() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  Color hexToColor(String hexString) =>
      Color(int.parse(hexString, radix: 16)).withAlpha(255);

  void setFullScreen() =>
      WidgetsBinding.instance.addPostFrameCallback((_bottomBarLayout) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: BaseColors.trans,
          statusBarIconBrightness: Brightness.light,
        ));
      });

  // 设置状态栏背景
  void setStatusBar(
      {Color? bgColor = BaseColors.ffffff, bool? bgDark = false}) {
    // if (Platform.isAndroid) {
    //   SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    //       statusBarColor: bgColor ?? BaseColors.ffffff,
    //       statusBarIconBrightness: (bgDark ?? false)
    //           ? Brightness.light
    //           : Brightness.dark); // color.withOpacity(0.8)
    //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    //   //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: []);//全屏
    // }
  }

  // 根据当前主题色设置状态栏导航栏沉浸式
  void setStatusBarWithTheme(Brightness mode) {
    // if (Platform.isAndroid) {
    //   if (mode == Brightness.dark) {
    //     SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    //         statusBarColor: BaseColors.trans,
    //         statusBarIconBrightness: Brightness.light,
    //         systemNavigationBarColor: BaseColors.c161616,
    //         systemNavigationBarIconBrightness: Brightness.light);
    //     SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    //   } else {
    //     SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    //         statusBarColor: BaseColors.trans,
    //         statusBarIconBrightness: Brightness.dark,
    //         systemNavigationBarColor: BaseColors.ffffff,
    //         systemNavigationBarIconBrightness: Brightness.dark);
    //     SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    //   }
    // }
  }

  void updateStatusBarIcon(Brightness mode) {
    if (mode == Brightness.dark) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else {
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  double getStatusHeight() {
    return MediaQuery.of(AppInitUtil().curContext!).padding.top;
  }

  double getKeyboardHeight() {
    return MediaQuery.of(AppInitUtil().curContext!).viewInsets.bottom;
  }

  // 关闭键盘并失去焦点
  void hideKeyboardWithUnfocus() =>
      // 使用下面的方式，会触发不必要的build。
      // FocusScope.of(context).unfocus();
      // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
      FocusManager.instance.primaryFocus?.unfocus();

  // 关闭键盘but保留焦点
  void hideKeybpardWithFocus() async =>
      await SystemChannels.textInput.invokeMethod('TextInput.hide');

  Future<void> initFinish() async {
    Completer<void> completer = Completer();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completer.complete();
    });

    return completer.future;
  }

  bool isCurrent(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? false;

  bool isThemeDark({BuildContext? context}) {
    // if (context == null && AppInitUtil().curContext == null) return false;
    //
    // return MediaQuery.of(context ?? AppInitUtil().curContext!)
    //         .platformBrightness !=
    //     Brightness.light;
    return false;
  }

  Color getThemeColor(Color lightColor,
          {BuildContext? context, Color darkColor = BaseColors.ffffff}) =>
      lightColor;
      // isThemeDark(context: context ?? AppInitUtil().curContext)
      //     ? darkColor
      //     : lightColor;

  ThemeData getTheme({BuildContext? context}) {
    // var theme = isThemeDark(context: context ?? AppInitUtil().curContext)
    //     ? BaseThemes.darkTD
    //     : BaseThemes.lightTD;
    // return theme;

    return BaseThemes.lightTD;
    ///该方法有延时
    return Theme.of(AppInitUtil().curContext!);
  }
}
