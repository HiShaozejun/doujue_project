import 'dart:convert';

import 'package:djqs/app/netDuo/base_service_duo.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/module/oderlist/entity/order_count_entity.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';

class OrderListService extends BaseService {
  Future<dynamic?> getOrderList(int type, {int page = 1,bool isLoading=false}) => requestSync(
      showLoading: isLoading,
      data: {
        'type': type,
        'p': page,
      },
      path: "${BaseNetConst().commonUrl}Rider.Orders.GetList",
      create: (resource) {
        var result = OrderListEntity().parseList(resource);
        return result;
      });

  Future<List<OrderEntity>?> getOrderDetail(String? orderId) => requestSync(
      data: {'oid': orderId},
      path: "${BaseNetConst().commonUrl}Rider.Orders.GetDetail",
      create: (resource) =>
          FuncEntity.parseList(resource, (json) => OrderEntity.fromJson(json)));

  Future<FuncEntity?> orderGrab(String? orderId) => requestSync(
      returnBaseEntity: true,
      data: {
        'oid': orderId,
        'lat': BaseLocationUtil().getLocationData()?.lat,
        'lng': BaseLocationUtil().getLocationData()?.lng
      },
      path: "${BaseNetConst().commonUrl}Rider.Orders.Grap",
      create: (resource) => resource);

  Future<FuncEntity?> orderArrival(String? orderId) => requestSync(
      returnBaseEntity: true,
      data: {
        'order_id': orderId,
        'lat': BaseLocationUtil().getLocationData()?.lat,
        'lng': BaseLocationUtil().getLocationData()?.lng
      },
      path: "${BaseNetConst().commonUrl}Rider.Orders.ReachTheStore",
      create: (resource) => resource);

  Future<FuncEntity?> orderTake(String? orderId) => requestSync(
      returnBaseEntity: true,
      data: {
        'oid': orderId,
        'lat': BaseLocationUtil().getLocationData()?.lat,
        'lng': BaseLocationUtil().getLocationData()?.lng
      },
      path: "${BaseNetConst().commonUrl}Rider.Orders.Start",
      create: (resource) => resource);

  Future<dynamic> orderComplete(String? orderId) => requestSync(
      returnBaseEntity: true,
      data: {
        'oid': orderId,
        'lat': BaseLocationUtil().getLocationData()?.lat,
        'lng': BaseLocationUtil().getLocationData()?.lng
      },
      path: "${BaseNetConst().commonUrl}Rider.Orders.Complete",
      create: (resource) => resource);

  Future<dynamic> orderForceComplete(String? orderId,
      {String? code,List? images}) =>
      requestSync(
          returnBaseEntity: true,
          data: {
            'oid': orderId,
            'lat': BaseLocationUtil().getLocationData()?.lat,
            'lng': BaseLocationUtil().getLocationData()?.lng,
            'code': code ?? '',
            'thumbs': jsonEncode(images)
          },
          path: "${BaseNetConst().commonUrl}Rider.Orders.forceComplete",
          create: (resource) => resource);

  Future<dynamic> orderError(String? orderId,
          {String? code, String? desc, List? images}) =>
      requestSync(
          returnBaseEntity: true,
          data: {
            'oid': orderId,
            'lat': BaseLocationUtil().getLocationData()?.lat,
            'lng': BaseLocationUtil().getLocationData()?.lng,
            'code': code ?? '',
            'desc': desc ?? '',
            'thumbs': jsonEncode(images)
          },
          path: "${BaseNetConst().commonUrl}Rider.OrdersException.Save",
          create: (resource) => resource);


}

class OrderListServiceDuo extends BaseServiceDuo {
  Future<OrderCountEntity?> getOrderCount() => requestSync(
      showLoading: false,
      path: "${BaseNetConst().commonUrl}Rider.Orders.GetCountGroupByType",
      create: (resource) => OrderCountEntity.fromJson(resource));

  Future<dynamic> orderCheckComplete(String? orderId) => requestSync(
      returnBaseEntity: true,
      data: {
        'oid': orderId,
        'lat': BaseLocationUtil().getLocationData()?.lat,
        'lng': BaseLocationUtil().getLocationData()?.lng
      },
      path: "${BaseNetConst().commonUrl}Rider.Orders.CheckComplete",
      create: (resource) => resource);

  Future<dynamic> orderForceComplete(String? orderId, int code) => requestSync(
      returnBaseEntity: true,
      data: {
        'oid': orderId,
        'code': code,
        'lat': BaseLocationUtil().getLocationData()?.lat,
        'lng': BaseLocationUtil().getLocationData()?.lng
      },
      path: "${BaseNetConst().commonUrl}Rider.Orders.forceComplete",
      create: (resource) => resource);
}
