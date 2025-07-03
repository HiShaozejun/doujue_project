class BaseLocationData {
  BaseLocationData({
    String? province,
    String? city,
    String? district,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? adCode,
    String? address,
    String? name,
    String? lat,
    String? lng,
  }) {
    _province = province;
    _city = city;
    _district = district;
    _provinceCode = provinceCode;
    _cityCode = cityCode;
    _districtCode = districtCode;
    _adCode = adCode;
    _address = address;
    _name = name;
    _lat = lat;
    _lng = lng;
  }

  BaseLocationData.fromJson(dynamic json) {
    _province = json['province'];
    _city = json['city'];
    _district = json['district'];
    _provinceCode = json['provinceCode'];
    _cityCode = json['cityCode'];
    _districtCode = json['districtCode'];
    _adCode = json['adCode'];
    _address = json['address'];
    _name = json['name'];
    _lat = json['lat'];
    _lng = json['lng'];
  }

  String? _province;
  String? _city;
  String? _district;
  String? _provinceCode;
  String? _cityCode;
  String? _districtCode;
  String? _adCode;
  String? _address;
  String? _name;
  String? _lat;
  String? _lng;

  BaseLocationData copyWith({
    String? province,
    String? city,
    String? district,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? adCode,
    String? address,
    String? name,
    String? lat,
    String? lng,
  }) =>
      BaseLocationData(
        province: province ?? _province,
        city: city ?? _city,
        district: district ?? _district,
        provinceCode: provinceCode ?? _provinceCode,
        cityCode: cityCode ?? _cityCode,
        districtCode: districtCode ?? _districtCode,
        adCode: adCode ?? _adCode,
        address: address ?? _address,
        name: name ?? _name,
        lat: lat ?? _lat,
        lng: lng ?? _lng,
      );

  String? get province => _province;

  String? get city => _city;

  String? get district => _district;

  String? get provinceCode => _provinceCode;

  String? get cityCode => _cityCode;

  String? get districtCode => _districtCode;

  String? get adCode => _adCode;

  String? get address => _address;

  String? get name => _name;

  String? get lat => _lat;

  String? get lng => _lng;

  set province(String? province) => _province = province;

  set city(String? city) => _city = city;

  set district(String? district) => _district = district;

  set provinceCode(String? provinceCode) => _provinceCode = provinceCode;

  set cityCode(String? cityCode) => _cityCode = cityCode;

  set districtCode(String? districtCode) => _districtCode = districtCode;

  set adCode(String? adCode) => _adCode = adCode;

  set address(String? address) => _address = address;

  set name(String? name) => _name = name;

  set lat(String? lat) => _lat = lat;

  set lng(String? lng) => _lng = lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['province'] = _province;
    map['city'] = _city;
    map['district'] = _district;
    map['provinceCode'] = _provinceCode;
    map['cityCode'] = _cityCode;
    map['districtCode'] = _districtCode;
    map['adCode'] = _adCode;
    map['address'] = _address;
    map['name'] = _name;
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}
