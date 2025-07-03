import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/module/stat/entity/stat_month_entity.dart';
import 'package:djqs/module/stat/entity/state_today_entity.dart';
import 'package:djqs/module/stat/util/stat_service.dart';

class StatOrderVM extends BaseNotifier {
  late final StatService _service = StatService();
  late final List<NormalListItem> todayGridData = [];
  StatTodayEntity? statTodayEntity;
  List<StatMonthEntity>? monthListData = [];

  StatOrderVM(super.context);

  @override
  void init() {
    todayGridData.add(NormalListItem(primary: '完成订单'));
    todayGridData.add(NormalListItem(primary: '转单'));
    todayGridData.add(NormalListItem(primary: '已抢订单'));
    todayGridData.add(NormalListItem(primary: '配送里程'));
  }

  @override
  void onResume() async {
    statTodayEntity = (await _service.getStatTodayData())?[0];
    monthListData = await _service.getStatMonthList();

    todayGridData[0].minor = statTodayEntity?.orders;
    todayGridData[1].minor = statTodayEntity?.trans;
    todayGridData[2].minor = statTodayEntity?.graps;
    todayGridData[3].minor =
        AppUtil().getDistance(statTodayEntity?.distance)[0];
    notifyListeners();
  }

  @override
  void onCleared() {}
}
