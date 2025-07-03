import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_map_flutter/flutter_tencent_lbs_plugin.dart';
import 'package:tencent_map_flutter/tencent_map_flutter.dart';
import 'package:tencent_map_flutter/util/map_route_entity.dart';
import 'package:tencent_map_flutter/util/map_util.dart';
import 'package:tencent_map_flutter_example/util/util_location.dart';

final instance = FlutterLocalNotificationsPlugin();

class TestPage extends StatefulWidget {


  static const title = '定位和地图测试';

  const TestPage({super.key});

  @override
  State<TestPage> createState() => _locationState();
}

class _locationState extends State<TestPage> {
  final String appKey = '3AMBZ-U5U6J-ZLDFX-XHX4V-5G45V-EEBFS';
  final String secretKey = 'sTUMHgTErpwD4cHAiWlFv5z2DyvKV8js';
  BaseLocationUtil util = BaseLocationUtil();

  //
  late TencentMapController controller;

  @override
  void initState() {
    super.initState();
    util.init('');
    util.startLocation();
    _getRouteData();
  }

  Future<void> _getRouteData() async {
    await Future.delayed(Duration(seconds: 1));
    final mapService = TencentMapUtil();
    mapService.setKey(appKey, secretKey);

    String from = '39.915285,116.403857';
    String to = '39.915285,116.803857';
    List<LatLng>? polyline = await mapService.getEBRoute(
      from: from,
      to: to,
    );

    //var boundary = mapService.getBoundaryPoints(polyline!);

    setState(() {
      controller.addPolylines(polyline!);
      final marker1 = Marker(
        id: '1',
        position: polyline[0],
        icon: Bitmap(asset: 'images/marker.png'),
        anchor: Anchor(x: 0.5, y: 1),
        draggable: false,
      );
      final marker2 = Marker(
        id: '1',
        position: polyline[polyline.length - 1],
        icon: Bitmap(asset: 'images/marker.png'),
        anchor: Anchor(x: 0.5, y: 1),
        draggable: false,
      );
      controller.addMarker(marker1);
      controller.addMarker(marker2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          TencentMap(
            rotateGesturesEnabled:false,
            skewGesturesEnabled:false,
            mapType: MapType.normal,
            onMapCreated: (controller) => this.controller = controller,
          ),
          Positioned(
            top: 20,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                child: const Text(' 当前位置 '),
                onPressed: () {
                  final position = LatLng(
                      double.parse(util.getLocationData()?.lat ?? '0'),
                      double.parse(util.getLocationData()?.lng ?? '0'));
                  controller.moveCamera(CameraPosition(position: position));
                }),
          ),
        ],
      ),
    );
  }
}
