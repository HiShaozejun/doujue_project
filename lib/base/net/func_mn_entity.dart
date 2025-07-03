// import 'package:djqs/base/net/base_net_const.dart';
// import 'package:djqs/base/net/func_ab_entity.dart';
// import 'package:djqs/base/ui/base_widget.dart';
// import 'package:djqs/common/module/login/util/util_account.dart';
//
// //useless
// abstract mixin class FuncMNEntity<T> {
//   int? code;
//   String? msg;
//   List<T>? info;
//
//   fromJson(Map<String, dynamic> json, {bool isShowMsg = true}) {
//     try {
//       code = json['code']?.toInt();
//       msg = json['msg']?.toString();
//       if (json['info'] != null) {
//         final v = json['info'];
//         info = parseInfo(v);
//       }
//       if (code == BaseNetConst.REQUEST_LOGIN_EXPIRED) {
//         AccountUtil().hasLogined(isCanBack: false, callback: () async {});
//       } else if (code != 0 && isShowMsg == true)
//         BaseWidgetUtil.showToast(msg ?? "");
//     } catch (e) {
//       e.toString();
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['code'] = code;
//     data['msg'] = msg;
//     toInfo(data);
//     return data;
//   }
//
//   List<T>? parseInfo(data);
//
//   void toInfo(data);
// }
//
//
//
// // class OderListEntity extends PagingData<OderEntityInfo>
// //     with FuncMNEntity<OderEntityInfo> {
// //   @override
// //   Map<String, dynamic> toJson() {
// //     return super.toJson();
// //   }
// //
// //   OderListEntity.fromJson(Map<String, dynamic> json) {
// //     fromJson(json);
// //   }
// //
// //   @override
// //   List<OderEntityInfo>? parseInfo(data) {
// //     try {
// //       final arr0 = <OderEntityInfo>[];
// //       data.forEach((v) {
// //         arr0.add(OderEntityInfo.fromJson(v));
// //       });
// //       return arr0;
// //     } catch (e) {
// //       e.toString();
// //     }
// //   }
// //
// //   @override
// //   void toInfo(data) {
// //     if (info != null) {
// //       final v = info;
// //       final arr0 = [];
// //       v!.forEach((v) {
// //         arr0.add(v!.toJson());
// //       });
// //       data['info'] = arr0;
// //     }
// //   }
// //
// //   @override
// //   int getDataTotalCount() =>AppConst.INT_MAX;
// //
// //   @override
// //   List<OderEntityInfo> getDataSource()=>super.info!;
// //
// // }
