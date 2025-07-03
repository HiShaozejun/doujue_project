import 'package:djqs/base/res/base_theme.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/util/util_sharepref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseThemeNotifier with ChangeNotifier {
  static const int THEME_TYPE_LIGHT = 0;
  static const int THEME_TYPE_DARK = 1;
  static const int THEME_TYPE_SYSTEM = 2;
  static const String SP_THEME = "sp_theme";

  late BuildContext context;
  late ThemeData lightTD;
  late ThemeData darkTD;
  bool _isDarkSystem = false;
  bool _isDarkSetting = false;

  BaseThemeNotifier({required this.context}) {
    lightTD = BaseThemes.lightTD;
    darkTD = BaseThemes.lightTD;
    // _isDarkSetting = BaseSPUtil().getBool(SP_THEME);
    // _refreshSettingTheme(isDarkSetting: _isDarkSetting, init: true);
  }

  void _refreshSystemTheme(bool isDarkSystem, {bool init = false}) async {
    if (!init && (isDarkSystem == _isDarkSystem)) return;
    _isDarkSystem = isDarkSystem;
    BaseUIUtil().setStatusBarWithTheme(
        _isDarkSystem ? Brightness.dark : Brightness.light);
    lightTD = BaseThemes.lightTD;
    darkTD = BaseThemes.lightTD; //BaseThemes.darkTD

    notifyListeners();
  }

  // static bool isSystemDark({BuildContext? context}) =>
  //     Provider.of<BaseThemeNotifier>(context ?? AppInitUtil().curContext!,
  //             listen: false)
  //         ._isDarkSystem;

  static void changeSystemDark(BuildContext context) async {
    bool isDark = BaseUIUtil().isThemeDark();
    context.read<BaseThemeNotifier>()._refreshSystemTheme(isDark);
  }

  //not use
  void _refreshSettingTheme(bool isDarkSetting, {bool init = false}) async {
    if (!init && (isDarkSetting == _isDarkSetting)) return;

    if (!init) {
      await BaseSPUtil().putBool(SP_THEME, isDarkSetting);
      _isDarkSetting = isDarkSetting;
    }
    BaseUIUtil().setStatusBarWithTheme(
        _isDarkSetting ? Brightness.dark : Brightness.light);
    if (_isDarkSetting) {
      lightTD = BaseThemes.darkTD;
      darkTD = BaseThemes.lightTD;
    } else {
      lightTD = BaseThemes.lightTD;
      darkTD = BaseThemes.lightTD;
    }

    notifyListeners();
  }

  // static bool isSettingDark({BuildContext? context}) =>
  //     Provider.of<BaseThemeNotifier>(context ?? AppInitUtil().curContext!,
  //             listen: false)
  //         ._isDarkSetting;

  static void changeSettingDark(BuildContext context, bool isDark) =>
      context.read<BaseThemeNotifier>()._refreshSettingTheme(isDark);
}
