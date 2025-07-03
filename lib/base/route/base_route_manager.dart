import 'package:djqs/app/app_notifier.dart';
import 'package:djqs/base/route/base_route.dart';
import 'package:djqs/base/ui/base_theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// @description route和provider管理基类
class BaseRouteManager {
  final List<BaseRoute> _routes = List.empty(growable: true);

  void registerRoute(BaseRoute module) {
    _routes.add(module);
  }

  void onInit() {
    for (var module in _routes) {
      module.onInit();
    }
  }

  void dispose() {
    for (var module in _routes) {
      module.dispose();
    }

    _routes.clear();
  }

  bool isHome() {
    return false;
  }

  Map<String, RouteBuilder> getRouteBuilders() {
    Map<String, RouteBuilder> routeBuilders = {};
    for (var module in _routes) {
      routeBuilders.addAll(module.routeBuilders());
    }
    return routeBuilders;
  }

  List<SingleChildWidget> getModuleProviders() {
    final List<SingleChildWidget> providers = [
      ChangeNotifierProvider(
          create: (context) => BaseThemeNotifier(context: context)),
      ChangeNotifierProvider(create: (context) => AppNotifier(context)),
      //ChangeNotifierProvider(create: (context) => AccountNotifier(context))
    ];

    return providers;
  }

  List<String> getLocalizationFileNames() {
    final list =
        _routes.map((module) => module.localizationFileName()).toList();
    list.add("common");
    return list;
  }
}

typedef PageBuilder = Route<dynamic> Function(RouteSettings settings);
