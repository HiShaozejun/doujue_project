import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/module/oderlist/util/oder_ui_util.dart';
import 'package:djqs/module/stat/util/stat_util.dart';
import 'package:djqs/module/stat/vm/stat_orderlist_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatOrderPage extends StatefulWidget {
  StatOrderPage({super.key});

  @override
  _StatDetailState createState() => _StatDetailState();
}

class _StatDetailState extends BasePageState<StatOrderPage, StatOrderListVM>
    with TickerProviderStateMixin {
  late final StatOrderListVM? statVM;

  @override
  void initState() {
    super.initState();
    statVM = StatOrderListVM(context);
    statVM?.initTabController(this);
  }

  @override
  Widget build(BuildContext context) => buildViewModel<StatOrderListVM>(
      create: (context) => statVM!,
      viewBuild: (context, vm) => Container(
            alignment: Alignment.center,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              BaseGaps().vGap10,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text('订单明细',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: BaseDimens.fw_l,
                        color: BaseColors.c161616)),
              ),
              BaseGaps().vGap5,
              StatUtil.getTabbar(
                  statVM?.tabController, context, ['全部', '已完成']),
              Expanded(child: OrderUIUtil().getHistoryListView(vm.listEntity,vm.scrollController,vm.btn_onItemClick))
            ]),
          ));
}
