import 'package:djqs/base/util/util_object.dart';

/// code : 2000
/// msg : "ok"
/// now_time : 1682412090
/// result : true

class BaseEntity<T> {
  int? ret;
  String? msg;
  int? code;

  T? resultType;
  FuncEntity? data;
  dynamic? result;

  BaseEntity({this.ret, this.code, this.msg, this.data, this.result});

  BaseEntity.fromJson(Map<String, dynamic> jsonMap) {
    ret = jsonMap['ret'] as int?;
    code = jsonMap['code'] as int?;
    msg = jsonMap['msg'] as String?;
    data = FuncEntity.fromJson(jsonMap['data']);
    if (jsonMap.containsKey('result') &&
        !ObjectUtil.isEmpty(jsonMap['result'])) {
      result = generateOBJ(jsonMap['result']);
    }
  }

  // 不支持泛型 T实际还是按dynamic处理，返回一个map,再到每个回调去处理entity解析
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
}

class FuncEntity<T> {
  int? code;
  String? msg;
  List<T>? info;

  FuncEntity({this.code, this.msg, this.info});

  FuncEntity.fromJson(Map<String, dynamic>? json, {bool isShowMsg = true}) {
    code = json?['code']?.toInt();
    msg = json?['msg']?.toString();
    try {
      var value = json?['info'];
      if (value != null) {
        info = json?['info'] as List<T>;
      }
    } catch (e) {
      e.toString();
    }
  }

  static List<T> parseList<T>(
      List<dynamic> jsonList, T Function(Map<String, dynamic>) fromJson) {
    List<dynamic> data = jsonList;
    return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  bool isSuccess() => code == 0 ? true : false;
}
