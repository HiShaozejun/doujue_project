import 'package:djqs/base/route/base_route.dart';
import 'package:djqs/common/module/login/login_page.dart';
import 'package:flutter/cupertino.dart';

class LoginRoute extends BaseRoute {
  static const String login = "/login";

  @override
  Map<String, RouteBuilder> routeBuilders() => {
        login: (RouteSettings settings) => CupertinoPageRoute(
            settings: settings,
            builder: (_) => LoginPage(isCanBack: settings.arguments as bool?))
      };

  @override
  String localizationFileName() => '';
}
