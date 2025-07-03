/// code : 2000
/// msg : "ok"
/// now_time : 1682412090
/// result : true

class BaseEntityDuo<T> {
  int? ret;
  String? msg;

  T? resultType;
  FuncEntityDuo? data;

  BaseEntityDuo({this.ret, this.msg, this.data});

  BaseEntityDuo.fromJson(Map<String, dynamic> jsonMap) {
    ret = jsonMap['ret'] as int?;
    msg = jsonMap['msg'] as String?;
    data = FuncEntityDuo.fromJson(jsonMap['data']);
  }
}

class FuncEntityDuo<T> {
  int? code;
  String? msg;
  dynamic? info;

  FuncEntityDuo({this.code, this.msg, this.info});

  FuncEntityDuo.fromJson(Map<String, dynamic> json, {bool isShowMsg = true}) {
    code = json['code']?.toInt();
    msg = json['msg']?.toString();
    try {
      var value = json['info'];
      if (value != null) info = generateOBJ(json['info']);
    } catch (e) {
      e.toString();
    }
  }

  dynamic generateOBJ(json) {
    if (json == null) {
      return null;
    } else if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (json is Map) {
      return json as Map<String, dynamic>;
    } else
      return json as T;
  }

  bool isSuccess() => code == 0 ? true : false;
}
