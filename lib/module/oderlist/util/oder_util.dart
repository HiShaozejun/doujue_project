import 'dart:math';

import 'package:djqs/app/app_util.dart';
import 'package:djqs/app/netDuo/base_entity_duo.dart';
import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_dialog.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/module/home/util/app_config_util.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/entity/upload_pic_data.dart';
import 'package:djqs/module/oderlist/upload_pic_page.dart';
import 'package:djqs/module/oderlist/util/orderlist_service.dart';
import 'package:djqs/module/oderlist/vm/upload_pic_vm.dart';
import 'package:flutter/cupertino.dart';

class OrderUtil {
  OrderUtil._internal();

  late final _service = OrderListService();
  late final _serviceDuo = OrderListServiceDuo();

  factory OrderUtil() => _instance;

  static late final OrderUtil _instance = OrderUtil._internal();

  bool _isRest() {
    if (AccountUtil().isRest) {
      BaseWidgetUtil.showToast('休息中暂时无法使用此功能');
      return true;
    }
    return false;
  }

  void btn_onItemGrab(BuildContext context, OrderItemData data) async {
    if (_isRest()) return;
    BaseDialogUtil.showCommonDialog(context!, title: '提示', content: '是否需要确认抢单',
        onPosBtn: () async {
      FuncEntity? result = await _service.orderGrab(data.orderEntity?.id);
      _showMsg(result);
      sendRefresh(result?.code, callback: () => _removeItem(data));
    });
  }

  void btn_onItemArrival(BuildContext context, OrderItemData data,
      {bool isDetailed = false}) async {
    if (_isRest()) return;
    if ((data.orderEntity?.fDistance ?? 0 / 1000) >
        (AppConfigUtil().getConfig()?.reachStoreNum ?? 0))
      BaseDialogUtil.showCommonDialog(context!,
          title: '提示',
          content: '您距离商家位置较远，有违规风险',
          rightBtnStr: '确认到店',
          onPosBtn: () => dealWithArrival(data, isDetailed: isDetailed));
    else
      dealWithArrival(data, isDetailed: isDetailed);
  }

  void dealWithArrival(OrderItemData data, {bool isDetailed = false}) async {
    FuncEntity? result = await _service.orderArrival(data.orderEntity?.id);
    _showMsg(result);
    sendRefresh(result?.code, isDetailed: isDetailed, callback: () {
      data.orderEntity?.status =
          OrderListEntity.ORDER_STATUS_ARRIVAL; //to-do 待后台将数值返回 解耦
      data.actionType = OrderItemData.CHANGE_TYPE_UPDATE;
      EventBus().send(EventCode.ORDER_ITEM_CHANGE, data);
    });
  }

  void sendRefresh(int? code, {bool isDetailed = false, Function()? callback}) {
    if (code == BaseNetConst.REQUEST_APP_OK) {
      callback?.call();
    }
  }

  void _showMsg(FuncEntity? result, {FuncEntityDuo? resultDuo}) {
    if (!ObjectUtil.isEmptyStr(result?.msg))
      BaseWidgetUtil.showToast(result!.msg!);

    if (!ObjectUtil.isEmptyStr(resultDuo?.msg))
      BaseWidgetUtil.showToast(resultDuo!.msg!);
  }

  void _removeItem(OrderItemData data) {
    data.actionType = OrderItemData.CHANGE_TYPE_REMOVE;
    EventBus().send(EventCode.ORDER_ITEM_CHANGE, data);
    EventBus().send(EventCode.HOME_COUNT_REFRESH);
  }

  void btn_onItemPick(BuildContext context, OrderItemData data,
      {bool isDetailed = false}) async {
    if (_isRest()) return;
    FuncEntity? result = await _service.orderTake(data.orderEntity?.id);
    _showMsg(result);
    sendRefresh(result?.code,
        isDetailed: isDetailed, callback: () => _removeItem(data));
  }

  void btn_onItemComplete(BuildContext context, OrderItemData data,
      {bool isDetailed = false}) async {
    if (_isRest()) return;
    FuncEntityDuo? result =
        await _serviceDuo.orderCheckComplete(data.orderEntity?.id);
    _showMsg(null, resultDuo: result);
    UploadPicData? pic = await BaseRouteUtil.push(
        context, UploadPicPage(uploadType: UploadPicVM.UPLOAD_TYPE_SEND));
    if (pic != null) {
      FuncEntity uploadResult = await _service.orderForceComplete(
          data.orderEntity?.id,
          code: pic?.code,
          images: pic?.images);
      _showMsg(uploadResult);
      sendRefresh(result?.code, callback: () => _removeItem(data));
    }
  }

  @deprecated
  void _dealWithItemComplete(BuildContext context, OrderItemData data,
      FuncEntityDuo result, int? status,
      {bool isDetailed = false}) {
    if (status == int.parse(AppUtil.DTO_ACTION_YES)) {
      dealWithOrderComplete(context, data, isDetailed: isDetailed);
    } else if (status == int.parse(AppUtil.DTO_ACTION_NO)) {
      double distance = max(data.orderEntity?.fDistance ?? 0,
          (result.info?['distance'] ?? 0).toDouble());
      if (distance / 1000 > (AppConfigUtil().getConfig()?.deliveryNum ?? 0)) {
        BaseDialogUtil.showCommonDialog(context!,
            title: '提示',
            content: '超出定位范围,必须上传送达图片',
            leftBtnStr: '还未送达',
            rightBtnStr: '去上传',
            onPosBtn: () async {
              UploadPicData pic = await BaseRouteUtil.push(context,
                  UploadPicPage(uploadType: UploadPicVM.UPLOAD_TYPE_SEND));
              FuncEntity result = await _service.orderForceComplete(
                  data.orderEntity?.id,
                  code: pic.code,
                  images: pic.images);
              _showMsg(result);
              sendRefresh(result?.code, callback: () => _removeItem(data));
            },
            onNagBtn: () => BaseWidgetUtil.showToast("未到达指定地点,必须上传图片"));
      } else
        BaseDialogUtil.showCommonDialog(context!,
            title: '警告',
            content: '您未到达目的地，将无法进行完成操作',
            rightBtnStr: '知道了',
            leftBtnStr: null);
    }
  }

  void dealWithOrderComplete(BuildContext context, OrderItemData data,
      {bool isDetailed = false}) async {
    FuncEntity result = await _service.orderComplete(data.orderEntity?.id);
    _showMsg(result);
    sendRefresh(result?.code,
        isDetailed: isDetailed, callback: () => _removeItem(data));
  }

  void btn_onItemError(BuildContext context, OrderItemData data) async {
    if (_isRest()) return;
    BaseDialogUtil.showCommonDialog(context!, title: '提示', content: '是否确定异常报备',
        onPosBtn: () async {
      UploadPicData pic = await BaseRouteUtil.push(
          context, UploadPicPage(uploadType: UploadPicVM.UPLOAD_TYPE_ERROR));
      FuncEntity result = await _service.orderError(data.orderEntity?.id,
          code: pic.code, desc: pic.desc, images: pic.images);
      if (result.code == BaseNetConst.REQUEST_APP_OK) result.msg == '报备成功';
      _showMsg(result);
      sendRefresh(result?.code, callback: () {
        data.orderEntity?.exceptionReport = AppUtil.DTO_ACTION_YES; //to-do等待解耦
        data.actionType = OrderItemData.CHANGE_TYPE_UPDATE;
        EventBus().send(EventCode.ORDER_ITEM_CHANGE, data);
      });
    });
  }

  String? getStateStr(OrderEntity? entity) {
    if (entity?.status == OrderListEntity.ORDER_STATUS_TAKE) return '服务中';

    if (entity?.status == OrderListEntity.ORDER_STATUS_PICK)
      return '${entity?.serviceTime}到达';

    if (entity?.type == OrderListEntity.ORDER_TYPE_DELIEVER ||
        entity?.type == OrderListEntity.ORDER_TYPE_TAKE)
      return '${entity?.serviceTime}取件';

    if (entity?.type == OrderListEntity.ORDER_TYPE_SHOP)
      return ObjectUtil.isEmptyStr(entity?.overTime)
          ? '${entity?.serviceTime ?? ''}送达'
          : entity?.overTime;

    return '';
  }

  String getTopItemLeftPNG(OrderEntity? entity) {
    if (entity?.type == OrderListEntity.ORDER_TYPE_DELIEVER ||
        entity?.type == OrderListEntity.ORDER_TYPE_TAKE ||
        entity?.type == OrderListEntity.ORDER_TYPE_SHOP) return 'app_quh';

    if (entity?.status == OrderListEntity.ORDER_STATUS_PICK ||
        entity?.status == OrderListEntity.ORDER_STATUS_FINISHED ||
        entity?.status == OrderListEntity.ORDER_STATUS_ARRIVAL) return 'app_qu';

    if (entity?.type == OrderListEntity.ORDER_STATUS_SEND) {
      if (entity?.status == OrderListEntity.ORDER_STATUS_PICK ||
          entity?.type == OrderListEntity.ORDER_TYPE_TAKE)
        return 'app_pai';
      else
        return 'app_paih';
    }

    return 'app_qu';
  }
}

class OrderItemData {
  static const int CHANGE_TYPE_UPDATE = 0;
  static const int CHANGE_TYPE_REMOVE = 1;

  int? index;
  OrderEntity? orderEntity;
  int? actionType;
  int? listType;

  OrderItemData(this.orderEntity, this.index, this.listType, {this.actionType});
}
