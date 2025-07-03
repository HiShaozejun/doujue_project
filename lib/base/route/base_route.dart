import 'package:flutter/material.dart';

abstract class BaseRoute {
  BaseRoute();

  @mustCallSuper
  void onInit() {}

  @mustCallSuper
  void dispose() {}

  Map<String, RouteBuilder> routeBuilders();

  String localizationFileName();
}

typedef RouteBuilder = Route<dynamic> Function(RouteSettings settings);
