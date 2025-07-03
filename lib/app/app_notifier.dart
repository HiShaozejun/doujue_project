import 'dart:async';

import 'package:djqs/app/app_const.dart';
import 'package:djqs/app/app_socket.dart';
import 'package:djqs/base/frame/base_global_notifier.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/module/login/util/util_account.dart';

class AppNotifier extends BaseGlobalNotifier {
  late final _service = AppService();
  late final AppSocket appSocket=AppSocket.getInstance();
  Timer? _locationTimer;

  AppNotifier(super.context);

  @override
  void init() {}

  void startLocation() {
    BaseLocationUtil().startLocation();
    _uploadLocationLoop();
  }

  void _uploadLocationLoop() {
    if (AccountUtil().isHasLogin == false) return;
    _uploadLocation();
    _locationTimer = Timer.periodic(
        Duration(seconds: AppConst.INTERVAL_UPLOAD_LOCATION), (timer) {
      _uploadLocation();
    });
  }

  void _uploadLocation() {
    if (AccountUtil().isHasLogin) {
      if (!ObjectUtil.isEmptyStr(BaseLocationUtil().getLocationData()?.lat))
        _service.uploadLocation(BaseLocationUtil().getLocationData()?.lat,
            BaseLocationUtil().getLocationData()?.lng);
    }
  }

  void stopLocation() {
    BaseLocationUtil().stopLocation();
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  void dispose() {
    stopLocation();
    super.dispose();
  }
}

class AppService extends BaseService {
  Future<dynamic> uploadLocation(latitude, longitude) => requestSync(
      showLoading: false,
      data: {'lat': latitude, 'lng': longitude},
      path: "${BaseNetConst().commonUrl}Rider.Location.Set",
      create: (resource) => resource);
}
