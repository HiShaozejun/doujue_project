import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';

import 'map_route_entity.dart';

class TencentMapUtil {
  late String appKey;
  late String secretKey;

  TencentMapUtil._internal();

  factory TencentMapUtil() => _instance;

  static late final TencentMapUtil _instance = TencentMapUtil._internal();

  final Dio _dio = Dio();

  void setKey(String appKey, String secretKey) {
    this.appKey = appKey;
    this.secretKey = secretKey;
  }

  String _generateSig(String path, Map<String, String> params) {
    final sortedParams = Map.of(params);
    final sortedKeys = sortedParams.keys.toList()..sort();

    final paramString =
        sortedKeys.map((k) => '$k=${sortedParams[k] ?? ''}').join('&');

    final signString = '$path?$paramString$secretKey';

    final bytes = utf8.encode(signString);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  Future<List<LatLng>?> getEBRoute({
    required String from,
    required String to,
  }) async {
    const String path = '/ws/direction/v1/ebicycling/';
    const String baseUrl = 'https://apis.map.qq.com$path';

    final params = <String, String>{
      'from': from,
      'to': to,
      'key': appKey,
    };
    params['sig'] = _generateSig(path, params);

    try {
      final response = await _dio.get(baseUrl, queryParameters: params);

      MapRouteEntity? entity = MapRouteEntity.fromJson(response.data);
      if (response.data['status'] == 0) {
          return decodeTencentPolyline(entity.result!.routes![0]!.polyline!);
      } else {
          Fluttertoast.showToast(
              msg: entity?.message ?? '获取地图路径出错',
              toastLength: Toast.LENGTH_SHORT,
              fontSize: 14,
              backgroundColor: Color(0xff828282),
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white);
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<LatLng> decodeTencentPolyline(List<double?> coors) {
    if (coors.length < 2) return [];

    // 解码主逻辑
    for (int i = 2; i < coors.length; i++) {
      coors[i] = coors[i - 2]! + coors[i]! / 1e6;
    }

    // 每两个值为一组 lat, lng
    List<LatLng> result = [];
    for (int i = 0; i < coors.length; i += 2) {
      result.add(LatLng(coors![i]!, coors![i + 1]!));
    }

    return result;
  }

  Map<String, double> getBoundaryPoints(List<LatLng> points) {
    if (points.isEmpty) return {};

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return {
      'minLat': minLat, // 最南
      'maxLat': maxLat, // 最北
      'minLng': minLng, // 最西
      'maxLng': maxLng, // 最东
    };
  }
}
