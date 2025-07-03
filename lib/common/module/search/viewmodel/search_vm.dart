// import 'package:flutter/material.dart';
// import 'package:djqs/base/event/event_bus.dart';
// import 'package:djqs/base/event/event_code.dart';
// import 'package:djqs/base/frame/base_notifier.dart';
// import 'package:djqs/base/ui/base_ui_util.dart';
// import 'package:djqs/base/util/util_object.dart';
// import 'package:djqs/common/module/search/entity/search_history_data.dart';
// import 'package:djqs/common/module/search/entity/search_hotlist_entity.dart';
// import 'package:djqs/common/module/search/util/search_const.dart';
// import 'package:djqs/common/module/search/util/search_db_util.dart';
// import 'package:djqs/common/module/search/util/search_service.dart';
//
// class SearchVM extends BaseNotifier {
//   final int? sourceType;
//   final int? sourceSubType;
//
//   late final SearchService _service;
//   late final TextEditingController textController;
//   late final TabController tabController;
//   late final SearchDBUtil? _searchDBUtil;
//
//   String? searchKey;
//   SearchHotListEntity? hotListEntity;
//   List<SearchHistoryData>? historyData;
//   bool isShowAllHistory = false;
//
//   final TTPlayService _ttService = TTPlayService();
//
//   SearchVM(super.context, this.sourceType, this.sourceSubType);
//
//   @override
//   void init() async {
//     textController = TextEditingController();
//     textController.addListener(() {
//       notifyListeners();
//     });
//     //
//     _service = SearchService();
//     hotListEntity = await _service.getHotList();
//     notifyListeners();
//     //
//     _searchDBUtil = await SearchDBUtil();
//     await _searchDBUtil?.open();
//     _searchDBUtil?.addListener(() => refreshHistoryData());
//     refreshHistoryData();
//   }
//
//   void refreshHistoryData() {
//     historyData = _searchDBUtil?.getAll();
//     notifyListeners();
//   }
//
//   List<SearchHistoryData>? getHistoryShowData() {
//     if (isShowAllHistory ||
//         (historyData?.length ?? 0) < SearchConst.LIMIT_SEACH_HISTORY_SHOW)
//       return historyData;
//     else
//       return historyData?.sublist(0, SearchConst.LIMIT_SEACH_HISTORY_SHOW);
//   }
//
//   // Future.delayed(Duration(seconds: 1), () {
//   //   EventBus().send(EventCode.WEBVIEW_RELOAD,
//   //       BaseWVBundleData(url: getSearchH5(), data: str));
//   // });
//   void _refreshSearch(String? str) async {
//     if (str == null) return;
//     BaseUIUtil().hideKeyboardWithUnfocus();
//     searchKey = str;
//     textController.text = str;
//     if (!ObjectUtil.isEmptyStr(str)) {
//       await _searchDBUtil!.addHistroy(SearchHistoryData(text: str));
//       EventBus().send(EventCode.PLAYLIST_REFRESH);
//       notifyListeners();
//     } else
//       notifyListeners();
//   }
//
//   Future loadData(int page) async => _ttService.getSearchList(searchKey ?? '',
//       sourceType: sourceType, sourceSubType: sourceSubType, page: page);
//
//   void btn_onDeleteIntput() => _refreshSearch('');
//
//   void btn_onSearch() {
//     if (ObjectUtil.isEmptyStr(textController.text)) {
//       toast('请输入关键字');
//       return;
//     }
//     _refreshSearch(textController.text);
//   }
//
//   void btn_onShowAllHistory() {
//     isShowAllHistory = true;
//     notifyListeners();
//   }
//
//   void btn_onClearAllHistory() => _searchDBUtil?.clear();
//
//   void btn_onHistoryItemClick(int index) =>
//       _refreshSearch(historyData?[index].text);
//
//   void btn_onHistoryItemDelete(index) => _searchDBUtil?.delete(index);
//
//   void btn_onHotItemClick(int index) =>
//       _refreshSearch(hotListEntity?.hotWords?[0].submenu?[index].name);
//
//   @deprecated
//   void btn_onGuessItemClick(index) {}
//
//   @override
//   void onCleared() {
//     _searchDBUtil?.close();
//   }
// }
