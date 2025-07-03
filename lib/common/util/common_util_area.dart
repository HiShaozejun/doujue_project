import 'dart:convert';

import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_sharepref.dart';
import 'package:djqs/base/widget/city_pickers/city_picker.dart';
import 'package:djqs/base/widget/city_pickers/model/result.dart';
import 'package:djqs/base/widget/city_pickers/utils/show_types.dart';
import 'package:djqs/common/entity/address_entity.dart';
import 'package:flutter/material.dart';

class CommonAreaUtil {
  static const String SP_AREA_PROVINCE = 'sp_area_province_data';
  static const String SP_AREA_CITY = 'sp_area_city_data';

  late final AreaService _service = AreaService();
  Map? _provinceData;
  Map? _cityData;
  String _lastCityId = '100000'; //初始化，表示空

  CommonAreaUtil._internal() {}

  factory CommonAreaUtil() => _instance;

  static late final CommonAreaUtil _instance = CommonAreaUtil._internal();

  _getAreaList() async {
    String? data = await BaseSPUtil().getString(SP_AREA_PROVINCE);
    if (ObjectUtil.isEmptyStr(data)) {
      var data = await _service.getAreaList();
      await _dealWithData(data);
    } else {
      _provinceData = json.decode(data);
      _cityData = json.decode(await BaseSPUtil().getString(SP_AREA_CITY));
    }
  }

  _dealWithData(data) async {
    var value = await Future(() {
      Map metaData = {};
      Map pData = {};
      Map cData = {};
      metaData['pdata'] = pData;
      metaData['cdata'] = cData;
      data.forEach((element) {
        //省
        String pId = element['adcode'];
        String pName = element['name'];
        pData['$pId'] = pName;

        Map<String, dynamic> pToC = {};
        cData['$pId'] = pToC;
        List? cidList = element['districts'];
        if (cidList != null) {
          cidList.forEach((element) {
            String cId = element['adcode'];
            String cName = element['name'];
            Map<String, String> city = {};
            pToC['$cId'] = city;
            city['name'] = cName;

            Map<String, dynamic> cToA = {};
            cData['$cId'] = cToA;
            List? areaList = element['districts'];
            if (areaList != null) {
              areaList.forEach((element) {
                String aId = element['adcode'];
                String aName = element['name'];
                Map<String, String> aToStr = {};
                aToStr['name'] = aName;
                cToA['$aId'] = aToStr;
              });
            }
          });
        }
      });
      return metaData;
    });

    _provinceData = value['pdata'];
    _cityData = value['cdata'];
    await saveData();
  }

  Future<Address?> buildCitySelector(BuildContext context,
      {ShowType? showType = ShowType.pca}) async {
    if (ObjectUtil.isEmptyMap(_provinceData)) {
      await _getAreaList();
    }
    CityPickerResult? result = await CityPickers.showCityPicker(
        context: context,
        citiesData: Map<String, dynamic>.from(_cityData ?? {}),
        provincesData: Map<String, String>.from(_provinceData ?? {}),
        locationCode: _lastCityId,
        showType: showType);
    if (result != null) {
      Address addressEntity = Address();
      addressEntity.provinceId = result.provinceId ?? '';
      addressEntity.cityId = result.cityId ?? '';
      addressEntity.townId = result.areaId ?? '';
      addressEntity.provinceName = result.provinceName ?? '';
      addressEntity.cityName = result.cityName ?? '';
      addressEntity.townName = result.areaName ?? '';
      _lastCityId = addressEntity.cityId ?? '10000';
      return addressEntity;
    }
    return null;
  }

  Future<void> saveData() async {
    await BaseSPUtil().putString(SP_AREA_PROVINCE, json.encode(_provinceData));
    await BaseSPUtil().putString(SP_AREA_CITY, json.encode(_cityData));
  }
}

class AreaService extends BaseService {
  Future<dynamic> getAreaList() async => requestSync(
      path: "${BaseNetConst().commonUrl}/district/all-list",
      create: (resource) => resource);
}
