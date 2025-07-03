// import 'dart:convert';
//
// import 'package:djqs/base/frame/base_notifier.dart';
// import 'package:djqs/base/ui/base_widget.dart';
// import 'package:djqs/base/util/util_encrypt.dart';
// import 'package:djqs/base/util/util_image.dart';
// import 'package:djqs/base/util/util_object.dart';
// import 'package:djqs/common/module/other/entity/qrcode_entity.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:scan/scan.dart';
//
// class QrScanVM extends BaseNotifier {
//   final Function(QrcodeEntity qrStr,
//       {Function(bool? close, bool? restart)? callback})? onDeal;
//
//   late final ScanController controller = ScanController();
//
//   bool isFlash = false;
//
//   QrScanVM(super.context, this.onDeal);
//
//   @override
//   void init() async {}
//
//   void btn_onChangeFlash() {
//     isFlash = !isFlash;
//     notifyListeners();
//     controller.toggleTorchMode();
//   }
//
//   void btn_onPick() async {
//     XFile? file =
//         await BaseImageUtil().gotoPickImage(source: ImageSource.gallery);
//     if (file != null)
//       dealWithScan(await Scan.parse(file.path));
//     else
//       BaseWidgetUtil.showToast('图片出错');
//   }
//
//   void dealWithScan(String? result) {
//     controller.pause();
//     _dealWithError(result);
//     try {
//       String str = BaseEncryptUtil.decryptAES(result);
//       _dealWithError(str);
//       QrcodeEntity entity = QrcodeEntity.fromJson(jsonDecode(str));
//       onDeal?.call(entity, callback: (bool? close, bool? restart) {
//         if (close == true) pagePop(params: entity);
//         if (restart == true) controller.resume();
//       });
//     } catch (e) {
//       _dealWithError(null);
//       e.toString();
//     }
//   }
//
//   void _dealWithError(String? str) {
//     if (ObjectUtil.isEmpty(str)) {
//       BaseWidgetUtil.showToast('请扫描正确的二维码！');
//       controller.resume();
//       return;
//     }
//   }
//
//   @override
//   void onCleared() {}
//
//   @override
//   void onResume() {
//     controller.resume();
//   }
// }
