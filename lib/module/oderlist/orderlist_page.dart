import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/module/home/viewmodel/home_vm.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/order_detail_page.dart';
import 'package:djqs/module/oderlist/util/oder_ui_util.dart';
import 'package:djqs/module/oderlist/util/oder_util.dart';
import 'package:djqs/module/oderlist/vm/order_list_vm.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
  HomeTabData? homeTabData;

  OrderListPage({super.key, required this.homeTabData});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends BasePageState<OrderListPage, OrderListVM> {
  final GlobalKey<AnimatedListState> listkey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    EventBus().on(EventCode.ORDER_ITEM_CHANGE,
        (param) => _dealWithItemAction(param as OrderItemData));
  }

  void _dealWithItemAction(OrderItemData data) {
    if (data?.actionType == OrderItemData.CHANGE_TYPE_UPDATE) {
      _updateItem(data!.index!, data!.orderEntity!);
    } else if (data?.actionType == OrderItemData.CHANGE_TYPE_REMOVE) {
      _removeItem(data!.index!);
    }
  }

  @override
  Widget build(BuildContext context) => buildViewModel<OrderListVM>(
        safeArea: false,
        create: (context) => OrderListVM(context, widget.homeTabData, listkey),
        viewBuild: (context, vm) => Container(color:BaseColors.ebebeb,
          child: vm.isInitLoading
              ? const Center(child: CircularProgressIndicator())
              : vm.data.isEmpty
                  ?const Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('暂无数据'),
                      // BaseGaps().vGap10,
                      // ElevatedButton(
                      //     onPressed: () => vm.loadInitialData(isLoading: true),
                      //     child: Text('重新加载')),
                    ]))
                  : BaseWidgetUtil.getRefreshIndicator(
                      AnimatedList(
                          key: listkey,
                          controller: vm.scrollController,
                          initialItemCount: vm.data.length,
                          itemBuilder: (context, index, animation) =>
                              _buildItem(vm.data[index], animation, index)),
                      onRefresh: vm.pullRefresh),
        ),
      );

  Widget _buildItem(OrderEntity item, Animation<double> animation, int index) {
    if (index == vm.data.length) {
      if (vm.hasError) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ElevatedButton(
              onPressed: () => vm.loadInitialData(isLoading: true),
              child: Text('重试加载'),
            ),
          ),
        );
      }
      if (!vm.hasMore) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: Text('—— 没有更多数据 ——')),
        );
      }
    }
    final orderItemData = OrderItemData(item, index, widget.homeTabData!.listType!);
    return SizeTransition(
        sizeFactor: animation,
        child: OrderUIUtil().getOrderItemView(context, orderItemData,
            onItemClick: _btn_onItemClick));
  }

  void _btn_onItemClick(OrderItemData data) async {
    if (vm.homeTabData!.listType != OrderListEntity.LIST_TYPE_NEW) {
      OrderItemData result = await BaseRouteUtil.push(
          context, OrderDetailPage(orderItemData: data));
      _dealWithItemAction(result);
    }
  }

  void _updateItem(int index, OrderEntity entity) =>
  safeSetState(()=> vm.data[index] = entity);

  void _removeItem(int index) async {
    await Future.delayed(Duration(milliseconds: 400));
    final removedItem = vm.data.removeAt(index);
    listkey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation, index),
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
