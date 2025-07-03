import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BaseCountDownUtil extends ChangeNotifier {
  Timer? _timer;
  ValueNotifier<int?> cdVN = ValueNotifier<int?>(0);
  int? _countDown;

  static final BaseCountDownUtil _instance = BaseCountDownUtil._internal();

  factory BaseCountDownUtil() => _instance;

  BaseCountDownUtil._internal();

  void init(int count) {
    this._countDown = count;
    this.cdVN.value = count;
  }

  void startTimer({Function()? callback, bool autoReset = true}) {
    dispose(isRecycle: false);
    if (_countDown == null) return;
    cdVN.value = _countDown!;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (cdVN.value == 1) {
        timer?.cancel();
        callback?.call();
        if (autoReset) {
          cdVN.value = _countDown!;
          startTimer(callback: () => callback?.call(), autoReset: autoReset);
        }
      } else
        cdVN?.value = (cdVN?.value ?? 1) - 1;
      notifyListeners();
    });
  }

  void set reset(int value) => this.cdVN.value = value;

  bool isCountDown() => (_timer?.isActive ?? false);

  void dispose({bool isRecycle = false}) {
    _timer?.cancel();
    if (isRecycle) _timer = null;
  }
}
