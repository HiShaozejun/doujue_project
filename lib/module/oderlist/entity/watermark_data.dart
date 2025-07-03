import 'package:djqs/base/entity/base_location_entity.dart';
import 'package:djqs/base/util/util_date.dart';

class WatermarkData {
  String? imgPath;
  String? markPath;
  BaseLocationData? locationData;
  String? date = BaseDateUtil.getDateStrByDateTime(DateTime.now());
}
