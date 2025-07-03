import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/oderlist/entity/order_list_entity.dart';
import 'package:djqs/module/oderlist/util/oder_ui_util.dart';
import 'package:djqs/module/oderlist/util/oder_util.dart';
import 'package:djqs/module/oderlist/vm/order_detail_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_map_flutter/tencent_map_flutter.dart';

class OrderDetailPage extends StatefulWidget {
  OrderItemData? orderItemData;

  OrderDetailPage({super.key, required this.orderItemData});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends BasePageState<OrderDetailPage, OrderDetailVM> {

  @override
  Widget build(BuildContext context) => buildViewModel<OrderDetailVM>(
      create: (context) => OrderDetailVM(context, widget.orderItemData),
      viewBuild: (context, vm) {
        return Container(
            color: BaseColors.f5f5f5,
            child: Column(children: [
              Expanded(
                child: Stack(children: [
                  Positioned(
                    child: vm.showMap
                        ? TencentMap(
                            rotateGesturesEnabled: false,
                            skewGesturesEnabled: false,
                            mapType: MapType.normal,
                            androidTexture: true,
                            onMapCreated: vm.setMapController,
                          )
                        : Container(),
                  ),
                  bottomSheetView(),
                  Positioned(
                      top: 10.h,
                      left: 15.w,
                      child: BaseWidgetUtil.getCircleButton(
                          Icons.arrow_back_ios_outlined,
                          () => vm.btn_onBack(context: context)))
                ]),
              ),
              _bottomView()
            ]));
      });

  Widget _bottomView() => Container(
        color: BaseUIUtil().getTheme().primaryColor,
        width: 1.sw,
        child: Row(
          children: [
            Expanded(
              child: BaseWidgetUtil.getTextWithIconV("联系",
                  textStyle:
                      BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                  icon: Icons.call,
                  iconSize: 25.r,
                  iconColor: BaseUIUtil()
                      .getTheme()
                      .primaryTextTheme!
                      .displayMedium!
                      .color!,
                  onTap: vm.btn_call),
              flex: 1,
            ),
            Expanded(
              child: OrderUIUtil()
                  .getbottomBtnRow(vm.orderItemData!, isDetailed: true),
              flex: 2,
            )
          ],
        ),
      );

  Widget thumbsView() => Wrap(
      spacing: 15.w,
      runSpacing: 5.h,
      children: vm.orderEntity!.thumbs!
          .map<Widget>((String? url) => InkWell(
                onTap: () => vm.btn_onClickThumbs(url!),
                child: BaseImageUtil().getCachedImageWidgetSized(
                    url: url, fit: BoxFit.fill, width: 50.w, height: 50.h),
              ))
          .toList());

  Widget bottomSheetView() => DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) => Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: BaseColors.ffffff,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: BaseColors.c9c9c9, blurRadius: 10)],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              BaseWidgetUtil.getContainerSized(
                  marginH: 1.sw / 2 - 35.w,
                  width: 1.sw,
                  height: 5.h,
                  color: BaseColors.dad8d8),
              BaseGaps().vGap15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('配送信息',
                      style: TextStyle(
                          color: BaseColors.c161616, fontSize: 18.sp)),
                  Text('#${vm.orderEntity?.orderNum}',
                      style:
                          BaseUIUtil().getTheme().primaryTextTheme.titleLarge)
                ],
              ),
              BaseGaps().vGap10,
              if (vm.orderEntity?.status !=
                  OrderListEntity.ORDER_STATUS_FINISHED)
                BaseWidgetUtil.getTextWithWidgetH(
                  OrderUtil().getStateStr(vm.orderEntity) ?? '',
                  primaryStyle: TextStyle(
                      fontSize: 15.sp,
                      color: BaseColors.fc3e5a,
                      fontWeight: BaseDimens.fw_l_x),
                  minor: BaseImageUtil().getRawImg(
                      '${AppUtil.getActionBool(vm.orderEntity?.ispre) ? 'app_yu' : 'app_shijian'}',
                      height: 15.r,
                      width: 15.r),
                ),
              if (vm.orderEntity?.status !=
                  OrderListEntity.ORDER_STATUS_FINISHED)
                BaseGaps().vGap10,
              addressView(vm.orderEntity, vm.orderItemData!.listType),
              BaseGaps().vGap10,
              Align(
                  alignment: Alignment.topLeft,
                  child: BaseWidgetUtil.getContainer(
                      paddingH: 15.w,
                      marginL: 65.w,
                      paddingV: 2.h,
                      text: vm.orderEntity?.typeT ?? '',
                      color: BaseColors.c34cc00,
                      circular: 0,
                      textStyle: TextStyle(
                          fontSize: 12.sp, color: BaseColors.ffffff))),
              BaseGaps().vGap10,
              _subColumn('物品信息', vm.goodsList),
              _subColumn('订单信息', vm.orderNumList),
              BaseGaps().vGap10,
              if (!ObjectUtil.isEmptyList(vm.orderEntity?.thumbs)) thumbsView(),
              if (!ObjectUtil.isEmptyList(vm.orderEntity?.thumbs))
                BaseGaps().vGap10,
              _subColumn('订单配送收入', vm.incomeList),
              BaseGaps().vGap10,
              _divider(),
              BaseGaps().vGap10,
              _titleView('要求送达'),
              _gridViw(vm.timeList),
              BaseGaps().vGap10,
            ],
          )));

  Widget _subColumn(String title, List<NormalListItem> data) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _divider(),
        BaseGaps().vGap10,
        _titleView(title),
        _listViw(data),
        BaseGaps().vGap10
      ]);

  Widget _titleView(String title) =>
      Text(title, style: BaseUIUtil().getTheme().primaryTextTheme.displayLarge);

  Widget _listViw(List<NormalListItem> data) => ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data?.length,
      itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data?[index]?.primary ?? '',
                    style: BaseUIUtil().getTheme().primaryTextTheme.titleSmall),
                Text(data?[index]?.minor ?? '',
                    style: data?[index]?.minorStyle ??
                        BaseUIUtil().getTheme().primaryTextTheme.titleSmall)
              ],
            ),
          ));

  Widget _gridViw(List<NormalListItem> data) => GridView.builder(
      itemCount: data.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.w,
        crossAxisCount: 5,
      ),
      itemBuilder: (BuildContext context, int index) =>
          BaseWidgetUtil.getTextWithWidgetV(
              isCenter: true,
              primary: data[index].primary,
              primaryStyle:
                  BaseUIUtil().getTheme().primaryTextTheme.titleMedium,
              minor: data[index].minor,
              minorStyle:
                  BaseUIUtil().getTheme().primaryTextTheme.titleMedium));

  Widget addressView(OrderEntity? entity, int? listType) => Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50.w,
                child: BaseWidgetUtil.getTextWithWidgetV(
                  padding: 1,
                  isPrimaryTop: false,
                  isCenter: true,
                  primary: vm.getTopItemDistance() ?? '',
                  primaryStyle:
                      BaseUIUtil().getTheme().primaryTextTheme.titleSmall,
                  minorWidget: BaseImageUtil().getRawImg(
                      OrderUtil().getTopItemLeftPNG(vm?.orderEntity),
                      height: 20.r,
                      width: 20.r),
                ),
              ),
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
                              fontSize: 14.sp,
                              fontWeight: BaseDimens.fw_l,
                              color: BaseColors.c11111),
                        ),
                      ),
                      BaseGaps().hGap5,
                      _btnRow(
                          onTapNavi: () => vm.btn_gotoNavi(
                              entity!.fLat!, entity!.fLng!, entity.fName))
                    ]),
                    BaseGaps().vGap5,
                    Text(entity?.fAddr ?? '',
                        style: TextStyle(
                            fontSize: 12.sp, color: BaseColors.c828282))
                  ]))
            ]),
        BaseGaps().vGap10,
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseWidgetUtil.getTextWithWidgetV(
                padding: 1,
                isPrimaryTop: false,
                isCenter: true,
                primary: entity?.tDistanceStr?.toString() ?? '',
                primaryStyle:
                    BaseUIUtil().getTheme().primaryTextTheme.titleSmall,
                minorWidget: BaseImageUtil()
                    .getRawImg('app_song', height: 20.r, width: 20.r),
              ),
              BaseGaps().hGap15,
              Expanded(
                  child: Row(children: [
                Expanded(
                    child: Text(
                  entity?.tName ?? '',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: BaseDimens.fw_l,
                      color: BaseColors.c11111),
                )),
                BaseGaps().hGap5,
                _btnRow(
                    isIncludeChat: true,
                    onTapChat: () => vm.btn_gotoChat(),
                    onTapNavi: () => vm.btn_gotoNavi(
                        entity!.tLat!, entity!.tLng!, entity.tName))
              ]))
            ])
      ]);

  Widget _btnRow({bool isIncludeChat = false, onTapNavi, onTapChat}) =>
      Row(children: [
        // if (isIncludeChat)
        //   BaseWidgetUtil.getCircleButton(Icons.sms, onTapChat, size: 12.r),
        if (isIncludeChat) BaseGaps().hGap5,
        BaseWidgetUtil.getCircleButton(Icons.navigation_sharp, onTapNavi,
            size: 12.r),
        if (!isIncludeChat) Opacity(opacity: 0, child: BaseGaps().hGap5),
        if (!isIncludeChat)
          Opacity(
              opacity: 0,
              child: BaseWidgetUtil.getCircleButton(
                  Icons.navigation_sharp, onTapChat,
                  size: 12.r))
      ]);

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: BaseColors.ebebeb,
      );
}
