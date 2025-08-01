//
// Created with Android Studio.
// User: 三帆
// Date: 07/02/2019
// Time: 21:14
// email: sanfan.hx@alibaba-inc.com
// tartget:  xxx
//

import 'package:flutter/material.dart';

import '../utils/picker_popup_route.dart';

class InheritRouteWidget extends InheritedWidget {
  final CityPickerRoute? router;

  InheritRouteWidget({Key? key, @required this.router, Widget? child})
      : super(key: key, child: child!);

  static InheritRouteWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritRouteWidget>();
  }

  @override
  bool updateShouldNotify(InheritRouteWidget oldWidget) {
    return oldWidget.router != router;
  }
}
