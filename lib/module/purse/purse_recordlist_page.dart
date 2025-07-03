import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/ui/base_listview.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/ui/paging/paging_data.dart';
import 'package:djqs/module/purse/util/purse_util.dart';
import 'package:djqs/module/purse/vm/purse_recordlist_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurseRecordListPage extends StatefulWidget {
  final ValueNotifier<String?>? startVN;
  final ValueNotifier<String?>? endVN;
  final ValueNotifier<String?>? dayVN;

  final Function(double? sumAdd, double? sumReduce)? callback;

  PurseRecordListPage(
      {super.key,
      required this.startVN,
      required this.endVN,
      this.dayVN,
      this.callback});

  @override
  _PurseRecordListState createState() => _PurseRecordListState();
}

class _PurseRecordListState extends BasePageState<PurseRecordListPage, PurseRecordListVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<PurseRecordListVM>(
      create: (context) => PurseRecordListVM(
          context, widget.startVN, widget.endVN, widget.dayVN, widget.callback),
      viewBuild: (context, vm) => Container(
          child: BaseWidgetUtil.getRefreshIndicator(_listView(),
              onRefresh: () async {
            vm.loadData(isRerfesh: true);
            await Future.delayed(const Duration(milliseconds: 100));
          })));

  Widget _listView() => BaseListView(
      statusController: vm.paging!.statusController,
      scrollController: vm.paging!.scrollController,
      itemCount: vm.paging?.data.length ?? 0,
      onPageReload: () => vm.requestData(LoadStatus.refresh),
      onItemReload: () => vm.requestData(LoadStatus.reload),
      onLoadMore: () => vm.requestData(LoadStatus.loadMore),
      itemBuilder: (BuildContext context, int index) {
        return PurseUtil.getPurseItemView(vm.paging!.data[index]);
      });
}
