import 'dart:math';

import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/util/oder_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderUIUtil {
  BuildContext? context;
  late final OrderUtil orderUtil = OrderUtil();

  OrderUIUtil._internal();

  factory OrderUIUtil() => _instance;

  static late final OrderUIUtil _instance = OrderUIUtil._internal();

  Widget getHistoryListView(
          OrderListEntity? listEntity,
          ScrollController? controller,
          Function(OrderEntity? entity)? callback) =>
      Container(
        color: BaseColors.f5f5f5,
        child: ListView.builder(
            controller: controller,
            shrinkWrap: true,
            itemCount: listEntity?.list?.length,
            itemBuilder: (context, index) => OrderUIUtil()
                .getOrderHistoryItemView(listEntity?.list?[index],
                    callback: callback)),
      );

  Widget getOrderHistoryItemView(OrderEntity? entity,
          {Function(OrderEntity? item)? callback}) =>
      InkWell(
          child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: BaseColors.ffffff),
              margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('订单编号：${entity?.orderno ?? ''}',
                              style: BaseUIUtil()
                                  .getTheme()
                                  .primaryTextTheme
                                  .bodySmall),
                          BaseGaps().vGap5,
                          Row(children: [
                            _tagView(),
                            BaseGaps().hGap35,
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  _addressView(entity?.fName, entity?.fAddr),
                                  BaseGaps().vGap15,
                                  _addressView(entity?.tName, entity?.tAddr)
                                ]))
                          ])
                        ])),
                    BaseGaps().hGap5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            entity?.riderid == AccountUtil().getAccount()?.id
                                ? '已完成'
                                : '已转单',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: BaseDimens.fw_l,
                                color: entity?.riderid ==
                                        AccountUtil().getAccount()?.id
                                    ? BaseColors.c66dca0
                                    : BaseColors.fc3e5a)),
                        Text(entity?.income?.toString() ?? '')
                      ],
                    )
                  ])),
          onTap: () => callback?.call(entity));

  Widget _tagView() => Column(children: [
        BaseImageUtil().getRawImg('app_qu', height: 20.r, width: 20.r),
        Container(
            width: 1,
            height: 15.r,
            color: BaseColors.ebebeb,
            margin: EdgeInsets.symmetric(vertical: 10.r)),
        BaseImageUtil().getRawImg('app_song', height: 20.r, width: 20.r)
      ]);

  Widget _addressView(String? primary, String? second) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(primary ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: BaseUIUtil().getTheme().primaryTextTheme.displayLarge),
        Text(second ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: BaseUIUtil().getTheme().primaryTextTheme.bodySmall)
      ]);

  /**
   *
   */
  Widget getOrderItemView(BuildContext context, OrderItemData data,
      {Function(OrderItemData item)? onItemClick}) {
    this.context = context;
    return InkWell(
      onTap: () => onItemClick?.call(data),
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
              decoration: BoxDecoration(
                color: BaseColors.ffffff,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(children: [
                if (!ObjectUtil.isEmptyStr(
                    data.orderEntity?.preEndDeliveryTime))
                  _order_topTimeView(data),
                BaseGaps().vGap5,
                _order_numberView(data.orderEntity),
                BaseGaps().vGap10,
                _order_takeView(data.orderEntity, data.listType!),
                BaseGaps().vGap10,
                _order_sendView(data.orderEntity, data.listType!),
                BaseGaps().vGap10,
                if (data.listType != OrderListEntity.LIST_TYPE_FINISHED)
                  Padding(
                    padding: EdgeInsets.only(
                        left: data.orderEntity?.exceptionReport ==
                                AppUtil.DTO_ACTION_YES
                            ? 20.w
                            : 0),
                    child: getbottomBtnRow(data),
                  ),
                if (data.listType != OrderListEntity.LIST_TYPE_FINISHED)
                  BaseGaps().vGap10
              ])),
          if (data.orderEntity?.exceptionReport == AppUtil.DTO_ACTION_YES)
            Positioned(
              left: 15.w,
              bottom: 0,
              child: CustomPaint(
                  size: Size(50, 50),
                  painter: TrianglePainter(color: BaseColors.c00a0e7)),
            ),
          if (data.orderEntity?.exceptionReport == AppUtil.DTO_ACTION_YES)
            Positioned(
                left: 15.w,
                bottom: 0,
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                        child: Transform.rotate(
                            angle: pi / 4,
                            child: FittedBox(
                              child: Text('已报备',
                                  style: TextStyle(
                                      color: BaseColors.ffffff,
                                      fontSize: 11,
                                      fontWeight: BaseDimens.fw_m)),
                            )))))
        ],
      ),
    );
  }

  Widget getbottomBtnRow(OrderItemData data, {bool isDetailed = false}) {
    if (data.orderEntity?.status == OrderListEntity.ORDER_STATUS_PAY_YES) {
      return _bottomBtnView('抢单',
          isDetailed: isDetailed,
          onPressed: () => orderUtil.btn_onItemGrab(context!, data));
    }

    if (isDetailed &&
        data.orderEntity?.status == OrderListEntity.ORDER_STATUS_FINISHED) {
      return _bottomBtnView('已完成', isDetailed: isDetailed);
    }

    return Row(
      children: [
        if (!isDetailed &&
            data.orderEntity?.exceptionReport == AppUtil.DTO_ACTION_NO)
          _bottomBtnView('异常报备',
              textColor: BaseColors.c11111,
              bgColor: BaseColors.ffffff,
              borderColor: BaseColors.bfbfbf,
              isDetailed: isDetailed,
              onPressed: () => orderUtil.btn_onItemError(this.context!, data)),
        if (data.orderEntity?.status == OrderListEntity.ORDER_STATUS_PICK)
          Expanded(
              child: _bottomBtnView('上报到店',
                  bgColor: BaseColors.ffca54,
                  textColor: BaseColors.c11111,
                  isDetailed: isDetailed,
                  onPressed: () => orderUtil.btn_onItemArrival(context!, data,
                      isDetailed: isDetailed))),
        if (data.orderEntity?.status == OrderListEntity.ORDER_STATUS_ARRIVAL)
          Expanded(
              child: _bottomBtnView(isDetailed == true ? '确认配送' : '我已取货',
                  isDetailed: isDetailed,
                  onPressed: () => orderUtil.btn_onItemPick(context!, data,
                      isDetailed: isDetailed))),
        if (data.orderEntity?.status == OrderListEntity.ORDER_STATUS_TAKE)
          Expanded(
              child: _bottomBtnView('我已送达',
                  isDetailed: isDetailed,
                  bgColor: BaseColors.c34cc00,
                  onPressed: () => orderUtil.btn_onItemComplete(context!, data,
                      isDetailed: isDetailed)))
      ],
    );
  }

  Widget _bottomBtnView(String str,
          {Color textColor = BaseColors.ffffff,
          Color bgColor = BaseColors.e70012,
          Color borderColor = BaseColors.trans,
          onPressed,
          bool? isDetailed}) =>
      _padding(
        padding: isDetailed == true ? 0 : 10.w,
        InkWell(
            onTap: () => onPressed?.call(),
            child: isDetailed == true
                ? BaseWidgetUtil.getContainerSized(
                    height: 50.h,
                    text: str ?? '',
                    color: bgColor,
                    circular: 0,
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: BaseDimens.fw_l,
                      color: textColor,
                    ))
                : BaseWidgetUtil.getContainer(
                    aligment: Alignment.center,
                    paddingV: 5.h,
                    paddingH: 20.w,
                    color: bgColor,
                    circular: 20.r,
                    borderColor: borderColor,
                    child: Text(str ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: BaseDimens.fw_m,
                          color: textColor,
                        )))),
      );

  Widget _order_topTimeView(OrderItemData data) => Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: _topTime_bg(data.orderEntity!, data.listType!),
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Text(
          '${data.orderEntity!.status == OrderListEntity.ORDER_STATUS_FINISHED ? '送达时间' : '预计送达时间'}：${data.orderEntity!.getTopTimeStr(data.listType!)}',
          style: TextStyle(fontSize: 13, color: BaseColors.ffffff),
        ),
      );

  Widget _order_numberView(OrderEntity? entity) => _padding(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        BaseWidgetUtil.getTextWithWidgetH(entity?.getOrderNum() ?? '',
            minor:
                BaseImageUtil().getRawImg('app_jd', height: 20.r, width: 20.r),
            space: 5,
            primaryStyle: TextStyle(
                fontWeight: BaseDimens.fw_l_x,
                color: BaseColors.c00a0e7,
                fontSize: 15)),
        ObjectUtil.isEmptyDouble(entity?.income)
            ? Container()
            : Text(
                entity?.getOrderIncome() ?? '',
                style: TextStyle(
                    fontSize: 15,
                    color: BaseColors.fc3e5a,
                    fontWeight: BaseDimens.fw_l_x),
              )
      ]));

  Widget _order_takeView(OrderEntity? entity, int listType) => _padding(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseImageUtil().getRawImg('app_qu', height: 20.r, width: 20.r),
            BaseGaps().hGap15,
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        entity?.fName ?? '',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: BaseDimens.fw_l,
                            color: BaseColors.c11111),
                      ),
                    ),
                    BaseGaps().hGap5,
                    BaseWidgetUtil.getContainer(
                        paddingH: 5.w,
                        paddingV: 1.h,
                        text: entity?.typeT ?? '',
                        color: BaseColors.c5578A3,
                        circular: 0,
                        textStyle:
                            TextStyle(fontSize: 13, color: BaseColors.ffffff)),
                    BaseGaps().hGap5,
                    if (listType != OrderListEntity.LIST_TYPE_FINISHED)
                      Text(entity?.fDistanceStr?.toString() ?? '')
                  ]),
                  BaseGaps().vGap5,
                  if (entity?.type != OrderListEntity.ORDER_TYPE_TAKE)
                    Text(entity?.fAddr ?? '',
                        style:
                            TextStyle(fontSize: 13, color: BaseColors.c828282)),
                  if (entity?.type != OrderListEntity.ORDER_TYPE_TAKE)
                    BaseGaps().vGap5,
                  if (entity?.status != OrderListEntity.ORDER_STATUS_PAY_YES)
                    _buttonRowForTake(entity, listType),
                  BaseGaps().vGap5,
                  if (!ObjectUtil.isEmptyStr(entity?.des))
                    Text(entity!.des!,
                        style:
                            TextStyle(fontSize: 13, color: BaseColors.c828282)),
                  BaseGaps().vGap5,
                  if (listType != OrderListEntity.LIST_TYPE_FINISHED &&
                      !ObjectUtil.isEmptyStr(entity?.overTime))
                    _overtimeView(entity!)
                ]))
          ]));

  Widget _buttonRowForTake(OrderEntity? entity, int listType) => Row(children: [
        if (!ObjectUtil.isEmptyStr(entity?.pickPhone)) _buttonCall(entity!),
        if (!ObjectUtil.isEmptyStr(entity?.pickPhone)) BaseGaps().hGap10,
        if (listType == OrderListEntity.LIST_TYPE_TAKE &&
            !ObjectUtil.isEmptyStr(entity?.fLat))
          _buttonNavi(entity!.fLat!, entity!.fLng!, entity.fName)
      ]);

  Widget _buttonCall(OrderEntity entity) => _btn_shortView('电话商家', Icons.call,
      onTap: () => BaseSystemUtil().launchPhone(entity!.pickPhone!));

  Widget _buttonNavi(String lat, String lng, String? address) =>
      _btn_shortView('导航', Icons.navigation_sharp,
          onTap: () => BaseLocationUtil().showMapSheet(
              double.parse(lat), double.parse(lng),
              address: address));

  Widget _btn_shortView(String title, IconData iconData, {Function()? onTap}) =>
      BaseWidgetUtil.getButtonSized(
          borderColor: BaseColors.c9c9c9,
          width: 100,
          height: 35,
          borderWidth: 0.5,
          onTap: onTap,
          child: BaseWidgetUtil.getTextWithWidgetH(title,
              primaryStyle: TextStyle(fontSize: 13, color: BaseColors.c00a0e7),
              minor: Icon(
                iconData,
                size: 15,
                color: BaseColors.c00a0e7,
              )));

  Widget _overtimeView(OrderEntity entity) => BaseWidgetUtil.getContainerSized(
      aligment: Alignment.topLeft,
      width: 1.sw,
      circular: 0,
      paddingV: 5,
      paddingH: 5,
      color: BaseColors.fff0f0,
      child: Text(entity.overTime!,
          style: TextStyle(
              fontSize: 13,
              color: BaseColors.e70012,
              fontWeight: BaseDimens.fw_l)));

  Widget _order_sendView(OrderEntity? entity, int listType) => _padding(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseImageUtil().getRawImg('app_song', height: 20.r, width: 20.r),
          BaseGaps().hGap15,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                      child: Text(
                    entity?.tName ?? '',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: BaseDimens.fw_l,
                        color: BaseColors.c11111),
                  )),
                  BaseGaps().hGap5,
                  if (listType != OrderListEntity.LIST_TYPE_FINISHED)
                    Text(entity?.tDistanceStr?.toString() ?? '')
                ]),
                BaseGaps().vGap5,
                if (entity?.type != OrderListEntity.ORDER_TYPE_TAKE)
                  Text(entity?.tAddr ?? '',
                      style:
                          TextStyle(fontSize: 13, color: BaseColors.c828282)),
                if (entity?.type != OrderListEntity.ORDER_TYPE_TAKE)
                  BaseGaps().vGap5,
                if (entity?.status == OrderListEntity.ORDER_STATUS_TAKE &&
                    !ObjectUtil.isEmptyStr(entity?.tLat))
                  _buttonNavi(entity!.tLat!, entity!.fLng!, entity!.tName),
                BaseGaps().vGap5,
                if (listType != OrderListEntity.LIST_TYPE_NEW)
                  _addresseeView(entity)
              ],
            ),
          )
        ],
      ));

  Widget _addresseeView(OrderEntity? entity) => InkWell(
        onTap: () {
          if (!ObjectUtil.isEmptyStr(entity?.recipPhone))
            BaseSystemUtil().launchPhone(entity!.recipPhone!);
        },
        child: BaseWidgetUtil.getContainerSized(
            aligment: Alignment.topLeft,
            width: 1.sw,
            circular: 0,
            paddingV: 5,
            paddingH: 5,
            color: BaseColors.f5f5f5,
            child: BaseWidgetUtil.getTextWithWidgetH(
                '收货人：${entity?.recipName ?? ''}',
                primaryStyle: TextStyle(
                    fontSize: 13,
                    color: BaseColors.c11111,
                    fontWeight: BaseDimens.fw_m),
                minor: Icon(
                  Icons.call,
                  size: 15,
                  color: BaseColors.c00a0e7,
                ),
                isLeft: false)),
      );

  Widget _padding(Widget child, {double? padding}) => Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 10.w), child: child);

  /***
   *
   */
  Color _topTime_bg(OrderEntity entity, int listType) {
    DateTime endTime =
        DateTime.parse(ObjectUtil.strToZero(entity.preEndDeliveryTime));
    if (listType == OrderListEntity.LIST_TYPE_FINISHED) {
      if (entity.status == OrderListEntity.ORDER_STATUS_CANCEL)
        return BaseColors.fc3e5a;
      DateTime finishTime =
          DateTime.parse(ObjectUtil.strToZero(entity.completeTime));
      if (finishTime.isBefore(endTime)) return BaseColors.c66dca0;
      return BaseColors.fc3e5a;
    } else {
      DateTime startTime =
          DateTime.parse(ObjectUtil.strToZero(entity.preStartDeliveryTime));
      DateTime now = DateTime.now();
      if (now.isBefore(startTime))
        return BaseColors.c66dca0;
      else if (now.isAfter(startTime) && now.isBefore(endTime)) {
        return BaseColors.f96b56;
      }
      return BaseColors.fc3e5a;
    }
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    const radius = 10.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - radius)
      ..quadraticBezierTo(0, size.height, radius, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
