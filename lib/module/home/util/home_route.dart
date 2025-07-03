import 'package:djqs/base/route/base_route.dart';
import 'package:djqs/module/home/home_page.dart';
import 'package:flutter/cupertino.dart';

class HomeRoute extends BaseRoute {
  static const String home = "/home";

  @override
  Map<String, RouteBuilder> routeBuilders() => {
        home: (RouteSettings settings) =>
            CupertinoPageRoute(settings: settings, builder: (_) => HomePage()),
      };

  @override
  String localizationFileName() => '';
}
