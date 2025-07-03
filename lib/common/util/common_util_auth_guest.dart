import 'package:djqs/base/ui/base_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonAuthGuestUtil {
  late AuthEntity? authEntity;

  CommonAuthGuestUtil._internal() {
    authEntity = AuthEntity(
        appName: '职记',
        appIcon:
            'https://app-1258783124.cos.ap-beijing.myqcloud.com/res/zhiji_icon_xxhdpi.png',
        cliendId: 'AppConst.APPID_OAUTH');
  }

  factory CommonAuthGuestUtil() => _instance;

  static late final CommonAuthGuestUtil _instance =
      CommonAuthGuestUtil._internal();

  Future auth() async {
    Uri authUri = Uri(
        scheme: authEntity!.scheme,
        path: authEntity!.path,
        queryParameters: authEntity!.toJson());

    if (await canLaunchUrl(authUri)) {
      await launchUrl(authUri);
    } else
      BaseWidgetUtil.showToast('没有安装顺单侠app');
  }
}

class AuthEntity {
  String scheme = 'djsp';
  String path = 'auth';

  String? appName;
  String? appIcon;
  String? cliendId;
  String? code;

  AuthEntity({this.appName, this.appIcon, this.cliendId, this.code});

  AuthEntity.fromJson(Map<String, dynamic> json) {
    appName = json['app_name']?.toString();
    appIcon = json['app_icon']?.toString();
    cliendId = json['client_id']?.toString();
    code = json['code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['app_name'] = appName;
    data['app_icon'] = appIcon;
    data['client_id'] = cliendId;
    data['code'] = code;
    return data;
  }
}
