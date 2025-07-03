import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/ui/paging/paging.dart';
import 'package:djqs/base/ui/paging/paging_data.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/purse/entity/purse_today_entity.dart';
import 'package:djqs/module/purse/util/purse_service.dart';
import 'package:flutter/material.dart';

class PurseRecordListVM extends BaseNotifier {
  final Function(double? sumAdd, double? sumReduce)? callback;

  late final PurseService _service = PurseService();
  Paging<PurseItemEntity>? paging;
  final ValueNotifier<String?>? startVN;
  final ValueNotifier<String?>? endVN;
  final ValueNotifier<String?>? dayVN;

  PurseRecordListVM(
      super.context, this.startVN, this.endVN, this.dayVN, this.callback);

  @override
  void init() {
    paging = Paging.build(
        notifier: this, initPage: 1, pageSize: BaseNetConst.PAGE_SIZE);
    startVN?.addListener(_onTimeVNChang);
    loadData(isRerfesh: true);
  }

  void _onTimeVNChang() {
    loadData(isRerfesh: true);
  }

  void requestData(LoadStatus status) {
    paging!.requestData(status, (page) async {
      dynamic? value = await await _service.getPurseRecord(page,
          startTime: startVN!.value,
          endTime: endVN!.value,
          dayKey: dayVN!.value);
      return value;
    });

    Future.delayed(Duration(milliseconds: 1000), () async {
      if (callback != null) caculateSum();
    });
  }

  //to-do
  void caculateSum() {
    double sumAdd = 0;
    double sumReduce = 0;
    paging?.data?.forEach((item) {
      if (item?.type == PurseItemEntity.PUSER_TYPE_ADD)
        sumAdd = sumAdd + double.parse(ObjectUtil.strToZero(item?.total));
      if (item?.type == PurseItemEntity.PUSER_TYPE_REDUCE)
        sumReduce = sumReduce + double.parse(ObjectUtil.strToZero(item?.total));
    });
    callback?.call(sumAdd, sumReduce);
  }

  @override
  void onResume() {
  }

  void loadData({bool isRerfesh = true}) {
    if (isRerfesh) {
      if (paging?.scrollController?.hasClients == true)
        paging!.scrollController.jumpTo(0);
    }
    requestData(LoadStatus.refresh);
  }

  @override
  void onCleared() {
    startVN?.removeListener(_onTimeVNChang);
    endVN?.removeListener(_onTimeVNChang);
    dayVN?.removeListener(_onTimeVNChang);
  }
}
