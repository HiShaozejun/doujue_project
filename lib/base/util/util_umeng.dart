import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:djqs/base/entity/base_analysis_data.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class BaseUmengUtil {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final BaseAnalysisData _baseAnalysisData = BaseAnalysisData();

  BaseUmengUtil._internal() {}

  init(String androidAppKey, String iosAppkey) async {
    UmengCommonSdk.initCommon(androidAppKey, iosAppkey, 'Umeng');
    UmengCommonSdk.setPageCollectionModeManual();
    await _initBaseParam();
    onSend();
  }

  factory BaseUmengUtil() => _instance;

  static late final BaseUmengUtil _instance = BaseUmengUtil._internal();

  Future<void> _initBaseParam() async {
    _baseAnalysisData..platform = BaseSystemUtil().platform;
    try {
      if (Platform.isAndroid)
        _initDeviceInfoAndroid(await _deviceInfoPlugin.androidInfo);
      else if (Platform.isIOS)
        _initDeviceInfoIOS(await _deviceInfoPlugin.iosInfo);
    } catch (e) {}
  }

  void _initDeviceInfoAndroid(AndroidDeviceInfo info) => _baseAnalysisData
    ..deviceId = info.id
    ..version = info.version.release
    ..brand = info.brand;

  void _initDeviceInfoIOS(IosDeviceInfo info) => _baseAnalysisData
    ..deviceId = info.identifierForVendor
    ..version = info.systemVersion;

  void onPageStart(String pageName) => UmengCommonSdk.onPageStart(pageName);

  void onPageEnd(String pageName) => UmengCommonSdk.onPageEnd(pageName);

  void onEvent(event, {params}) {
    Map<String, dynamic?> allParams = _baseAnalysisData.toJson();
    if (params != null) allParams.addAll(params);
    UmengCommonSdk.onEvent(event!, allParams);
  }

  void onSend() async {
    UmengCommonSdk.onProfileSignIn(_baseAnalysisData.deviceId ?? '');
    await Future.delayed(const Duration(milliseconds: 500));
    UmengCommonSdk.onProfileSignOff();
  }
}
