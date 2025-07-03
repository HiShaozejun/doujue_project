import 'package:djqs/base/util/util_object.dart';

class JsChannelEntity<T> {
  String? method;
  String? callback;
  T? data;

  JsChannelEntity({
    this.method,
    this.callback,
    this.data,
  });

  JsChannelEntity.fromJson(Map<String, dynamic> jsonMap) {
    method = jsonMap['method'] as String?;
    callback = jsonMap['callback'] as String?;

    if (jsonMap.containsKey('data') && !ObjectUtil.isEmpty(jsonMap['data'])) {
      data = generateOBJ<T>(jsonMap['data']);
    }
  }

  T? generateOBJ<T>(json) {
    if (json == null) {
      return null;
    } else if (T.toString() == 'String') {
      return json.toString() as T;
    } else {
      return json as T;
    }
  }
}
