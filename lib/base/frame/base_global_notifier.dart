import 'package:flutter/material.dart';

/// @description 全局使用数据及监听基类
abstract class BaseGlobalNotifier with ChangeNotifier {
  final BuildContext context;

  BaseGlobalNotifier(this.context) {
    init();
  }

  void init();
}
