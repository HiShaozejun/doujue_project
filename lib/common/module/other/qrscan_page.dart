// import 'package:djqs/base/frame/base_pagestate.dart';
// import 'package:djqs/base/res/base_colors.dart';
// import 'package:djqs/base/ui/base_widget.dart';
// import 'package:djqs/common/module/other/entity/qrcode_entity.dart';
// import 'package:djqs/common/module/other/viewmodel/qrscan_vm.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:scan/scan.dart';
//
// class QrScanPage extends StatefulWidget {
//   final Function(QrcodeEntity qrEntity,
//       {Function(bool? close, bool? restart)? callback})? onDeal;
//
//   QrScanPage({this.onDeal});
//
//   @override
//   _QrScanPageState createState() => _QrScanPageState();
// }
//
// class _QrScanPageState extends BasePageState<QrScanPage, QrScanVM> {
//   @override
//   void initState() {}
//
//   @override
//   Widget build(BuildContext context) => buildViewModel<QrScanVM>(
//       appBar: BaseWidgetUtil.getAppbar(context, '扫一扫'),
//       create: (context) => QrScanVM(context, widget.onDeal),
//       viewBuild: (context, vm) => Stack(children: [
//             ScanView(
//                 controller: vm.controller,
//                 scanLineColor: BaseColors.f96b56,
//                 onCapture: vm.dealWithScan),
//             Positioned(
//                 left: 50,
//                 bottom: 20,
//                 child: MaterialButton(
//                     child: Icon(vm.isFlash ? Icons.flash_off : Icons.flash_on,
//                         color: BaseColors.e70012, size: 30.r),
//                     onPressed: vm.btn_onChangeFlash)),
//             Positioned(
//                 right: 50,
//                 bottom: 20,
//                 child: MaterialButton(
//                     child:
//                         Icon(Icons.image, color: BaseColors.e70012, size: 30.r),
//                     onPressed: vm.btn_onPick))
//           ]));
// }
