import 'package:djqs/module/home/util/home_route.dart';
import 'package:flutter/material.dart';

class BaseRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final BaseRouteObserver instance = BaseRouteObserver._internal();

  BaseRouteObserver._internal();

  String? _currentRouteName;

  String? get currentRouteName => _currentRouteName;

  bool get isCurrentHome => _currentRouteName == HomeRoute.home;

  @override
  void didPush(Route route, Route? previousRoute) {
    _update(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _update(previousRoute);
    super.didPop(route, previousRoute);
  }

  void _update(Route? route) {
    if (route is PageRoute) _currentRouteName = route.settings.name;
  }
}
