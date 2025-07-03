class Address {
  Address({
    String? provinceId,
    String? provinceName,
    String? cityId,
    String? cityName,
    String? townId,
    String? townName,
    String? street,
    String? lat,
    String? lng,
  }) {
    _provinceId = provinceId;
    _provinceName = provinceName;
    _cityId = cityId;
    _cityName = cityName;
    _townId = townId;
    _townName = townName;
    _street = street;
    _lat = lat;
    _lng = lng;
  }

  Address.fromJson(dynamic json) {
    _provinceId = json['province_id'];
    _provinceName = json['province_name'];
    _cityId = json['city_id'];
    _cityName = json['city_name'];
    _townId = json['town_id'];
    _townName = json['town_name'];
    _street = json['street'];
    _lat = json['lat'];
    _lng = json['lng'];
  }

  String? _provinceId;
  String? _provinceName;
  String? _cityId;
  String? _cityName;
  String? _townId;
  String? _townName;
  String? _street;
  String? _lat;
  String? _lng;

  Address copyWith({
    String? provinceId,
    String? provinceName,
    String? cityId,
    String? cityName,
    String? townId,
    String? townName,
    String? street,
    String? lat,
    String? lng,
  }) =>
      Address(
        provinceId: provinceId ?? _provinceId,
        provinceName: provinceName ?? _provinceName,
        cityId: cityId ?? _cityId,
        cityName: cityName ?? _cityName,
        townId: townId ?? _townId,
        townName: townName ?? _townName,
        street: street ?? _street,
        lat: lat ?? _lat,
        lng: lng ?? _lng,
      );

  String? get provinceId => _provinceId;

  String? get provinceName => _provinceName;

  String? get cityId => _cityId;

  String? get cityName => _cityName;

  String? get townId => _townId;

  String? get townName => _townName;

  String? get street => _street;

  String? get lat => _lat;

  String? get lng => _lng;

  set provinceId(String? provinceId) => _provinceId = provinceId;

  set provinceName(String? provinceName) => _provinceName = provinceName;

  set cityId(String? cityId) => _cityId = cityId;

  set cityName(String? cityName) => _cityName = cityName;

  set townId(String? townId) => _townId = townId;

  set townName(String? townName) => _townName = townName;

  set street(String? street) => _street = street;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['province_id'] = _provinceId;
    map['province_name'] = _provinceName;
    map['city_id'] = _cityId;
    map['city_name'] = _cityName;
    map['town_id'] = _townId;
    map['town_name'] = _townName;
    map['street'] = _street;
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}
