import 'dart:io';

import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseSystemUtil {
  PackageInfo? _packageInfo;

  BaseSystemUtil._internal() {
    _init();
  }

  factory BaseSystemUtil() => _instance;

  static late final BaseSystemUtil _instance = BaseSystemUtil._internal();

  void _init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get platform => Platform.isAndroid ? 'android' : 'ios';

  int get platformCode => Platform.isAndroid ? 1 : 2;


  bool get isAndroid => (defaultTargetPlatform == TargetPlatform.android);

  bool get isIOS => (defaultTargetPlatform == TargetPlatform.iOS);

  int get versionCode => int.parse(_packageInfo!.buildNumber);

  String? get versionName => _packageInfo?.version;

  //todo
  void getPhoneNumber(Function(String? mobile) callback) {}

  void launchPhone(String number) async {
    Uri callUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (!await launchUrl(callUri)) {
      throw Exception('Could not launch $callUri');
    }
  }

  void launchLink(String url,
      {LaunchMode mode = LaunchMode.platformDefault, String? toast}) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: mode)) {
      if (!ObjectUtil.isEmptyStr(toast)) BaseWidgetUtil.showToast(toast!);
      throw Exception('Could not launch $uri');
    }
  }

  void exitApp() async {
    if (Platform.isAndroid) {
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      try {
        exit(0);
      } catch (e) {}
    }
  }
}
