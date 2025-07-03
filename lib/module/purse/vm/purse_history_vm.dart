import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/widget/data_picker_util.dart';
import 'package:djqs/module/purse/entity/billlist_entity.dart';
import 'package:djqs/module/purse/util/purse_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PurseHistoryVM extends BaseNotifier {
  late final PurseServiceDuo _service = PurseServiceDuo();

  final ValueNotifier<String?> startVN = ValueNotifier<String?>(null);
  final ValueNotifier<String?> endVN = ValueNotifier<String?>(null);
  final ValueNotifier<String?> dayVN = ValueNotifier<String?>(null);
  final ValueNotifier<String?> nowVN = ValueNotifier<String?>(null);
  late DateRangePickerController? dateController;

  double? sumAdd;
  double? sumReduce;

  //
  BillListEntity? billEntity;
  List<NormalListItem>? billData = [];

  PurseHistoryVM(super.context);

  @override
  void init() async {
    dateController = DateRangePickerController();
    billEntity = await _service.getBillList();
    nowVN.value = billEntity?.dateKeyList?[0]?.label;
    billEntity?.dateKeyList?.forEach((BillListEntityDateKeyList? item) {
      billData!.add(NormalListItem(primary: item?.label ?? ''));
    });
    notifyListeners();
  }

  void setSum(double? sumAdd, double? sumReduce) {
    this.sumAdd = sumAdd;
    this.sumReduce = sumReduce;
  }

  @override
  void onResume() {}

  void btn_onPickDate() async {
    BaseDialogUtil.showCommonDialog(baseContext!,
        title: '请选择开始和结束日期',
        contentWidget: Container(
            width: 1.sw,
            height: 200.h,
            child: SfDateRangePicker(
                controller: dateController,
                todayHighlightColor:BaseColors.trans,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3)),
                ))),
        isPopDialog: false,
        onPosBtn: () => _dealWithDate(baseContext!),
        onNagBtn: () => Navigator.pop(baseContext!));
  }

  void _dealWithDate(buildContext) {
    if (ObjectUtil.isEmpty(dateController?.selectedRange?.startDate)) {
      toast('开始日期不能为空！');
      return;
    }
    if (ObjectUtil.isEmpty(dateController?.selectedRange?.endDate)) {
      toast('结束日期不能为空！');
      return;
    }

    Navigator.pop(buildContext);

    startVN.value =
        BaseDateUtil.formatYMDHMS(dateController!.selectedRange!.startDate!);
    endVN.value =
        BaseDateUtil.formatYMDHMS(dateController!.selectedRange!.endDate!);
    nowVN.value =
        '${BaseDateUtil.formatDateTime(startVN.value, format: BaseDateType.YEAR_MONTH_DAY)}至${BaseDateUtil.formatDateTime(endVN.value, format: BaseDateType.YEAR_MONTH_DAY)}';
    dayVN.value = null;
  }

  void btn_onPickBill() async {
    BaseDialogUtil.showListBS(baseContext!,
        title: '账期',
        titleCenter: false,
        topData: billData, onTopItemClick: (buildContext, context, index) {
      dayVN.value = billEntity!.dateKeyList![index]!.label;
      nowVN.value = billEntity!.dateKeyList![index]!.label;
      startVN.value = null;
      endVN.value = null;
      Navigator.pop(buildContext);
    });
  }

  @override
  void onCleared() {}
}
