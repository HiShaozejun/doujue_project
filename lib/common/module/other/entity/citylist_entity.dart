import 'package:djqs/base/widget/azlistview/az_common.dart';

/// hot_city : [{"adcode":"350400","name":"三明市","level":"city"}]
/// operation_city : [{"adcode":"110100","name":"北京城区","level":"city"}]

class CityListEntity {
  CityListEntity({
    List<CityEntity>? hotCity,
    List<CityEntity>? operationCity,
  }) {
    _hotCity = hotCity;
    _operationCity = operationCity;
  }

  CityListEntity.fromJson(dynamic json) {
    if (json['hot_city'] != null) {
      _hotCity = [];
      json['hot_city'].forEach((v) {
        _hotCity?.add(CityEntity.fromJson(v));
      });
    }
    if (json['operation_city'] != null) {
      _operationCity = [];
      json['operation_city'].forEach((v) {
        _operationCity?.add(CityEntity.fromJson(v));
      });
    }
  }

  List<CityEntity>? _hotCity;
  List<CityEntity>? _operationCity;

  CityListEntity copyWith({
    List<CityEntity>? hotCity,
    List<CityEntity>? operationCity,
  }) =>
      CityListEntity(
        hotCity: hotCity ?? _hotCity,
        operationCity: operationCity ?? _operationCity,
      );

  List<CityEntity>? get hotCity => _hotCity;

  List<CityEntity>? get operationCity => _operationCity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_hotCity != null) {
      map['hot_city'] = _hotCity?.map((v) => v.toJson()).toList();
    }
    if (_operationCity != null) {
      map['operation_city'] = _operationCity?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// adcode : "110100"
/// name : "北京城区"
/// level : "city"

class CityEntity extends ISuspensionBean {
  String? tag;
  String? shrink;
  String? namePinyin;

  CityEntity({
    String? adcode,
    String? name,
    String? level,
  }) {
    _adcode = adcode;
    _name = name;
    _level = level;
  }

  CityEntity.index(this._name, {this.tag});

  CityEntity.fromJson(dynamic json) {
    _adcode = json['adcode'];
    _name = json['name'];
    _level = json['level'];
  }

  String? _adcode;
  String? _name;
  String? _level;

  CityEntity copyWith({
    String? adcode,
    String? name,
    String? level,
  }) =>
      CityEntity(
        adcode: adcode ?? _adcode,
        name: name ?? _name,
        level: level ?? _level,
      );

  String? get adcode => _adcode;

  String? get name => _name;

  String? get level => _level;

  set name(String? name) => _name = name;

  set adcode(String? adcode) => _adcode = adcode;

  set level(String? level) => _level = level;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['adcode'] = _adcode;
    map['name'] = _name;
    map['level'] = _level;
    return map;
  }

  @override
  String getSuspensionTag() {
    return tag ?? '';
  }
}
