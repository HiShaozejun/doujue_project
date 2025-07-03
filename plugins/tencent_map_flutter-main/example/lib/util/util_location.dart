import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:tencent_map_flutter/flutter_tencent_lbs_plugin.dart';
import 'package:tencent_map_flutter/model/android_notification_options.dart';
import 'package:tencent_map_flutter/model/location.dart';
import 'package:tencent_map_flutter_example/util/base_location_entity.dart';

class BaseLocationUtil {
  static const String TM_IOS_KEY = "3AMBZ-U5U6J-ZLDFX-XHX4V-5G45V-EEBFS";

  static const String SP_LOCATION = "sp_location";

  BaseLocationData? _locationData;

  factory BaseLocationUtil() => _instance;

  static late final BaseLocationUtil _instance = BaseLocationUtil._internal();
  final locationPlugin = FlutterTencentLBSPlugin();

  BaseLocationUtil._internal();

  bool _hasLocationUpdated = false;

  void init(String key) {
    locationPlugin.setUserAgreePrivacy();
    locationPlugin.init(key: TM_IOS_KEY);
    _initLocation();
  }

  void _initLocation() {
    locationPlugin.addLocationListener((Location location) {
      if (_locationData == null) _locationData = BaseLocationData();
      _locationData?.lat = location.latitude.toString();
      _locationData?.lng = location.longitude.toString();
    });
  }

  BaseLocationData? getLocationData() {
    if (_locationData != null) return _locationData;
    return _locationData;
  }

  void startLocation({int timeLimit = 3000}) async {
    _hasLocationUpdated = false;

    locationPlugin.getLocation(
      interval: timeLimit,
      backgroundLocation: true,
      androidNotificationOptions: AndroidNotificationOptions(
        id: 1001,
        channelId: "100",
        channelName: "定位常驻通知",
        notificationTitle: "定位常驻通知标题文字",
        notificationText: "定位常驻通知内容文字",
      ),
    );

    //定位无回调
    Future.delayed(Duration(milliseconds: timeLimit), () async {
      if (_hasLocationUpdated == false) {
        _hasLocationUpdated = true;
      }
    });
  }

  void stopLocation() => locationPlugin?.stop();
}
