import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/common/module/search/entity/search_hotlist_entity.dart';

class SearchService extends BaseService {
  Future<SearchHotListEntity?> getHotList() => requestSync(
      path: "${BaseNetConst().commonUrl}/recruit/hot-words",
      create: (resource) => SearchHotListEntity.fromJson(resource));
}
