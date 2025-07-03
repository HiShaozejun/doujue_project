import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/base/widget/media/photo_view_widget.dart';
import 'package:djqs/module/message/chat_page.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/util/oder_util.dart';
import 'package:djqs/module/oderlist/util/orderlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart' as TM;
import 'package:tencent_map_flutter/tencent_map_flutter.dart';
import 'package:tencent_map_flutter/util/map_util.dart';

class OrderDetailVM extends BaseNotifier {
  OrderItemData? orderItemData;
  OrderEntity? orderEntity;

  final TencentMapUtil mapUtil = TencentMapUtil();
  TencentMapController? mapController;
  bool showMap = true;

  //
  TM.LatLng? startPoint;
  TM.LatLng? endPoint;

  //
  late final _service = OrderListService();
  List<NormalListItem> goodsList = [];
  List<NormalListItem> orderNumList = [];
  List<NormalListItem> incomeList = [];
  List<NormalListItem> timeList = [];

  OrderDetailVM(super.context, this.orderItemData);

  @override
  void onPause() {
    super.onPause();
    mapController?.stop();
    showMap = false;
    notifyListeners();
  }

  @override
  void onResume() async {
    Future.delayed(Duration(milliseconds: 100), () async {
      await mapController?.start();
      showMap = true;
      notifyListeners();
    });
  }

  @override
  void init() {
    orderEntity = orderItemData?.orderEntity;
    startPoint = TM.LatLng(
        ObjectUtil.strToDoubleZero(BaseLocationUtil().getLocationData()?.lat),
        ObjectUtil.strToDoubleZero(BaseLocationUtil().getLocationData()?.lng));
    endPoint = TM.LatLng(
        ObjectUtil.strToDoubleZero(
            orderItemData?.listType == OrderListEntity.LIST_TYPE_TAKE
                ? orderEntity?.fLat
                : orderEntity?.tLat),
        ObjectUtil.strToDoubleZero(
            orderItemData?.listType == OrderListEntity.LIST_TYPE_TAKE
                ? orderEntity?.fLng
                : orderEntity?.tLng));
    _refresh();

    EventBus().on(EventCode.ORDER_ITEM_CHANGE, (param) async {
      await _refresh(isFirstTime: false, nofify: false);
      this.orderItemData?.orderEntity = orderEntity;
      this.orderItemData?.actionType = (param as OrderItemData).actionType;
      notifyListeners();
    });
  }

  Future _refresh({bool isFirstTime = true, bool nofify = true}) async {
    orderEntity = (await _service.getOrderDetail(orderEntity?.id))?[0];
    if (isFirstTime) {
      orderEntity?.product?.forEach((item) {
        goodsList.add(NormalListItem(
            primary: item?.product?.useName, minor: 'x${item?.cartNum ?? 0}'));
      });
      orderNumList.add(NormalListItem(
          primary: '订单编号',
          minor: orderEntity?.tradeNo ?? orderEntity?.orderno ?? ''));
      orderNumList.add(
          NormalListItem(primary: '送达时间', minor: orderEntity?.serviceTime));
      incomeList.add(NormalListItem(
          primary: '配送费',
          minor: '¥${ObjectUtil.intToZero(orderEntity?.riderBasic)}'));
      incomeList.add(NormalListItem(
          primary: '超重费',
          minor: '¥${ObjectUtil.intToZero(orderEntity?.riderWeight)}'));
      incomeList.add(NormalListItem(
          primary: '小费',
          minor: '¥${ObjectUtil.strToZero(orderEntity?.riderFee)}'));

      incomeList.add(NormalListItem(
          primary: '合计',
          minor: '¥${orderEntity?.income ?? 0}',
          minorStyle: TextStyle(fontSize: 12.sp, color: BaseColors.fc3e5a)));

      timeList.add(NormalListItem(
          primary: getTimeStr(orderEntity?.addTime), minor: '下单'));

      timeList.add(NormalListItem(
          primary: getTimeStr(orderEntity?.grapTime2), minor: '接单'));

      timeList.add(NormalListItem(
          primary: getTimeStr(orderEntity?.reachStoreTime2), minor: '到店'));

      timeList.add(NormalListItem(
          primary: getTimeStr(orderEntity?.pickTime2), minor: '取货'));

      timeList.add(NormalListItem(
          primary: getTimeStr(orderEntity?.completeTime2), minor: '送达'));
    }
    if (nofify) notifyListeners();
  }

  String getTimeStr(String? str) => ObjectUtil.isEmptyStr(str) ? '-' : str!;

  void setMapController(TencentMapController controller) {
    this.mapController = controller;
    _getRouteData();
  }

  Future<void> _getRouteData() async {
    await Future.delayed(Duration(seconds: 1));
    List<TM.LatLng>? polyline = await mapUtil.getEBRoute(
      from: '${startPoint?.latitude},${startPoint?.longitude}',
      to: '${endPoint?.latitude},${endPoint?.longitude}',
    );

    final markerStart = Marker(
      id: '1',
      position: polyline?[0] ?? startPoint!,
      icon: Bitmap(asset: BaseImageUtil().getAssetImgPath('app_mapmarker_me')),
      anchor: Anchor(x: 0.5, y: 1),
      draggable: false,
    );
    mapController!.addMarker(markerStart);
    if (polyline != null) {
      mapController!.addPolylines(polyline);

      final markerEnd = Marker(
        id: '2',
        position: polyline[polyline.length - 1],
        icon: Bitmap(
            asset: BaseImageUtil().getAssetImgPath('app_mapmarker_shop')),
        anchor: Anchor(x: 0.5, y: 1),
        draggable: false,
      );
      mapController!.addMarker(markerEnd);
    } else
      mapController!.moveCamera(
          CameraPosition(position: startPoint, zoom: 16, heading: 0, skew: 0));
  }

  String? getTopItemDistance() {
    if (orderEntity?.status == OrderListEntity.ORDER_STATUS_PICK)
      return orderEntity?.fDistanceStr;
    if (orderEntity?.status == OrderListEntity.ORDER_STATUS_TAKE ||
        orderEntity?.status == OrderListEntity.ORDER_STATUS_ARRIVAL)
      return '---';

    return '';
  }

  void btn_gotoChat() => pagePush(ChatPage(
      chatId: orderEntity?.usersIm?.userId, cardEntity: orderEntity?.orderNum));

  void btn_gotoNavi(String lat, String lng, String? address) =>
      BaseLocationUtil()
          .showMapSheet(double.parse(lat), double.parse(lng), address: address);

  void btn_call() {
    if (orderEntity?.status == OrderListEntity.ORDER_STATUS_PICK &&
        !ObjectUtil.isEmptyStr(orderEntity?.pickPhone)) {
      BaseSystemUtil().launchPhone(orderEntity!.pickPhone!);
    } else if (!ObjectUtil.isEmptyStr(orderEntity?.recipPhone)) {
      BaseSystemUtil().launchPhone(orderEntity!.recipPhone!);
    }
  }

  @override
  void btn_onBack({BuildContext? context}) {
    pagePop(params: this.orderItemData, context: context!);
  }

  void btn_onClickThumbs(String url) {
    pagePush(PhotoViewWidget(images: [url], showBack: true, showTitle: false));
  }

  @override
  void onCleared() {
    mapController?.stop();
    mapController?.destroy();
    EventBus().off(EventCode.ORDER_ITEM_CHANGE);
  }
}
