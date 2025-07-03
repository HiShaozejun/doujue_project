import 'dart:convert';

import 'package:djqs/base/const/base_const.dart';
import 'package:djqs/base/util/util_num.dart';
import 'package:djqs/base/util/util_object.dart';

class AppUtil {
  static const DTO_ACTION_YES = '1'; //接口数据正向为1，负向为0
  static const DTO_ACTION_NO = '0';

  AppUtil._internal();

  factory AppUtil() => _instance;

  static late final AppUtil _instance = AppUtil._internal();

  static bool getActionBool(String? value) =>
      value == DTO_ACTION_YES.toString() ? true : false;

  static String getActionInt(bool value) =>
      value ? DTO_ACTION_YES : DTO_ACTION_NO;

  String parseAvatar(String? value,
      {String defaultImgUrl = BaseConst.IMG_DEFAULT_AVATAR}) {
    if (ObjectUtil.isEmptyAny(value)) return defaultImgUrl;

    try {
      List photos = jsonDecode(value!);
      Map<String, dynamic> photo = photos[0];
      return photo['img'];
    } catch (e) {
      return value!;
    }
  }

  String parseLocation(String? value) {
    if (ObjectUtil.isEmptyAny(value)) return '';

    Map<String, dynamic> data = jsonDecode(value!);
    return data['wishCityName'] ?? '';
  }

  String formatYuan(String? str) => str ?? '0.00';

  List<String> getDistance(int? distance) {
    List<String>? value = [];
    if ((distance ?? 0) <= 1000) {
      value.add(distance.toString());
      value.add('m');
    } else {
      value.add(BaseNumUtil.formatNum(distance! / 1000));
      value.add('km');
    }
    return value;
  }
}
