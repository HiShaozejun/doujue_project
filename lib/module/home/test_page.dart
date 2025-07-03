import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tencent_map_flutter/tencent_map_flutter.dart';
import 'package:tencent_map_flutter/util/map_util.dart';

final instance = FlutterLocalNotificationsPlugin();

class TestPage extends StatefulWidget {
  static const title = '定位和地图测试';

  const TestPage({super.key});

  @override
  State<TestPage> createState() => _locationState();
}

class _locationState extends State<TestPage> {
  BaseLocationUtil util = BaseLocationUtil();
  final mapUtil = TencentMapUtil();

  //
  late TencentMapController controller;

  @override
  void initState() {
    super.initState();
    util.init('', '');
    util.startLocation();
    //_getRouteData();
  }

  void _showLocation() async{
    // final position = LatLng(
    //     double.parse(util.getLocationData()?.lat ?? '0'),
    //     double.parse(util.getLocationData()?.lng ?? '0'));
    // controller.moveCamera(CameraPosition(position: position));

    Location location = await controller.getUserLocation();
    controller.moveCamera(
      CameraPosition(
        position: location.position,
        heading: location.heading,
      ),
    );
  }

  Future<void> _getRouteData() async {
    await Future.delayed(Duration(seconds: 1));

    String from = '39.915285,116.403857';
    String to = '39.915285,116.803857';
    List<LatLng>? polyline = await mapUtil.getEBRoute(
      from: from,
      to: to,
    );

    setState(() {
      controller.addPolylines(polyline!);
      final markerStart = Marker(
        id: '1',
        position: polyline[0],
        icon:
            Bitmap(asset: BaseImageUtil().getAssetImgPath('app_mapmarker_me')),
        anchor: Anchor(x: 0.5, y: 1),
        draggable: false,
      );
      final markerEnd = Marker(
        id: '2',
        position: polyline[polyline.length - 1],
        icon: Bitmap(
            asset: BaseImageUtil().getAssetImgPath('app_mapmarker_shop')),
        anchor: Anchor(x: 0.5, y: 1),
        draggable: false,
      );
      controller.addMarker(markerStart);
      controller.addMarker(markerEnd);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          TencentMap(
            rotateGesturesEnabled: false,
            skewGesturesEnabled: false,
            androidTexture: true,
            myLocationEnabled: true,
            userLocationType: UserLocationType.trackingLocationRotate,
            mapType: MapType.normal,
            onMapCreated: (controller) => this.controller = controller,
            onLocation: (location) {
              debugPrint(
                '${location.position.latitude}, ${location.position.longitude}',
              );
            },
          ),
          Positioned(
            top: 20,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                child: const Text(' 当前位置 '),
                onPressed: ()=>_showLocation()),
          ),
        ],
      ),
    );
  }
}
