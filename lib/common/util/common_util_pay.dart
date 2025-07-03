// import 'dart:convert';
//
// import 'package:djqs/base/net/base_net_const.dart';
// import 'package:djqs/base/net/base_service.dart';
// import 'package:djqs/base/res/base_colors.dart';
// import 'package:djqs/base/ui/base_dialog.dart';
// import 'package:djqs/base/ui/base_widget.dart';
// import 'package:djqs/base/util/util_image.dart';
// import 'package:djqs/base/util/util_object.dart';
// import 'package:djqs/base/util/util_string.dart';
// import 'package:djqs/common/entity/pay_ali_bind_entity.dart';
// import 'package:djqs/common/entity/pay_ali_result_entity.dart';
// import 'package:djqs/common/entity/pay_ali_user_entity.dart';
// import 'package:djqs/common/entity/pay_balance_entity.dart';
// import 'package:djqs/common/entity/pay_order_entity.dart';
// import 'package:djqs/common/entity/pay_withdrawalresult_entity.dart';
// import 'package:djqs/common/module/login/util/util_account.dart';
// import 'package:djqs/common/util/common_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluwx/fluwx.dart';
// import 'package:tobias/tobias.dart';
//
// class CommonPayUtil {
//   static const int PAY_TYPE_WX = 10;
//   static const int PAY_TYPE_ALI = 20;
//   static const int PAY_TYPE_BALANCE = 30;
//
//   List<NormalListItem> _sheetData = [];
//
//   final Fluwx _fluwx = Fluwx();
//   final Tobias _tobias = Tobias();
//   late final PayService _service = PayService();
//   int _lastIndex = -1;
//
//   CommonPayUtil._internal() {
//     _sheetData.add(_getPayItem('支付宝支付', CommonSVG.payAli, PAY_TYPE_ALI, false));
//     _sheetData
//         .add(_getPayItem('余额', CommonSVG.paybalance, PAY_TYPE_BALANCE, false));
//     // _sheetData
//     //     .add(_getPayItem('微信支付', 'base_pay_wx', 0xff04D102, PAY_TYPE_WX, false));
//   }
//
//   NormalListItem _getPayItem(
//           String title, String svgName, int type, bool rightShow) =>
//       NormalListItem(
//           prefixChild: BaseImageUtil().getAssetSvg(svgName, size: 22.r),
//           primary: title,
//           type: type,
//           rightShow: rightShow,
//           rightType: ItemType.IMG,
//           suffixChild: Icon(
//             Icons.check,
//             color: BaseColors.c00a0e7,
//             size: 15.r,
//           ));
//
//   factory CommonPayUtil() => _instance;
//
//   static late final CommonPayUtil _instance = CommonPayUtil._internal();
//
//   init() async {
//     // await _fluwx.registerApi(
//     //   appId: '',
//     //   doOnAndroid: true,
//     //   doOnIOS: true,
//     //   //universalLink: 'https://your.univerallink.com/link/',
//     // );
//   }
//
//   Future authAndBindAli() async {
//     await BaseWidgetUtil.showLoading();
//     Map<String, dynamic>? aliAuthInfo =
//         await _service.getAuthInfo(AccountUtil().getAccount()!.id!);
//     if (aliAuthInfo == null) _authFail();
//     Map result = await _tobias.auth(BaseStrUtil.mapToJointStr(aliAuthInfo!));
//     if (result['resultStatus'] == '9000') {
//       Map<String, dynamic> queryParams = Uri.splitQueryString(result['result']);
//       String? authCode = queryParams['auth_code'];
//       if (ObjectUtil.isEmptyStr(authCode))
//         _authFail();
//       else {
//         AliUserEntity? userEntity = await _service.getAliUserInfo(authCode!);
//         if (userEntity == null ||
//             ObjectUtil.isEmptyStr(userEntity?.userInfo?.userId))
//           _authFail();
//         else {
//           AliBindEntity? bindEntity = await _service.bindAliAccount(
//               AccountUtil().getAccount()?.userNickname,
//               int.parse(AccountUtil().getAccount()!.id!),
//               userEntity!.userInfo!.userId!,
//               userEntity.userInfo?.nickName,
//               userEntity.userInfo?.avatar);
//           await BaseWidgetUtil.cancelLoading();
//           return bindEntity;
//         }
//       }
//     } else
//       _authFail();
//
//     return null;
//   }
//
//   void _authFail() {
//     BaseWidgetUtil.cancelLoading();
//     BaseWidgetUtil.showToast('未成功授权');
//   }
//
//   void changeItem(int index, {bool rightShow = false}) {
//     if (rightShow) {
//       _sheetData[index].rightShow = rightShow;
//       if (_lastIndex != -1 && _lastIndex != index)
//         _sheetData[_lastIndex].rightShow = false;
//       _lastIndex = index;
//     }
//   }
//
//   void pay(int index, int type, int amount, {Function()? callback}) async {
//     await BaseWidgetUtil.showLoading();
//     PayOrderEntity? entity = await _service.getOrderId(type, amount);
//     if (ObjectUtil.isEmptyStr(entity?.tranSn)) {
//       BaseWidgetUtil.showToast('生成订单失败');
//       await BaseWidgetUtil.cancelLoading();
//     } else {
//       if (await _checkInstalled(type)) {
//         if (type == PAY_TYPE_WX)
//           payWX(entity!.tranSn!, callback: callback);
//         else if (type == PAY_TYPE_ALI)
//           payAli(entity?.payCode, callback: callback);
//         else if (type == PAY_TYPE_BALANCE)
//           payBalance(entity!.tranSn!, callback: callback);
//       } else
//         BaseWidgetUtil.cancelLoading();
//     }
//   }
//
//   NormalListItem getItem(int index) => _sheetData[index];
//
//   Future<bool> _checkInstalled(int type) async {
//     bool result = false;
//     if (type == PAY_TYPE_WX)
//       result = await _fluwx.isWeChatInstalled;
//     else if (type == PAY_TYPE_ALI)
//       result = (await _tobias.isAliPayInstalled ||
//           await _tobias.isAliPayHKInstalled);
//     else
//       result = true;
//     if (!result)
//       BaseWidgetUtil.showToast('请先安装${type == PAY_TYPE_WX ? '微信' : '支付宝'}');
//     return result;
//   }
//
//   void payWX(String orderId, {Function()? callback}) async {
//     _fluwx.pay(
//         which: Payment(
//       appId: '',
//       partnerId: '',
//       prepayId: '',
//       packageValue: '',
//       nonceStr: '',
//       timestamp: 0,
//       sign: '',
//     ));
//   }
//
//   void payAli(String? orderId, {Function()? callback}) async {
//     if (ObjectUtil.isEmptyStr(orderId)) {
//       BaseWidgetUtil.showToast('生成订单失败');
//       await BaseWidgetUtil.cancelLoading();
//     } else {
//       Map payResult = await _tobias.pay(orderId!);
//       await BaseWidgetUtil.cancelLoading();
//       if (payResult == null) {
//         BaseWidgetUtil.showToast('支付失败');
//       } else {
//         if (payResult['resultStatus'] == '9000') {
//           dynamic resultStr = jsonDecode(payResult['result']);
//           PayAliResultEntity? entity = PayAliResultEntity.fromJson(resultStr);
//           if (entity.alipayTradeAppPayResponse?.code == '10000') {
//             BaseWidgetUtil.showToast('充值成功');
//             callback?.call();
//           } else
//             BaseWidgetUtil.showToast(
//                 entity.alipayTradeAppPayResponse?.msg ?? '支付失败');
//         } else
//           BaseWidgetUtil.showToast(payResult['memo'] ?? '支付失败');
//       }
//     }
//   }
//
//   void payBalance(String orderId, {Function()? callback}) async {
//     BaseWidgetUtil.showToast('充值成功');
//     await _updateBalance();
//     await BaseWidgetUtil.cancelLoading();
//     callback?.call();
//   }
//
//   Future<void> _updateBalance() async {
//     final PayBalanceEntity? balanceEntity = await _service.getFinancialDetail();
//     _sheetData[1].primary = '余额(剩余：￥${balanceEntity?.amount ?? 0})';
//     _sheetData[1].disable =
//         ((double.parse((balanceEntity?.amount ?? '0')) == 0) ? true : false);
//   }
//
//   void showBottomSheet(BuildContext context,
//       {Function(int index, int type)? onSheetItemClick,
//       int lastIndex = 0}) async {
//     await _updateBalance();
//     changeItem(lastIndex, rightShow: true);
//     BaseDialogUtil.showListBS(context,
//         title: '充值', titleCenter: false, topData: _sheetData, onTopItemClick:
//             (BuildContext sheetBC, BuildContext context, int index) {
//       Navigator.pop(sheetBC);
//       onSheetItemClick?.call(index, _sheetData[index].type);
//     });
//   }
//
//   Future withdrawal(int amount, int type) => _service.withdrawal(amount, type);
//
//   void dipose() {
//     _sheetData[_lastIndex].rightShow = false;
//     _lastIndex = -1;
//   }
// }
//
// class PayService extends BaseService {
//   Future<PayOrderEntity?> getOrderId(int type, int amount) => requestSync(
//       data: {'pay_type': type, "amount": amount},
//       showLoading: false,
//       path: "${BaseNetConst().commonUrl}/score/recharge/index",
//       create: (resource) => PayOrderEntity.fromJson(resource));
//
//   Future<PayBalanceEntity?> getFinancialDetail() => requestSync(
//       path: "${BaseNetConst().commonUrl}/finance/app/balance",
//       create: (resource) => PayBalanceEntity.fromJson(resource),
//       showLoading: false);
//
//   Future<Map<String, dynamic>?> getAuthInfo(String uid) => requestSync(
//       data: {'target_id': uid},
//       path: "${BaseNetConst().commonUrl}/app/alipay/get-sign",
//       create: (resource) => resource,
//       showLoading: false);
//
//   Future<AliUserEntity?> getAliUserInfo(String authCode) => requestSync(
//       data: {'code': authCode},
//       path: "${BaseNetConst().commonUrl}/app/alipay/token-userinfo",
//       create: (resource) => AliUserEntity.fromJson(resource),
//       showLoading: false);
//
//   Future<WithdrawalResultEntity?> withdrawal(int amount, int type) =>
//       requestSync(
//           data: {
//             'amount': amount,
//             'channel': type == CommonPayUtil.PAY_TYPE_WX ? 'wechat' : 'ali'
//           },
//           path: "${BaseNetConst().commonUrl}/score/cash-out/index",
//           create: (resource) => WithdrawalResultEntity.fromJson(resource),
//           showLoading: false);
//
//   Future<AliBindEntity?> bindAliAccount(String? userName, int uid,
//           String aliUserId, String? aliUserName, String? avatar) =>
//       requestSync(
//           data: {
//             "user_name": userName,
//             "user_id": uid,
//             "alipay_uid": aliUserId,
//             "nick_name": aliUserName,
//             "avatar": avatar
//           },
//           path: "${BaseNetConst().commonUrl}/withdraw/account/save-ali-payee",
//           create: (resource) => AliBindEntity.fromJson(resource),
//           showLoading: false);
// }
