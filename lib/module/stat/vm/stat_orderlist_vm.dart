import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/order_detail_page.dart';
import 'package:djqs/module/oderlist/util/oder_util.dart';
import 'package:djqs/module/stat/util/stat_service.dart';
import 'package:flutter/material.dart';

class StatOrderListVM extends BaseNotifier {
  TabController? tabController;
  ScrollController? scrollController;

  late final StatService _service = StatService();
  OrderListEntity? listEntity;

  StatOrderListVM(super.context);

  @override
  void init() {}

  void initTabController(TickerProvider provider) {
    scrollController = ScrollController();
    tabController = TabController(length: 2, vsync: provider!, initialIndex: 0);
    tabController?.addListener(() {
      if (!tabController!.indexIsChanging) {
        scrollController!.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _refresh();
      }
    });
  }

  void _refresh() async {
    listEntity = await _service.getOrderList(tabController?.index ?? 0);
    notifyListeners();
  }

  void btn_onItemClick(OrderEntity? item) =>
      pagePush(OrderDetailPage(orderItemData: OrderItemData(item, null, null)));

  @override
  void onResume() async => _refresh();

  void btn_onListItemClick(OrderEntity? item) async {}

  @override
  void onCleared() {
    tabController?.dispose();
  }
}
