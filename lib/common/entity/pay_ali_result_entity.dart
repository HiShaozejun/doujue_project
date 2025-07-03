/// alipay_trade_app_pay_response : {"code":"10000","msg":"Success","app_id":"2021001195615300","auth_app_id":"2021001195615300","charset":"UTF-8","timestamp":"2023-07-26 15:26:58","out_trade_no":"SN16903564096828244","total_amount":"0.01","trade_no":"2023072622001476461435154414","seller_id":"2088931583171653"}
/// sign : "EnquPOB3aMIawtY0VqoibOdfOAhTH3GxuAkPl8KVz71MrZ1xfb/GLDwv2lnB+Jij8TPkulvX51622T7ONLZcG/2tTnzkf5zRGthuNW09JspMATHgDiOtwCV7YajxX/3hkqwIE+7bZK1RuKXf5o0ZM2PAwzsIL/b2ivJkFtpSGBSrDn1zUbi0ANqVfLw3hPnETwI89Ym9XNNs9QPEtPxS7QVqu/kikBYCdDm00bs41PIdTDT7VyYOD/C1klEWovZzZ+ooHwz0yIY070sCsgwDk8fecIxnPSUJfy0+qcoQfM4nQmtWDqGnHhW7ZX3oIN86rt6bDyfqTeYRYbi/wPCoMw=="
/// sign_type : "RSA2"

class PayAliResultEntity {
  PayAliResultEntity({
    AlipayTradeAppPayResponse? alipayTradeAppPayResponse,
    String? sign,
    String? signType,
  }) {
    _alipayTradeAppPayResponse = alipayTradeAppPayResponse;
    _sign = sign;
    _signType = signType;
  }

  PayAliResultEntity.fromJson(dynamic json) {
    _alipayTradeAppPayResponse = json['alipay_trade_app_pay_response'] != null
        ? AlipayTradeAppPayResponse.fromJson(
            json['alipay_trade_app_pay_response'])
        : null;
    _sign = json['sign'];
    _signType = json['sign_type'];
  }

  AlipayTradeAppPayResponse? _alipayTradeAppPayResponse;
  String? _sign;
  String? _signType;

  PayAliResultEntity copyWith({
    AlipayTradeAppPayResponse? alipayTradeAppPayResponse,
    String? sign,
    String? signType,
  }) =>
      PayAliResultEntity(
        alipayTradeAppPayResponse:
            alipayTradeAppPayResponse ?? _alipayTradeAppPayResponse,
        sign: sign ?? _sign,
        signType: signType ?? _signType,
      );

  AlipayTradeAppPayResponse? get alipayTradeAppPayResponse =>
      _alipayTradeAppPayResponse;

  String? get sign => _sign;

  String? get signType => _signType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_alipayTradeAppPayResponse != null) {
      map['alipay_trade_app_pay_response'] =
          _alipayTradeAppPayResponse?.toJson();
    }
    map['sign'] = _sign;
    map['sign_type'] = _signType;
    return map;
  }
}

/// code : "10000"
/// msg : "Success"
/// app_id : "2021001195615300"
/// auth_app_id : "2021001195615300"
/// charset : "UTF-8"
/// timestamp : "2023-07-26 15:26:58"
/// out_trade_no : "SN16903564096828244"
/// total_amount : "0.01"
/// trade_no : "2023072622001476461435154414"
/// seller_id : "2088931583171653"

class AlipayTradeAppPayResponse {
  AlipayTradeAppPayResponse({
    String? code,
    String? msg,
    String? appId,
    String? authAppId,
    String? charset,
    String? timestamp,
    String? outTradeNo,
    String? totalAmount,
    String? tradeNo,
    String? sellerId,
  }) {
    _code = code;
    _msg = msg;
    _appId = appId;
    _authAppId = authAppId;
    _charset = charset;
    _timestamp = timestamp;
    _outTradeNo = outTradeNo;
    _totalAmount = totalAmount;
    _tradeNo = tradeNo;
    _sellerId = sellerId;
  }

  AlipayTradeAppPayResponse.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _appId = json['app_id'];
    _authAppId = json['auth_app_id'];
    _charset = json['charset'];
    _timestamp = json['timestamp'];
    _outTradeNo = json['out_trade_no'];
    _totalAmount = json['total_amount'];
    _tradeNo = json['trade_no'];
    _sellerId = json['seller_id'];
  }

  String? _code;
  String? _msg;
  String? _appId;
  String? _authAppId;
  String? _charset;
  String? _timestamp;
  String? _outTradeNo;
  String? _totalAmount;
  String? _tradeNo;
  String? _sellerId;

  AlipayTradeAppPayResponse copyWith({
    String? code,
    String? msg,
    String? appId,
    String? authAppId,
    String? charset,
    String? timestamp,
    String? outTradeNo,
    String? totalAmount,
    String? tradeNo,
    String? sellerId,
  }) =>
      AlipayTradeAppPayResponse(
        code: code ?? _code,
        msg: msg ?? _msg,
        appId: appId ?? _appId,
        authAppId: authAppId ?? _authAppId,
        charset: charset ?? _charset,
        timestamp: timestamp ?? _timestamp,
        outTradeNo: outTradeNo ?? _outTradeNo,
        totalAmount: totalAmount ?? _totalAmount,
        tradeNo: tradeNo ?? _tradeNo,
        sellerId: sellerId ?? _sellerId,
      );

  String? get code => _code;

  String? get msg => _msg;

  String? get appId => _appId;

  String? get authAppId => _authAppId;

  String? get charset => _charset;

  String? get timestamp => _timestamp;

  String? get outTradeNo => _outTradeNo;

  String? get totalAmount => _totalAmount;

  String? get tradeNo => _tradeNo;

  String? get sellerId => _sellerId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['app_id'] = _appId;
    map['auth_app_id'] = _authAppId;
    map['charset'] = _charset;
    map['timestamp'] = _timestamp;
    map['out_trade_no'] = _outTradeNo;
    map['total_amount'] = _totalAmount;
    map['trade_no'] = _tradeNo;
    map['seller_id'] = _sellerId;
    return map;
  }
}
