/// user_id : 8757
/// type : "recharge"
/// business_id : ""
/// price : 1
/// score : 100
/// id : 84
/// tran_sn : "DJ1690355440409164086"
/// pay_code : "method=alipay.trade.app.pay&app_id=2021001195615300&timestamp=2023-07-26+15%3A10%3A40&format=json&version=1.0&alipay_sdk=alipay-easysdk-php-2.2.3&charset=UTF-8&sign_type=RSA2&app_cert_sn=6a53ded2948211fb5989f7b39331bc7b&alipay_root_cert_sn=687b59193f3f462dd5336e5abf83c5d8_02941eef3187dddf3d3b83462e1dfcf6&biz_content=%7B%22subject%22%3A%22%E5%85%85%E5%80%BC%E7%A7%AF%E5%88%86%22%2C%22out_trade_no%22%3A%22SN16903554404374259%22%2C%22total_amount%22%3A0.01%7D&notify_url=http%3A%2F%2F120.53.248.29%3A8091%2Falipay%2Ftran-notify&sign=bwuDoUFmJx0c0Vp5%2FCLhJa65i7uSNIEBwhVO3%2BC9FTDP2I%2Ff0CYh%2FHrL2RFBPaTOM5EDa%2FNVbtchIElRhLhSd%2BTQhHEAgv0uKeo%2BNL6Ngdjb70Lw1CuP%2BPn9wv4yiXA8QYlrMP7mvBLlCRRBTs5WvwXBgOS6jN2dgh38oOw9rPqq%2FrVgyRR%2FMHOanpziLB6B7A%2FdkNagvv6Q0awSyGf8zWK5sX5RkXkQKQ97GkgI7V8mYq0%2FxKX2SIA%2F5ar8LnrBgBd2%2FaPbVds%2FPbpofvgJ4eaTQha%2BVS89CYmlLbzJf6DZrg0fK3oDlnwafaGaxla5aZKKVoKrJtFBrDZMtQwiJQ%3D%3D"

class PayOrderEntity {
  PayOrderEntity({
    int? userId,
    String? type,
    String? businessId,
    int? price,
    int? score,
    int? id,
    String? tranSn,
    String? payCode,
  }) {
    _userId = userId;
    _type = type;
    _businessId = businessId;
    _price = price;
    _score = score;
    _id = id;
    _tranSn = tranSn;
    _payCode = payCode;
  }

  PayOrderEntity.fromJson(dynamic json) {
    _userId = json['user_id'];
    _type = json['type'];
    _businessId = json['business_id'];
    _price = json['price'];
    _score = json['score'];
    _id = json['id'];
    _tranSn = json['tran_sn'];
    _payCode = json['pay_code'];
  }

  int? _userId;
  String? _type;
  String? _businessId;
  int? _price;
  int? _score;
  int? _id;
  String? _tranSn;
  String? _payCode;

  PayOrderEntity copyWith({
    int? userId,
    String? type,
    String? businessId,
    int? price,
    int? score,
    int? id,
    String? tranSn,
    String? payCode,
  }) =>
      PayOrderEntity(
        userId: userId ?? _userId,
        type: type ?? _type,
        businessId: businessId ?? _businessId,
        price: price ?? _price,
        score: score ?? _score,
        id: id ?? _id,
        tranSn: tranSn ?? _tranSn,
        payCode: payCode ?? _payCode,
      );

  int? get userId => _userId;

  String? get type => _type;

  String? get businessId => _businessId;

  int? get price => _price;

  int? get score => _score;

  int? get id => _id;

  String? get tranSn => _tranSn;

  String? get payCode => _payCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['type'] = _type;
    map['business_id'] = _businessId;
    map['price'] = _price;
    map['score'] = _score;
    map['id'] = _id;
    map['tran_sn'] = _tranSn;
    map['pay_code'] = _payCode;
    return map;
  }
}
