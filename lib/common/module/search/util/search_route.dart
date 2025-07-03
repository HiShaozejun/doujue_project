import 'package:djqs/base/route/base_route.dart';

class SearchRoute extends BaseRoute {
  static const String search = "/search";

  @override
  Map<String, RouteBuilder> routeBuilders() => {
        // search: (RouteSettings settings) {
        //   return CupertinoPageRoute(
        //       settings: settings,
        //       builder: (_) => SearchPage(sourceType: settings.arguments as int) );
        // }
      };

  @override
  String localizationFileName() => '';
}
