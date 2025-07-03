import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:djqs/common/util/common_util.dart';
import 'package:djqs/module/home/util/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'util/agreement_util.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    AppInitUtil().initConfig();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (CommonUtil().isFirstLogin) {
        FlutterNativeSplash.remove();
        AgreementUtil(context,
            onNagBtn: () => BaseSystemUtil().exitApp(),
            onPosBtn: () {
              CommonUtil().firstLogin = false;
              start();
            }).showAgreeDialog();
      } else {
        Future.delayed(Duration(milliseconds: 200)).then((_) {
          start();
        });
      }
    });
  }

  void start() async {
    AppInitUtil().initConfigWithPolicy();
    //if (Platform.isAndroid) await BaseMCUtil.initThirdSdk();
    Navigator.pushReplacementNamed(context, HomeRoute.home);
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) => Material(color: BaseColors.trans);
}
