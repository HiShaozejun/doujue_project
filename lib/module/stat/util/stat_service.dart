import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/stat/entity/stat_month_entity.dart';
import 'package:djqs/module/stat/entity/state_today_entity.dart';

class StatService extends BaseService {
  Future<List<StatTodayEntity>?> getStatTodayData() => requestSync(
      showLoading: false,
      path: "${BaseNetConst().commonUrl}Rider.Orders.GetCount",
      create: (resource) => FuncEntity.parseList(
          resource, (json) => StatTodayEntity.fromJson(json)));

  Future<List<StatMonthEntity>?> getStatMonthList() => requestSync(
      showLoading: false,
      data: {"year": 0},
      path: "${BaseNetConst().commonUrl}Rider.Orders.GetMonthCount",
      create: (resource) => FuncEntity.parseList(
          resource, (json) => StatMonthEntity.fromJson(json)));

  Future<dynamic> getOrderList(int type) => requestSync(
      data: {'type': type},
      path: "${BaseNetConst().commonUrl}Rider.Orders.GetCountList",
      create: (resource) => OrderListEntity().parseList(resource));
}
