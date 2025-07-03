import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/module/other/entity/qrcode_entity.dart';
import 'package:djqs/module/mine/entity/scan_info_entity.dart';

class ScanInfoVM extends BaseNotifier {
  final QrcodeEntity? qrEntity;

  late final _service = ScanService();

  ScanInfoEntity? scanData;
  String? dataStr;

  ScanInfoVM(super.context, this.qrEntity);

  @override
  void init() => refreshData();

  void refreshData() async {
    if (!ObjectUtil.isEmpty(qrEntity)) {
      scanData = await _service.getScanInfo(qrEntity!.uid!.toString());
      if (!ObjectUtil.isEmptyStr(scanData?.createtime))
        dataStr = BaseDateUtil.getDateStrByTimeStr(scanData!.createtime!,
            format: BaseDateType.ZH_YEAR_MONTH_DAY);
      notifyListeners();
    }
  }

  @override
  void onCleared() {}
}

class ScanService extends BaseService {
  Future<ScanInfoEntity?> getScanInfo(String uid) => requestSync(
      showLoading: false,
      data: {'uid': uid},
      path: "${BaseNetConst().passportUrl}/user/scan-info",
      create: (resource) => ScanInfoEntity.fromJson(resource));
}
