import 'dart:convert';

import 'package:djqs/base/extensions/function_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseSPUtil {
  late final SharedPreferences _spf;

  BaseSPUtil._internal() {}

  factory BaseSPUtil() => _instance;

  static late final BaseSPUtil _instance = BaseSPUtil._internal();

  Future<void> init() async => _spf = await SharedPreferences.getInstance();

  Future<bool>? putObject(String key, Object value) =>
      _spf?.setString(key, value == null ? '' : json.encode(value));

  T? getObj<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  Map? getObject(String key) {
    if (_spf == null) return null;
    String? _data = _spf!.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  String getString(String key, {String defValue = ''}) =>
      _spf == null ? defValue : _spf!.getString(key) ?? defValue;

  Future<bool>? putString(String key, String value) =>
      _spf?.setString(key, value);

  bool getBool(String key, {bool defValue = false}) =>
      _spf == null ? defValue : _spf!.getBool(key) ?? defValue;

  Future<bool>? putBool(String key, bool value) => _spf?.setBool(key, value);

  int getInt(String key, {int defValue = 0}) =>
      _spf == null ? defValue : _spf!.getInt(key) ?? defValue;

  Future<bool>? putInt(String key, int value) => _spf?.setInt(key, value);

  double getDouble(String key, {double defValue = 0.0}) =>
      _spf == null ? defValue : _spf?.getDouble(key) ?? defValue;

  Future<bool>? putDouble(String key, double value) =>
      _spf?.setDouble(key, value);

  List<String> getStringList(String key, {List<String> defValue = const []}) =>
      _spf == null ? defValue : _spf!.getStringList(key) ?? defValue;

  Future<bool>? putStringList(String key, List<String> value) =>
      _spf?.setStringList(key, value);

  dynamic getDynamic(String key, {Object? defValue}) =>
      _spf == null ? defValue : _spf!.get(key) ?? defValue;

  Future<bool>? putEntity<T>(String localKey, T? data) async =>
      _spf!.setString(localKey, jsonEncode(data));

  dynamic getEntity<T>(String localKey) {
    if (_spf == null) return null;
    String? jsonStr = _spf!.getString(localKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      return jsonDecode(jsonStr);
    }
    return null;
  }

  bool? haveKey(String key) => _spf?.getKeys().contains(key);

  Set<String>? getKeys() => _spf?.getKeys();

  Future<bool>? remove(String key) => _spf?.remove(key);

  Future<bool>? clear() => _spf?.clear();

  Future<T?> getCache<T>(String localKey, CreateJson<T> createJson) async {
    String? jsonStr = _spf!.getString(localKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      return createJson(jsonDecode(jsonStr));
    }
    return null;
  }

  void requestCache<T>(
      {required String localKey,
      required CreateJson<T> createJson,
      required Future<T> requestFuture,
      required Function(T value) callback,
      required Function(dynamic error) onError}) async {
    // 本地缓存获取
    T? data = await getCache(localKey, createJson);
    data?.run((self) => callback(self));

    // 网络请求
    requestFuture.then((value) {
      if (data == null) {
        putEntity(localKey, value);
        callback(value);
        return;
      }
      if (jsonEncode(data) != jsonEncode(value)) {
        putEntity(localKey, value);
        callback(value);
      }
    }).catchError(onError);
  }
}
