// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:djqs/app/app_icondata.dart';
// import 'package:djqs/base/frame/base_pagestate.dart';
// import 'package:djqs/base/res/base_colors.dart';
// import 'package:djqs/base/res/base_gaps.dart';
// import 'package:djqs/base/res/base_icons.dart';
// import 'package:djqs/base/ui/base_ui_util.dart';
// import 'package:djqs/base/ui/base_widget.dart';
// import 'package:djqs/base/util/util_object.dart';
// import 'package:djqs/common/module/login/util/util_account.dart';
// import 'package:djqs/module/tiktok_play/entity/tt_bundle_data.dart';
// import 'package:djqs/module/tiktok_play/entity/tt_detail_entity.dart';
// import 'package:djqs/module/tiktok_play/util/tt_play_util.dart';
// import 'package:djqs/module/tiktok_play/widget/tt_play_list.dart';
//
// import 'util/search_const.dart';
// import 'viewmodel/search_vm.dart';
//
// class SearchPage extends StatefulWidget {
//   final int? sourceType;
//   final int? sourceSubType;
//
//   SearchPage({super.key, this.sourceType, this.sourceSubType});
//
//   @override
//   _SearchState createState() => _SearchState();
// }
//
// class _SearchState extends BasePageState<SearchPage, SearchVM> {
//   late final SearchVM? searchVM;
//
//   @override
//   void initState() {
//     super.initState();
//     searchVM = SearchVM(context, widget.sourceType, widget.sourceSubType);
//     // searchWV = BaseWebViewPage(
//     //     url: searchVM!.getSearchH5(),
//     //     wvBundleData: BaseWVBundleData(data: searchVM!.searchKey),
//     //     showHeader: false);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   Widget build(BuildContext context) => buildViewModel<SearchVM>(
//       create: (context) => searchVM!,
//       viewBuild: (context, vm) => Container(
//           padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
//           child: Column(children: [
//             _searchBarView(),
//             BaseGaps().vGap10,
//             ObjectUtil.isEmptyStr(vm.searchKey)
//                 ? _noSearchListView()
//                 : Expanded(
//                     child: TTPlayList(
//                         onRefresh: (int page) => vm.loadData(page),
//                         onPlay: (TTDetailEntity entity) => TTPlayUtil()
//                             .gotoTTPlay(
//                                 entity,
//                                 TTPlayBundleData.SOURCE_TYPE_SEARCH,
//                                 AccountUtil().getAccount()?.uid.toString(),
//                                 sourceSubType: widget?.sourceSubType)))
//           ])));
//
//   Widget _searchBarView() =>
//       Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//         InkWell(
//             onTap: vm.btn_onBack,
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(0, 5.w, 5.w, 5.w),
//               child: Icon(BaseIcons.iconXiangzuo,
//                   color: BaseUIUtil().getThemeColor(BaseColors.c161616),
//                   size: 16.w),
//             )),
//         BaseGaps().hGap10,
//         Expanded(
//             child: TextField(
//           controller: vm.textController,
//           autofocus: false,
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             isCollapsed: true,
//             prefixIcon: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.w),
//                 child: Icon(AppIcons.iconSousuo,
//                     size: 12.r, color: BaseColors.c4f4f4f)),
//             suffixIcon: Offstage(
//               offstage: vm.textController.text == '',
//               child: InkWell(
//                 onTap: vm.btn_onDeleteIntput,
//                 child: Icon(AppIcons.iconGuanbi,
//                     size: 14.r, color: BaseColors.c4f4f4f),
//               ),
//             ),
//             prefixIconConstraints: BoxConstraints(),
//             contentPadding: EdgeInsets.symmetric(vertical: 10.h),
//             labelText: '',
//             hintText: '输入关键字',
//             filled: true,
//           ),
//           textInputAction: TextInputAction.done,
//         )),
//         BaseGaps().hGap10,
//         InkWell(
//             onTap: vm.btn_onSearch,
//             child: Text('搜索',
//                 style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium))
//       ]);
//
//   Widget _noSearchListView() => Column(children: [
//         _historyListView(),
//         if ((vm.historyData?.length ?? 0) >
//             SearchConst.LIMIT_SEACH_HISTORY_SHOW)
//           _historyBottomView(),
//         BaseGaps().vGap15,
//         _hotView_top(),
//         BaseGaps().vGap10,
//         _hotView()
//       ]);
//
//   Widget _historyListView() => ListView.builder(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: vm.getHistoryShowData()?.length ?? 0,
//       itemBuilder: (context, index) {
//         return BaseWidgetUtil.getHorizontalListItem(
//             index,
//             NormalListItem(
//                 primary: vm.getHistoryShowData()?[index].text ?? '',
//                 rightType: ItemType.IMG,
//                 prefixIconData: Icons.history_outlined,
//                 suffixChild: Icon(AppIcons.iconGuanbi,
//                     color: BaseColors.c4f4f4f, size: 16.r)),
//             itemVPadding: 8.h,
//             onItemClick: () => vm.btn_onHistoryItemClick(index),
//             onItemRightClick: () => vm.btn_onHistoryItemDelete(index));
//       });
//
//   Widget _historyBottomView() => Column(children: [
//         BaseGaps().vGap5,
//         InkWell(
//             onTap: vm.isShowAllHistory
//                 ? vm.btn_onClearAllHistory
//                 : vm.btn_onShowAllHistory,
//             child: Text(vm.isShowAllHistory ? '清除全部搜索记录' : '全部搜索记录',
//                 style: BaseUIUtil().getTheme().primaryTextTheme.bodyMedium)),
//         BaseGaps().vGap10,
//         Divider(thickness: 1.h)
//       ]);
//
//   Widget _hotView_top() =>
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Text(
//           vm.hotListEntity?.hotWords?[0].name ?? '',
//           style: BaseUIUtil().getTheme().primaryTextTheme.displayLarge,
//         )
//       ]);
//
//   Widget _hotView() => GridView.builder(
//       itemCount: vm.hotListEntity?.hotWords?[0]?.submenu?.length ?? 0,
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 5,
//       ),
//       itemBuilder: (context, index) {
//         return BaseWidgetUtil.getHorizontalListItem(
//             index,
//             NormalListItem(
//                 primary:
//                     vm.hotListEntity?.hotWords?[0].submenu?[index]?.name ?? ''),
//             itemVPadding: 0.0,
//             onItemClick: () => vm.btn_onHotItemClick(index));
//       });
// }
