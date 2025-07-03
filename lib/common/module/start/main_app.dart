import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/route/base_route_register.dart';
import 'package:djqs/base/route/base_route_oberver.dart';
import 'package:djqs/base/ui/base_theme_notifier.dart';
import 'package:djqs/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorStateKey;

  MainApp({Key? key, this.navigatorStateKey}) : super(key: key);
  final appRootRegister = BaseRouteRegister();

  @override
  Widget build(BuildContext context) {
    return Provider<BaseRouteRegister>(
        create: (context) => appRootRegister,
        builder: (context, child) {
          return ScreenUtilInit(
              designSize: const Size(375, 665),
              minTextAdapt: false,
              builder: (BuildContext context, Widget? child) => MultiProvider(
                  // 全局服务依赖
                  providers: appRootRegister.onGenerateProviders(),

                  child: Consumer<BaseThemeNotifier>(
                      builder: (context, provider, widget) {
                    return MaterialApp(
                        title: AppConst.APP_NAME,
                        builder: (BuildContext context, Widget? child) =>
                            EasyLoading.init()(context, child),
                        theme: provider.lightTD,
                        darkTheme: provider.lightTD,
                        //dark
                        themeMode: ThemeMode.light,
                        //system
                        navigatorObservers: [BaseRouteObserver.instance],
                        navigatorKey: navigatorStateKey,
                        locale: Locale('zh', 'CN'),
                        supportedLocales: [
                          // const Locale('en', 'US'),
                          const Locale('zh', 'CN'),
                        ],
                        localizationsDelegates: [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        // localizationsDelegates: [
                        //   CommonLocalizationsDelegate.getInstance(),
                        //   GlobalMaterialLocalizations.delegate,
                        //   GlobalWidgetsLocalizations.delegate,
                        // ],
                        // localeResolutionCallback:
                        //     (Locale? deviceLocale, supportedLocales) {
                        //   return CommonLocalizationsDelegate.getInstance()
                        //       .initLocalizations(
                        //           appRegister.routeManager
                        //               .getLocalizationFileNames(),
                        //           locale: deviceLocale);
                        // },
                        onGenerateRoute: (RouteSettings settings) =>
                            appRootRegister.onGenerateRoute(settings),
                        home: appRootRegister.startPage());
                  })));
        });
  }
}

class ChineseCupertinoLocalizations implements CupertinoLocalizations {
  static const materialDelegate = GlobalMaterialLocalizations.delegate;
  static const widgetsDelegate = GlobalWidgetsLocalizations.delegate;
  static const local = const Locale('zh');
  static const LocalizationsDelegate delegate = _ChineseDelegate();

  MaterialLocalizations? ml;

  Future init() async {
    ml = await materialDelegate.load(local);
    print(ml?.pasteButtonLabel);
  }

  @override
  String get alertDialogLabel => ml?.alertDialogLabel ?? '';

  @override
  String get anteMeridiemAbbreviation => ml?.anteMeridiemAbbreviation ?? '';

  @override
  String get copyButtonLabel => ml?.copyButtonLabel ?? '';

  @override
  String get cutButtonLabel => ml?.cutButtonLabel ?? '';

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.mdy;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String datePickerHour(int hour) => hour.toString().padLeft(2, '0');

  @override
  String datePickerHourSemanticsLabel(int hour) => '$hour' + '时';

  @override
  String datePickerMediumDate(DateTime date) =>
      ml?.formatMediumDate(date) ?? '';

  @override
  String datePickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String datePickerMinuteSemanticsLabel(int minute) => '$minute' + '分';

  @override
  String datePickerMonth(int monthIndex) => '$monthIndex';

  @override
  String datePickerYear(int yearIndex) => yearIndex.toString();

  @override
  String get pasteButtonLabel => ml?.pasteButtonLabel ?? '';

  @override
  String get postMeridiemAbbreviation => ml?.postMeridiemAbbreviation ?? '';

  @override
  String get selectAllButtonLabel => ml?.selectAllButtonLabel ?? '';

  @override
  String timerPickerHour(int hour) => hour.toString().padLeft(2, '0');

  @override
  String timerPickerHourLabel(int hour) =>
      '$hour'.toString().padLeft(2, '0') + '时';

  @override
  String timerPickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String timerPickerMinuteLabel(int minute) =>
      minute.toString().padLeft(2, '0') + '分';

  @override
  String timerPickerSecond(int second) => second.toString().padLeft(2, '0');

  @override
  String timerPickerSecondLabel(int second) =>
      second.toString().padLeft(2, '0') + '秒';

  static Future load(Locale locale) async {
    var localizaltions = ChineseCupertinoLocalizations();
    await localizaltions.init();
    return SynchronousFuture(localizaltions);
  }

  @override
  // TODO: implement modalBarrierDismissLabel
  String get modalBarrierDismissLabel => throw UnimplementedError();

  @override
  String tabSemanticsLabel({int? tabIndex, int? tabCount}) =>
      throw UnimplementedError();

  @override
  // TODO: implement todayLabel
  String get todayLabel => throw UnimplementedError();

  @override
  // TODO: implement searchTextFieldPlaceholderLabel
  String get searchTextFieldPlaceholderLabel => throw UnimplementedError();

  @override
  List<String> get timerPickerHourLabels => throw UnimplementedError();

  @override
  List<String> get timerPickerMinuteLabels => throw UnimplementedError();

  @override
  List<String> get timerPickerSecondLabels => throw UnimplementedError();

  @override
  String get noSpellCheckReplacementsLabel => throw UnimplementedError();

  @override
  String datePickerDayOfMonth(int dayIndex, [int? weekDay]) =>
      dayIndex.toString();

  @override
  String datePickerStandaloneMonth(int monthIndex) {
    throw UnimplementedError();
  }

  @override
  String get lookUpButtonLabel => throw UnimplementedError();

  @override
  String get menuDismissLabel => throw UnimplementedError();

  @override
  String get searchWebButtonLabel => throw UnimplementedError();

  @override
  String get shareButtonLabel => throw UnimplementedError();

  @override
  // TODO: implement clearButtonLabel
  String get clearButtonLabel => throw UnimplementedError();
}

class _ChineseDelegate extends LocalizationsDelegate {
  const _ChineseDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'zh';

  @override
  Future load(Locale locale) => ChineseCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}
