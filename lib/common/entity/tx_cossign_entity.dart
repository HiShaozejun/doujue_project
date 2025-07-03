/// expiredTime : 1683217786
/// expiration : "2023-05-04T16:29:46Z"
/// credentials : {"sessionToken":"8ObFA67bT1RK8Lb11I9E32nS5nPXyk4ae04daf3feebf3f32dd6fc80ada26cecbmL6WsFMa2m2gRjw3gF89j6R0emer_Ct_O_yz-bVLga7PDXHFTbW587IHryiAzPKhUFSismD5RUj8evmr19aohRrvBV5bsSzGYv5jltShXNduQ__jtzy3-OHOslyV6HWCjLH00T8FnA5Fz86T1CqGVbrdk63Jgo04-izcUHj9gK9UxiabAJx88QtSQeikMU6mcHiuS8oiJc6jqRjR6kcUEFAAgPZ2JYjnvqp_A0EUtAwhdaBLMOMwsncbs8fBsWd9odhKNqXfw5lB6eeII3P3XzF1KifSzh6e2kqmx8xG76KqV-Ae5KXbVXv7a7Hl3nxVWNC6UIPpyP8G_4X9ulErUQ","tmpSecretId":"AKID8l8vnQyA6gDoNW1FIjnxRKrefHiA793mFOtvoOuvwwR5lTS65PaYAGq2TqcrlApV","tmpSecretKey":"42Pr7QHaPMyTWU4mjJYvhw0H00uxhNcVONtBSBrfgsQ="}
/// requestId : "4d4c87fa-05fc-4626-8912-512fb299562b"
/// startTime : 1683215986
/// bucket : "kmsp-qs-bj-1258783124"
/// region : "ap-beijing"
/// url : "https://kmsp-qs-bj-1258783124.cos.ap-beijing.myqcloud.com"

class TXCosSignEntity {
  TXCosSignEntity({
    int? expiredTime,
    String? expiration,
    Credentials? credentials,
    String? requestId,
    int? startTime,
    String? bucket,
    String? region,
    String? url,
  }) {
    _expiredTime = expiredTime;
    _expiration = expiration;
    _credentials = credentials;
    _requestId = requestId;
    _startTime = startTime;
    _bucket = bucket;
    _region = region;
    _url = url;
  }

  TXCosSignEntity.fromJson(dynamic json) {
    _expiredTime = json['expiredTime'];
    _expiration = json['expiration'];
    _credentials = json['credentials'] != null
        ? Credentials.fromJson(json['credentials'])
        : null;
    _requestId = json['requestId'];
    _startTime = json['startTime'];
    _bucket = json['bucket'];
    _region = json['region'];
    _url = json['url'];
  }

  int? _expiredTime;
  String? _expiration;
  Credentials? _credentials;
  String? _requestId;
  int? _startTime;
  String? _bucket;
  String? _region;
  String? _url;

  TXCosSignEntity copyWith({
    int? expiredTime,
    String? expiration,
    Credentials? credentials,
    String? requestId,
    int? startTime,
    String? bucket,
    String? region,
    String? url,
  }) =>
      TXCosSignEntity(
        expiredTime: expiredTime ?? _expiredTime,
        expiration: expiration ?? _expiration,
        credentials: credentials ?? _credentials,
        requestId: requestId ?? _requestId,
        startTime: startTime ?? _startTime,
        bucket: bucket ?? _bucket,
        region: region ?? _region,
        url: url ?? _url,
      );

  int? get expiredTime => _expiredTime;

  String? get expiration => _expiration;

  Credentials? get credentials => _credentials;

  String? get requestId => _requestId;

  int? get startTime => _startTime;

  String? get bucket => _bucket;

  String? get region => _region;

  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['expiredTime'] = _expiredTime;
    map['expiration'] = _expiration;
    if (_credentials != null) {
      map['credentials'] = _credentials?.toJson();
    }
    map['requestId'] = _requestId;
    map['startTime'] = _startTime;
    map['bucket'] = _bucket;
    map['region'] = _region;
    map['url'] = _url;
    return map;
  }
}

/// sessionToken : "8ObFA67bT1RK8Lb11I9E32nS5nPXyk4ae04daf3feebf3f32dd6fc80ada26cecbmL6WsFMa2m2gRjw3gF89j6R0emer_Ct_O_yz-bVLga7PDXHFTbW587IHryiAzPKhUFSismD5RUj8evmr19aohRrvBV5bsSzGYv5jltShXNduQ__jtzy3-OHOslyV6HWCjLH00T8FnA5Fz86T1CqGVbrdk63Jgo04-izcUHj9gK9UxiabAJx88QtSQeikMU6mcHiuS8oiJc6jqRjR6kcUEFAAgPZ2JYjnvqp_A0EUtAwhdaBLMOMwsncbs8fBsWd9odhKNqXfw5lB6eeII3P3XzF1KifSzh6e2kqmx8xG76KqV-Ae5KXbVXv7a7Hl3nxVWNC6UIPpyP8G_4X9ulErUQ"
/// tmpSecretId : "AKID8l8vnQyA6gDoNW1FIjnxRKrefHiA793mFOtvoOuvwwR5lTS65PaYAGq2TqcrlApV"
/// tmpSecretKey : "42Pr7QHaPMyTWU4mjJYvhw0H00uxhNcVONtBSBrfgsQ="

class Credentials {
  Credentials({
    String? sessionToken,
    String? tmpSecretId,
    String? tmpSecretKey,
  }) {
    _sessionToken = sessionToken;
    _tmpSecretId = tmpSecretId;
    _tmpSecretKey = tmpSecretKey;
  }

  Credentials.fromJson(dynamic json) {
    _sessionToken = json['sessionToken'];
    _tmpSecretId = json['tmpSecretId'];
    _tmpSecretKey = json['tmpSecretKey'];
  }

  String? _sessionToken;
  String? _tmpSecretId;
  String? _tmpSecretKey;

  Credentials copyWith({
    String? sessionToken,
    String? tmpSecretId,
    String? tmpSecretKey,
  }) =>
      Credentials(
        sessionToken: sessionToken ?? _sessionToken,
        tmpSecretId: tmpSecretId ?? _tmpSecretId,
        tmpSecretKey: tmpSecretKey ?? _tmpSecretKey,
      );

  String? get sessionToken => _sessionToken;

  String? get tmpSecretId => _tmpSecretId;

  String? get tmpSecretKey => _tmpSecretKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionToken'] = _sessionToken;
    map['tmpSecretId'] = _tmpSecretId;
    map['tmpSecretKey'] = _tmpSecretKey;
    return map;
  }
}
