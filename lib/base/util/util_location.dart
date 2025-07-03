import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/entity/base_location_entity.dart';
import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_permission.dart';
import 'package:djqs/base/util/util_sharepref.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:tencent_map_flutter/flutter_tencent_lbs_plugin.dart';
import 'package:tencent_map_flutter/model/location.dart' as TM;
import 'package:tencent_map_flutter/tencent_map_flutter.dart';
import 'package:tencent_map_flutter/util/map_util.dart';

class BaseLocationUtil {
  static const String SP_LOCATION = "sp_location";
  BaseLocationData? _locationData;

  //
  // final AMapFlutterLocation? _aLocPlugin = AMapFlutterLocation();
  // AMapLocationOption? _aLocOption;
  final TencentMapUtil _tmUtil = TencentMapUtil();
  final FlutterTencentLBSPlugin _tmLocPlugin = FlutterTencentLBSPlugin();

  factory BaseLocationUtil() => _instance;

  static late final BaseLocationUtil _instance = BaseLocationUtil._internal();

  BaseLocationUtil._internal();

  bool _hasLocationUpdated = false;

  void init(String androidAppKey, String iosAppkey) {
    if (BaseSystemUtil().isAndroid) {
      TencentMap.init(agreePrivacy: true);
      _tmUtil.setKey(AppConst.TM_MAP_KEY, AppConst.TM_MAP_SECRET);
      _tmLocPlugin.setUserAgreePrivacy();
      _tmLocPlugin.init(key: AppConst.TM_MAP_KEY);
      _initLocation();
    } else {
      TencentMap.init(agreePrivacy: true);
      _tmUtil.setKey(AppConst.TM_MAP_KEY, AppConst.TM_MAP_SECRET);
      _tmLocPlugin.setUserAgreePrivacy();
      _tmLocPlugin.init(key: AppConst.TM_MAP_KEY);
      _initLocation();


      // AMapFlutterLocation.updatePrivacyShow(true, true);
      // AMapFlutterLocation.updatePrivacyAgree(true);
      // AMapFlutterLocation.setApiKey(androidAppKey, iosAppkey);
      // AMapFlutterLocation().startLocation();
      // _initLocationForIos();
    }
  }

  void _initLocation() {
    _tmLocPlugin.addLocationListener((TM.Location location) {
      if (_locationData == null) _locationData = BaseLocationData();
      if (!ObjectUtil.isEmptyDouble(location.latitude)) {
        _locationData?.lat = location.latitude.toString();
        _locationData?.lng = location.longitude.toString();
        _locationData?.province = location.province;
        _locationData?.city = location.city;
        _locationData?.cityCode = location.cityCode;
        _locationData?.district = location.area;
        _locationData?.address = location.address;
        _locationData?.name = location.name;

        _refreshLocation(_locationData);
      }
    });
  }

  // // void _initLocationForIos() {
  // //   _initLocationOption();
  // //   //iOS 获取native精度类型
  // //   if (Platform.isIOS) {
  // //     _requestAccuracyAuthorization();
  // //   }
  // //   _aLocPlugin?.onLocationChanged().listen((Map<String, Object>? result) {
  // //     if (_locationData == null) _locationData = BaseLocationData();
  // //     String? errorCode = result?['errorCode']?.toString();
  // //     if (errorCode == null &&
  // //         !ObjectUtil.isEmptyAny(result?['latitude']?.toString())) {
  // //       _locationData?.province = result?['province']?.toString() ?? '';
  // //       _locationData?.city = result?['city']?.toString() ?? '';
  // //       _locationData?.district = result?['district']?.toString() ?? '';
  // //       _locationData?.adCode = result?['adCode']?.toString() ?? '';
  // //       _locationData?.provinceCode = _getProviceCode(_locationData!.adCode);
  // //       _locationData?.cityCode = _getCityCode(_locationData?.adCode);
  // //       _locationData?.lat = (result?['latitude']?.toString()) ?? '';
  // //       _locationData?.lng = (result?['longitude']?.toString()) ?? '';
  // //       _locationData?.address = result?['address']?.toString() ?? '';
  // //     } else {
  // //       if (errorCode == '12')
  // //         BaseWidgetUtil.showToast('您的手机位置未打开，请去设置中打开位置开关');
  // //     }
  // //     _refreshLocation(_locationData);
  // //   });
  // }

  // void _initLocationOption() {
  //   _aLocOption = new AMapLocationOption();
  //   _aLocOption?.onceLocation = false;
  //   _aLocOption?.needAddress = true;
  //   _aLocOption?.geoLanguage = GeoLanguage.DEFAULT;
  //
  //   _aLocOption?.desiredLocationAccuracyAuthorizationMode =
  //       AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;
  //
  //   _aLocOption?.fullAccuracyPurposeKey = "AMapLocationScene";
  //   _aLocOption?.locationInterval = 10000;
  //   _aLocOption?.locationMode = AMapLocationMode.Hight_Accuracy;
  //   _aLocOption?.distanceFilter = -1;
  //   _aLocOption?.desiredAccuracy = DesiredAccuracy.Best;
  //   _aLocOption?.pausesLocationUpdatesAutomatically = false;
  // }

  Future<void> clear() async {
    _locationData = null;
    await BaseSPUtil().putEntity(SP_LOCATION, null);
  }

  BaseLocationData? getLocationData() {
    if (_locationData != null) return _locationData;

    dynamic resource = BaseSPUtil().getEntity(SP_LOCATION);
    if (resource != null) _locationData = BaseLocationData.fromJson(resource);
    return _locationData;
  }

  void _refreshLocation(location) {
    _hasLocationUpdated = true;
    BaseSPUtil().putEntity(SP_LOCATION, location);
    EventBus().send(EventCode.LOCATION_REFRESH);
  }

  //获取iOS native的accuracyAuthorization类型
  // void _requestAccuracyAuthorization() async {
  //   AMapAccuracyAuthorization currentAccuracyAuthorization =
  //       await _aLocPlugin!.getSystemAccuracyAuthorization();
  //   if (currentAccuracyAuthorization ==
  //       AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
  //     print("精确定位类型");
  //   } else if (currentAccuracyAuthorization ==
  //       AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
  //     print("模糊定位类型");
  //   } else {
  //     print("未知定位类型");
  //   }
  // }

  void startLocation({int timeLimit = 10000}) async {
    _hasLocationUpdated = false;
    BasePermissionUtil().requestLocatePermission(() {
      try {
        // if (BaseSystemUtil().isAndroid) {
          _tmLocPlugin.getLocation(
            interval: timeLimit,
            backgroundLocation: true,
            androidNotificationOptions: AndroidNotificationOptions(
              id: 1001,
              channelId: AppConst.NOTI_LOCATION,
              channelName: "后台定位通知",
              notificationTitle: AppConst.APP_NAME,
              notificationText: "正在后台运行",
            ),
          );
        // } else {
        //   _aLocPlugin?.setLocationOption(_aLocOption!);
        //   _aLocPlugin?.startLocation();
        // }
      } catch (e) {
        e.toString();
      }
    });

    //定位无回调
    Future.delayed(Duration(milliseconds: timeLimit), () async {
      if (_hasLocationUpdated == false) {
        _hasLocationUpdated = true;
        //EventBus().send(EventCode.LOCATION_REFRESH);
      }
    });
  }

  // void stopLocation() => BaseSystemUtil().isAndroid
  //     ? _tmLocPlugin.stop()
  //     : _aLocPlugin?.stopLocation();
  void stopLocation() => _tmLocPlugin.stop();

  String _getCityCode(String? code) =>
      code?.length == 6 ? '${code?.substring(0, 4)}00' : '';

  String _getProviceCode(String? code) =>
      code?.length == 6 ? '${code?.substring(0, 2)}0000' : '';

  double getDistance(String? lat1, String? lon1, String? lat2, String? lon2) {
    if (ObjectUtil.isEmptyStr(lat1) || ObjectUtil.isEmptyStr(lat2)) return 0;
    return getCalculateDistance(double.parse(lat1!), double.parse(lon1!),
        double.parse(lat2!), double.parse(lon2!));
  }

  double getCalculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000.0; // 地球半径（单位：米）

    double rad(double degree) => degree * pi / 180.0;

    double dLat = rad(lat2 - lat1);
    double dLon = rad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(rad(lat1)) * cos(rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  String getDistanceUnit(distance) {
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(2)}km';
    } else {
      return '${distance.toStringAsFixed(0)}m';
    }
  }

  //
  void showMapSheet(double latitude, double longitude,
      {String? address}) async {
    final List<AvailableMap> maps = await MapLauncher.installedMaps;
    if (maps == null || maps.length == 0) {
      BaseWidgetUtil.showToast('您的手机上没有安装地图软件');
      return;
    }
    if (maps.length == 1) {
      launchMap(maps[0], latitude, longitude, adress: address);
      return;
    }
    List<NormalListItem>? _sheetData = [];
    for (AvailableMap item in maps)
      _sheetData.add(NormalListItem(
        prefixChild: SvgPicture.asset(
          item.icon,
          height: 30.0,
          width: 30.0,
        ),
        primary: getMapName(item.mapName),
      ));
    BaseDialogUtil.showListBS(AppInitUtil().curContext!,
        title: '地图列表', titleCenter: false, topData: _sheetData, onTopItemClick:
            (BuildContext sheetBC, BuildContext context, int index) {
      Navigator.pop(sheetBC);
      launchMap(maps[index], latitude, longitude, adress: address);
    });
  }

  void launchMap(AvailableMap map, double latitude, double longitude,
          {String? adress}) async =>
      await map.showMarker(
          coords: Coords(latitude, longitude), title: adress ?? '目的地');

  String getMapName(String str) {
    if (str.toLowerCase().contains('amap')) return '高德地图';
    if (str.toLowerCase().contains('baidu')) return '百度地图';
    if (str.toLowerCase().contains('tencent')) return '腾讯地图';
    if (str.toLowerCase().contains('apple')) return '苹果地图';
    if (str.toLowerCase().contains('google')) return '谷歌地图';

    return '其他地图';
  }
}
