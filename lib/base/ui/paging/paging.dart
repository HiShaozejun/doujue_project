// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, non_constant_identifier_names

import 'package:djqs/base/util/util_log.dart';
import 'package:flutter/material.dart';

import 'paging_data.dart';
import 'status_controller.dart';
import 'status_widget.dart';

/// @description 分页加载工具
class Paging<T> {
  static const String _TAG = "Paging";

  int _page = 0;
  bool _isDispose = false;

  //
  List<T> data;
  int? pageSize;
  int initPage;
  Function notify;
  StatusController statusController;
  ScrollController scrollController;

  Paging({
    required this.data,
    required this.initPage,
    required this.pageSize,
    required this.notify,
    required this.statusController,
    required this.scrollController,
  }) {
    _page = initPage;
  }

  static Paging<T> build<T>(
      {required ChangeNotifier notifier,
      List<T>? data,
      int? initPage,
      int? pageSize,
      StatusController? statusController,
      ScrollController? scrollController}) {
    return Paging(
        data: data ?? [],
        initPage: initPage ?? 0,
        pageSize: pageSize,
        notify: notifier.notifyListeners,
        statusController: statusController ??
            StatusController(pageStatus: PageStatus.loading),
        scrollController: scrollController ?? ScrollController());
  }

  void requestData(LoadStatus status,
      Future<PagingData<T>> Function(int) requestBlock,{Function(dynamic?)? onAnimatedInsert,Function()? onAnimatedRemove}) async {
    if (status == LoadStatus.refresh) {
      _page = initPage;
    } else if (status == LoadStatus.loadMore) {
      ++_page;
    } else {
      // reload直接复用page , 如果_page == initPage代表首页数据为缓存直接递增至第二页
      if (_page == initPage) ++_page;
    }

    requestBlock(_page).then((response) {
      if (_isDispose) return;
      requestDataComplete(status, response);
      if (_page == initPage) {
        if (response.getDataSource() == null ||
            response.getDataSource()!.isEmpty) {
          onAnimatedRemove?.call();
          data.clear();
          statusController.pageEmpty();
          notify();
          return;
        }

        // 加载首页数据
        onAnimatedRemove?.call();
        data.clear();
        onAnimatedInsert?.call(response.getDataSource()!);
        data.addAll(response.getDataSource()!);
        statusController.pageComplete();

        if (_page == _getTotalPage(response.getDataTotalCount()) ||
            response.getDataTotalCount() == 1 ||
            response.getDataSource() == null) {
          statusController.itemComplete();
        } else {
          statusController.itemLoading();
        }
        notify();
        return;
      }

      if (_page < _getTotalPage(response.getDataTotalCount())) {
        if (response.getDataSource() == null)
          statusController.itemComplete();
        else {
          onAnimatedInsert?.call(response.getDataSource()!);
          data.addAll(response.getDataSource()!);
          statusController.itemLoading();
        }
        notify();

        return;
      }

      if (_page == _getTotalPage(response.getDataTotalCount())) {
        onAnimatedInsert?.call(response.getDataSource()!);
        data.addAll(response.getDataSource()!);
        statusController.itemComplete();
        notify();
        return;
      }

      notify();
    }).catchError((onError) {
      if (_isDispose) return;
      BaseLogUtil().e(onError);
      submitFailed();
    });
  }

  int _getTotalPage(int dataTotal) => dataTotal % pageSize! == 0
      ? dataTotal ~/ pageSize!
      : (dataTotal ~/ pageSize! + 1);

  void requestDataComplete(LoadStatus status, PagingData<T> data) {}

  void submitFailed() {
    // 当前列表数据加载成功，分页item不是最后一项，且数据不为空则显示itemError状态
    if (statusController.pageStatus == PageStatus.completed &&
        statusController.itemStatus != ItemStatus.end &&
        data.isNotEmpty) {
      statusController.itemError();
      // 当前列表数据未加载成功，且数据为空
    } else if (statusController.pageStatus != PageStatus.completed &&
        data.isEmpty) {
      statusController.pageError();
    }
    notify();
  }

  void notifyDataChange() {
    if (data.isEmpty) {
      statusController.pageEmpty();
    } else {
      statusController.pageComplete();
    }
    notify();
  }

  void dispose() {
    _isDispose = true;
    statusController.dispose();
    scrollController.dispose();
    data.clear();
  }
}
