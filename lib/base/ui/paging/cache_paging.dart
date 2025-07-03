// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:djqs/base/extensions/function_extensions.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/ui/paging/status_widget.dart';
import 'package:djqs/base/util/util_sharepref.dart';
import 'package:flutter/material.dart';

import 'paging.dart';
import 'paging_data.dart';
import 'status_controller.dart';

/// @description 支持首页缓存的分页加载工具
class CachePaging<T> extends Paging<T> {
  final String _localKey;
  final CreateJson<PagingData<T>> _createJson;
  bool _initRequest = true;

  CachePaging(
      {required String localKey,
      required PagingData<T> Function(Map<String, dynamic>) createJson,
      required super.data,
      required super.initPage,
      required super.pageSize,
      required super.notify,
      required super.statusController,
      required super.scrollController})
      : _createJson = createJson,
        _localKey = localKey;

  static CachePaging<T> build<T>(
      {required ChangeNotifier notifier,
      required String localKey,
      required CreateJson<PagingData<T>> createJson,
      List<T>? data,
      int? initPage,
      int? pageSize,
      StatusController? statusController,
      ScrollController? scrollController}) {
    return CachePaging(
        localKey: localKey,
        createJson: createJson,
        data: data ?? [],
        initPage: initPage ?? 0,
        pageSize: pageSize ?? BaseNetConst.PAGE_SIZE,
        notify: notifier.notifyListeners,
        statusController: statusController ??
            StatusController(pageStatus: PageStatus.loading),
        scrollController: scrollController ?? ScrollController());
  }

  @override
  void requestData(
      LoadStatus status, Future<PagingData<T>> Function(int) requestBlock,
      {Function(dynamic?)? onAnimatedInsert,Function()? onAnimatedRemove}) async {
    // 首次请求刷新使用缓存数据 + 网络数据填充
    if (_initRequest && status == LoadStatus.refresh) {
      _initRequest = false;

      // 获取缓存数据
      var localData =
          await BaseSPUtil().getCache(_localKey, (json) => _createJson(json));

      // 校验缓存数据
      if (localData != null && localData.getDataSource()!.isNotEmpty) {
        data.addAll(localData.getDataSource()!);
        notifyDataChange();
      }
    }
    // 网络请求
    super.requestData(status, requestBlock);
  }

  @override
  void requestDataComplete(LoadStatus status, PagingData<T> data) {
    // 首页数据缓存
    if (status == LoadStatus.refresh && data.getDataSource()!.isNotEmpty) {
      BaseSPUtil().putEntity(_localKey, data);
    }
  }
}
