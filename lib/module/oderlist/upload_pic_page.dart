import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/oderlist/vm/upload_pic_vm.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadPicPage extends StatefulWidget {
  int? uploadType;

  UploadPicPage({super.key, required this.uploadType});

  @override
  _TTPhotoEditState createState() => _TTPhotoEditState();
}

class _TTPhotoEditState extends BasePageState<UploadPicPage, UploadPicVM> {
  @override
  Widget build(BuildContext context) {
    return buildViewModel<UploadPicVM>(
        resizeToAvoidBottomInset: false,
        appBar: BaseWidgetUtil.getAppbar(context,
            '${widget.uploadType == UploadPicVM.UPLOAD_TYPE_SEND ? '送达' : '异常'}图片上传'),
        create: (context) =>
            UploadPicVM(context, uploadType: widget.uploadType),
        viewBuild: (context, vm) {
          return _body();
        });
  }

  Widget _body() => Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BaseGaps().vGap10,
        Text(
            '为了保证服务质量，${vm.uploadType == UploadPicVM.UPLOAD_TYPE_SEND ? '送达' : '异常报备'}需要提供1-3张照片',
            style: BaseUIUtil().getTheme().primaryTextTheme.labelMedium),
        BaseGaps().vGap20,
        _imagsView(),
        BaseGaps().vGap30,
        Text(vm.typeInfoStr,
            style: BaseUIUtil().getTheme().primaryTextTheme.titleMedium),
        BaseGaps().vGap10,
        typeView(),
        BaseGaps().vGap10,
        if (vm.isShowTF())
          Text('请填写备注：',
              style: BaseUIUtil().getTheme().primaryTextTheme.titleMedium),
        if (vm.isShowTF()) BaseGaps().vGap5,
        if (vm.isShowTF()) _textInputView(),
        Expanded(child: Container()),
        BaseGaps().vGap10,
        BaseWidgetUtil.getBottomButton('确认提交', onPressed: vm.btn_upload),
      ]));

  Widget typeView() => InkWell(
      onTap: () => showPickerForType(context,
          onItemPick: (Picker picker, List<int> selected) =>
              vm.btn_onItemPick(selected)),
      child: BaseWidgetUtil.getContainer(
          circular: 5.r,
          paddingH: 5.w,
          borderColor: BaseColors.ebebeb,
          aligment: Alignment.topCenter,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(vm.typeStr,
                style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
            BaseWidgetUtil.getButton(
                color: BaseColors.trans,
                paddingV: 5.h,
                borderColor: BaseColors.trans,
                child: Icon(Icons.keyboard_arrow_down_outlined,
                    size: 20.r, color: BaseColors.c4f4f4f),
                onTap: () {}),
          ])));

  void showPickerForType(BuildContext context,
          {required PickerConfirmCallback? onItemPick}) =>
      vm.uploadType == UploadPicVM.UPLOAD_TYPE_SEND
          ? showPicker(context,
              PickerDataAdapter<String>(pickerData: vm.sendPickerData!)!,
              selecteds: vm.pickIndexes ?? [0], onItemPick: onItemPick)
          : showPicker(
              context, PickerDataAdapter<String>(data: vm.errorPickerData!),
              selecteds: vm.pickIndexes ?? [0, 0], onItemPick: onItemPick);

  void showPicker(BuildContext context, PickerDataAdapter adapter,
      {List<int>? selecteds, required PickerConfirmCallback? onItemPick}) {
    Picker(
            adapter: adapter,
            selecteds: selecteds,
            backgroundColor:
                BaseUIUtil().getTheme().bottomSheetTheme.backgroundColor,
            headerColor:
                BaseUIUtil().getTheme().bottomSheetTheme.backgroundColor,
            // textStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
            // selectedTextStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
            // cancelTextStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
            // confirmTextStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
            cancelText: '取消',
            confirmText: '确定',
            textAlign: TextAlign.right,
            onConfirm: onItemPick)
        .showModal(context);
  }

  Widget _textInputView() => Stack(children: [
        BaseWidgetUtil.getContainer(
            color: BaseColors.c9c9c9,
            paddingH: 1.5.w,
            paddingV: 1.5.h,
            circular: 3.r,
            borderWidth: 1,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              onChanged: (String value) {
                vm.desc = value;
                setState(() {});
              },
              controller: vm.textController,
              decoration: InputDecoration(
                  hintText: '请输入具体异常原因',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  filled: true,
                  fillColor: BaseColors.ffffff),
            )),
        Positioned(
            bottom: 7.h,
            right: 7.w,
            child: Text(
                '${(vm.desc?.length ?? 0).toString()}/${AppConst.LIMIT_TEXT_COUNT}字',
                style: TextStyle(fontSize: 14.sp, color: BaseColors.a4a4a4)))
      ]);

  Widget _imagsView() => Wrap(
      spacing: 5.w,
      runSpacing: 5.h,
      children: vm.images.map((item) => _imageView(item)).toList());

  Widget _imageView(String url) => Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.r, right: 10.r),
            child: InkWell(
                onTap: () =>
                    url == '' ? vm.btn_onAdd() : vm.btn_onShowImage(url),
                child: DottedBorder(
                  dashPattern: [10, 5],
                  strokeWidth: 2,
                  color: BaseColors.dad8d8,
                  padding: EdgeInsets.all(16.r),
                  child: Container(
                      width: 80.r,
                      height: 80.r,
                      child: url == ''
                          ? BaseWidgetUtil.getTextWithWidgetV(
                              isPrimaryTop: false,
                              isCenter: true,
                              primary: '上传图片',
                              primaryStyle: BaseUIUtil()
                                  .getTheme()
                                  .primaryTextTheme
                                  .labelMedium,
                              minorWidget: Icon(
                                Icons.camera_alt_outlined,
                                color: BaseColors.dad8d8,
                                size: 40.r,
                              ))
                          : BaseImageUtil().getCachedImageWidget(
                              url: url, fit: BoxFit.cover)),
                )),
          ),
          if (url != '')
            Positioned(
                right: 0,
                child: InkWell(
                  onTap: () => vm.btn_onItemDelete(url),
                  child: Icon(
                    Icons.close,
                    color: BaseColors.c747474,
                    size: 20.r,
                  ),
                ))
        ],
      );
}
