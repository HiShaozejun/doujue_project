import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:flutter/services.dart';

class BaseNetworkUtil {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  BaseNetworkUtil._internal() {
    init();
  }

  factory BaseNetworkUtil() => _instance;

  static late final BaseNetworkUtil _instance = BaseNetworkUtil._internal();

  void init() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none)
        BaseWidgetUtil.showToast('网络已断开，请检查网络！');
    });
  }

  Future<bool> isConnected() async {
    try {
      ConnectivityResult connectResult =
          await _connectivity.checkConnectivity();
      return connectResult != ConnectivityResult.none;
    } on PlatformException catch (e) {
      return false;
    }
  }

  void dispose() => _connectivitySubscription.cancel();
}
