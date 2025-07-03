import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_sharepref.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:permission_handler/permission_handler.dart';

class BasePermissionUtil {
  static const String REQUEST_REQUEST_SHOW = "sp_permission_requet";
  static const String REQUEST_REQUEST_AGAIN =
      "sp_permission_requet_again"; //permanent只提示一次

  List<PermissionData> permissionData = [];

  factory BasePermissionUtil() => _instance;
  static late final BasePermissionUtil _instance =
      BasePermissionUtil._internal();

  BasePermissionUtil._internal() {
    permissionData.add(PermissionData('定位', '用于获取您的位置提供距离显示等服务', 0));
    permissionData.add(PermissionData('存储', '用于存储相关功能', 1));
    permissionData.add(PermissionData('相机', '用于拍照等相关功能', 2));
    permissionData.add(PermissionData('麦克风', '用于声音相关功能', 3));
  }

  void requestLocatePermission(Function() callback,
          {String? perDesc, bool? alwaysShowDenyMsg}) =>
      _checkPermission(permissionData[0],
          perDesc: perDesc,
          alwaysShowDenyMsg: alwaysShowDenyMsg,
          permission: Permission.location,
          permissionList: [Permission.location],
          callback: ({bool? isFirst}) => callback.call());

  void requestSDPermission(Function() callback,
          {String? perDesc, bool? alwaysShowDenyMsg}) =>
      _checkPermission(permissionData[1],
          perDesc: perDesc,
          alwaysShowDenyMsg: alwaysShowDenyMsg,
          permission: Permission.storage,
          permissionList: [
            Permission.storage,
            Permission.manageExternalStorage
          ],
          callback: ({bool? isFirst}) => callback.call());

  void requestCameraPermission(Function() callback,
          {String? perDesc, bool? alwaysShowDenyMsg}) =>
      _checkPermission(permissionData[2],
          perDesc: perDesc,
          alwaysShowDenyMsg: alwaysShowDenyMsg,
          permission: Permission.camera,
          permissionList: [Permission.camera],
          callback: ({bool? isFirst}) => callback.call());
  

  void requestMicPermission(Function() callback,
          {String? perDesc, bool? alwaysShowDenyMsg}) =>
      _checkPermission(permissionData[3],
          perDesc: perDesc,
          alwaysShowDenyMsg: alwaysShowDenyMsg,
          permission: Permission.microphone,
          permissionList: [Permission.microphone],
          callback: ({bool? isFirst}) => callback.call());

  void _checkPermission(PermissionData perData,
      {String? perDesc,
      Permission? permission,
      bool? alwaysShowDenyMsg,
      List<Permission>? permissionList,
      Function({bool? isFirst})? callback,
      Function()? callbackNo}) async {
    PermissionStatus? status = await permission!.status;

    if (status!.isGranted) {
      callback?.call(isFirst: false);
      return;
    } else if (status.isPermanentlyDenied) {
      if (BaseSystemUtil().isAndroid &&
          getValue(REQUEST_REQUEST_AGAIN, perData))
        BaseWidgetUtil.showToast('您已拒绝授权，请去设置中去开${perData.text}权限');
      setValue(REQUEST_REQUEST_AGAIN, perData);
      callbackNo?.call();
      return;
    }

    if (BaseSystemUtil().isAndroid && getValue(REQUEST_REQUEST_SHOW, perData))
      BaseWidgetUtil().showSnackbar(
          '${perData.text!}权限使用说明：\n${perDesc ?? perData.defaultDesc!}');
    //
    Map<Permission, PermissionStatus> permissionMap =
        await permissionList!.request();
    if (permissionMap[permission]!.isGranted) {
      setValue(REQUEST_REQUEST_SHOW, perData);
      callback?.call(isFirst: true);
    } else {
      setValue(REQUEST_REQUEST_SHOW, perData);
      //拒绝后每次执行
      if (alwaysShowDenyMsg == true)
        BaseWidgetUtil.showToast('您已拒绝授权，请去设置中去开启${perData.text}权限才能正常使用该功能');
      callbackNo?.call();
      return;
    }
  }

  bool getValue(String key, PermissionData perData) =>
      BaseSPUtil().getBool(key + perData.id!.toString(), defValue: true);

  void setValue(String key, PermissionData perData) =>
      BaseSPUtil().putBool(key + perData.id!.toString(), false);
}

class PermissionData {
  String? text;
  String? defaultDesc;
  int? id;

  PermissionData(this.text, this.defaultDesc, this.id);
}
