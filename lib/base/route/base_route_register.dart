import 'package:djqs/base/route/base_route.dart';
import 'package:djqs/base/route/base_route_manager.dart';
import 'package:djqs/common/module/login/util/login_route.dart';
import 'package:djqs/common/module/search/util/search_route.dart';
import 'package:djqs/common/module/start/start_page.dart';
import 'package:djqs/module/home/util/home_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

//路由注册
class BaseRouteRegister {
  final BaseRouteManager routeManager = BaseRouteManager();

  late Map<String, RouteBuilder> _pages;

  BaseRouteRegister() {
    _loadModules();
  }

  void _loadModules() {
    routeManager.registerRoute(HomeRoute());
    routeManager.registerRoute(LoginRoute());
    routeManager.registerRoute(SearchRoute());
    routeManager.onInit();
    _pages = routeManager.getRouteBuilders();
  }

  /// 注册模块服务
  List<SingleChildWidget> onGenerateProviders() =>
      routeManager.getModuleProviders();

  /// 注册模块路由
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return _pages[settings.name]!(settings);
  }

  Widget startPage() => StartPage();
}
