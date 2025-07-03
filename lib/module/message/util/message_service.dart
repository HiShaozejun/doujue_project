import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/util/util_system.dart';

class MessageServices extends BaseService {
  Future<bool?> chatReport(String title, String url) async {
    Map data = {
      'vc': BaseSystemUtil().versionCode,
      "platform": BaseSystemUtil().platform,
      'title': title,
      'url': url,
    };

    return requestSync(
        data: data,
        path: "${BaseNetConst().commonUrl}/report",
        create: (resource) => resource);
  }
}
