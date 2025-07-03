import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/module/purse/purse_recordlist_page.dart';
import 'package:djqs/module/purse/vm/purse_history_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurseHistoryPage extends StatefulWidget {
  PurseHistoryPage({super.key});

  @override
  _PurseHistoryState createState() => _PurseHistoryState();
}

class _PurseHistoryState
    extends BasePageState<PurseHistoryPage, PurseHistoryVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<PurseHistoryVM>(
      appBar: BaseWidgetUtil.getAppbar(context, "历史账单"),
      create: (context) => PurseHistoryVM(context),
      viewBuild: (context, vm) => Container(
            color: BaseColors.f5f5f5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topView(),
                Expanded(
                    child: PurseRecordListPage(
                        startVN: vm.startVN,
                        endVN: vm.endVN,
                        dayVN: vm.dayVN,
                        callback: vm.setSum))
              ],
            ),
          ));

  Widget _topView() => Container(
        color: BaseColors.f5f5f5,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Row(children: [
          Expanded(
            child: Text(vm.nowVN.value ?? '',
                style: BaseUIUtil().getTheme().primaryTextTheme.displaySmall),
          ),
          BaseWidgetUtil.getTextWithWidgetH('选择账期',
              isLeft: false,
              space: 3.w,
              paddingV: 2.h,
              primaryStyle:
                  BaseUIUtil().getTheme().primaryTextTheme.displaySmall,
              minor: Icon(Icons.keyboard_arrow_down, size: 20.w),
              onTap: vm.btn_onPickBill),
          BaseGaps().hGap10,
          BaseWidgetUtil.getTextWithWidgetH('选择日期',
              isLeft: false,
              space: 3.w,
              paddingV: 2.h,
              primaryStyle:
                  BaseUIUtil().getTheme().primaryTextTheme.displaySmall,
              minor: Icon(Icons.keyboard_arrow_down, size: 20.w),
              onTap: vm.btn_onPickDate),
        ]),
      );
}
