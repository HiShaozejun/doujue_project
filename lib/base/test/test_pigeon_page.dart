import 'dart:io';

import 'package:djqs/base/frame/base_empty_notifier.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPigeonPage extends StatefulWidget {
  TestPigeonPage();

  @override
  _TestPigeonPageState createState() => _TestPigeonPageState();
}

class _TestPigeonPageState extends BasePageState<TestPigeonPage, BaseNotifier> {
  static const MethodChannel iosMC = MethodChannel('flutter_plugin_ios');
  var iosViewMC = MethodChannel('com.flutter.guide.MethodChannel');

  String? str;
  var mcList = [];

  Future<Null> getBatteryLevel() async {
    String batteryLevel = '';
    try {
      final int result = await iosMC.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result %.';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'. ";
    } finally {
      BaseWidgetUtil.showToast(batteryLevel);
    }
  }

  @override
  void initState() {
    super.initState();
    initData();

    //接收ios传过来的数据
    iosViewMC.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'timer':
          final result = call.arguments as String;
          result.toString();
          break;
      }

      print('count==' + call.arguments["count"]);
      print('name==' + call.arguments["name"]);
    });

    test();
  }

  void test() async {
    var result = await iosViewMC.invokeMethod(
        "sendData", {"name": "卢三", "age": "19"}); //flutter调用ios的方法及传参
    print(result['name']);
  }

  void initData() async {
    // str = await PigeonHostApi().getPigeonString();
    // str.toString();
  }

  @override
  Widget build(BuildContext context) => buildViewModel<EmptyNotifier>(
      appBar: BaseWidgetUtil.getAppbar(context, 'pigeon测试'),
      create: (context) => EmptyNotifier(context),
      viewBuild: (context, vm) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(str ?? 'piegon无'),
              BaseGaps().vGap10,
              BaseWidgetUtil.getButton(
                  text: 'ios channel测试', onTap: () => getBatteryLevel()),
              BaseGaps().vGap10,
              Expanded(child: _plantformView())
            ],
          ));

  Widget _plantformView() {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'plugins.flutter.io/custom_platform_view',
        onPlatformViewCreated: (viewId) {
          print('viewId:$viewId');
          mcList.add(MethodChannel('com.flutter.guide.FlutterView_$viewId'));
        },
        creationParams: {'text': 'Flutter传给IOSTextView的参数'},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else
      return Container();
  }
}
