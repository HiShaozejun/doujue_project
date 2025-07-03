import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/module/home/viewmodel/home_vm.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/util/orderlist_service.dart';
import 'package:flutter/material.dart';

class OrderListVM extends BaseNotifier {
  GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController = ScrollController();

  HomeTabData? homeTabData;

  final List<OrderEntity> data = [];

  late final _service = OrderListService();

  bool isInitLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool hasError = false;
  int _page = 1;

  OrderListVM(super.context, this.homeTabData, this.listKey);

  @override
  void init() {
    loadInitialData();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore &&
          hasMore) {
        _loadMore();
      }
    });

    EventBus().on(EventCode.ORDER_LIST_REFRESH, (index) {
      if ((index as int) == homeTabData!.index! && baseContext!.mounted) {
        loadInitialData(isLoading: true);
      }
    });
  }

  Future<void> loadInitialData({bool isLoading = false}) async {
    EventBus().send(EventCode.HOME_COUNT_REFRESH);

    _page = 1;
    hasMore = true;
    isInitLoading = true;

    final count = data.length;
    for (int i = count - 1; i >= 0; i--) {
      data?.removeAt(i);
      listKey!.currentState?.removeItem(
          i, (context, animation) => const SizedBox.shrink(),
          duration: Duration.zero);
    }

    final List<OrderEntity>? newItems =
        await _fetchData(_page, isLoading: isLoading);
    if (ObjectUtil.isEmptyList(newItems)) {
      notifyListeners();
      return;
    }
    for (int i = 0; i < newItems!.length; i++) {
      data.insert(i, newItems![i]);
      listKey!.currentState?.insertItem(i, duration: Duration.zero);
    }
    notifyListeners();
  }

  Future<void> pullRefresh() async => await loadInitialData();

  Future<void> _loadMore() async {
    isLoadingMore = true;
    _page++;
    final newItems = await _fetchData(_page, isLoading: true);

    if (newItems?.isEmpty ?? true) {
      hasMore = false;
    } else {
      final startIndex = data.length;
      for (int i = 0; i < newItems!.length; i++) {
        data.add(newItems![i]);
        listKey!.currentState
            ?.insertItem(startIndex + i, duration: Duration(milliseconds: 0));
      }
    }

    isLoadingMore = false;
    notifyListeners();
  }

  Future<List<OrderEntity>?> _fetchData(int page,
      {bool isLoading = false}) async {
    if (!AccountUtil().isHasLogin) return null;
    hasError = false;
    try {
      OrderListEntity result = await _service.getOrderList(
          homeTabData!.listType!,
          page: page,
          isLoading: isLoading);
      isInitLoading = false;
      return result?.list;
    } catch (e) {
      hasError = true;
      isInitLoading = false;
    }
  }

  @override
  void onCleared() {
    scrollController.dispose();
    //EventBus().off(EventCode.ORDER_LIST_REFRESH);
  }
}
