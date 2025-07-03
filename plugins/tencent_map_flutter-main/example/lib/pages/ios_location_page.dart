import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_map_flutter/flutter_tencent_lbs_plugin.dart';
import 'package:tencent_map_flutter/model/android_notification_options.dart';
import 'package:tencent_map_flutter_example/pages/test_page.dart';

class IosLocationPage extends StatefulWidget {
  const IosLocationPage({super.key});

  static final String title = 'ios 定位测试';

  @override
  State<IosLocationPage> createState() => _IosLocationPageState();
}

class _IosLocationPageState extends State<IosLocationPage> {

  final locationPlugin = FlutterTencentLBSPlugin();

  @override
  void initState() {
    locationPlugin.setUserAgreePrivacy();
    locationPlugin.init(
      key: "3AMBZ-U5U6J-ZLDFX-XHX4V-5G45V-EEBFS",
    );
    locationPlugin.addLocationListener((location) {
      print("[[ listener ]]: ${location.toJson()}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(IosLocationPage.title)),
      body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            FilledButton(
              onPressed: () {
                Permission.location.request();
              },
              child: const Text("请求定位权限"),
            ),
            FilledButton(
              onPressed: () {
                locationPlugin.getLocationOnce().then(
                      (value) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            "经度为 -- ${value?.longitude ?? "N/A"}-- 维度为 -- ${value?.latitude ?? "N/A"}",
                          ),
                        );
                      },
                    );
                  },
                  onError: (err) {
                    print("[[ getLocationOnce ERROR ]]: $err");
                  },
                );
              },
              child: const Text("获取一次定位"),
            ),
            FilledButton(
              onPressed: () {
                locationPlugin.getLocation(
                  interval: 1000 * 6,
                  backgroundLocation: true,
                  androidNotificationOptions: AndroidNotificationOptions(
                    id: 100,
                    channelId: "100",
                    channelName: "定位常驻通知",
                    notificationTitle: "定位常驻通知标题文字",
                    notificationText: "定位常驻通知内容文字",
                    // iconData: const NotificationIconData(
                    //   resType: ResourceType.mipmap,
                    //   resPrefix: ResourcePrefix.ic,
                    //   name: 'launcher',
                    //   backgroundColor: Colors.red,
                    // ),
                  ),
                );
              },
              child: const Text("连续定位"),
            ),
            FilledButton(
              onPressed: locationPlugin.stop,
              child: const Text("停止连续定位"),
            ),
          ],
        ),
      ),
    ),);
  }
}
