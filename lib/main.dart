import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:djqs/base/frame/base_lifecycle_observer.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/util/util_debug.dart';
import 'package:djqs/base/util/util_sharepref.dart';
import 'package:djqs/common/module/start/main_app.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:djqs/common/util/common_util_auth_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  //google fonts liscense
  // LicenseRegistry.addLicense(() async* {
  //   final license = await rootBundle.loadString('google_fonts/OFL.txt');
  //   yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  // });

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  BaseLifecycleObserver();
  //splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  BaseUIUtil().setOrientationPortrait();
  BaseUIUtil().setStatusBar();

  await AppInitUtil();
  await BaseSPUtil().init();
  await CommonAuthHostUtil();
  runApp(DevicePreview(
      enabled: BaseDebugUtil.isUIDebug,
      builder: (context) =>
          MainApp(navigatorStateKey: AppInitUtil().navigatorKey)));
}
