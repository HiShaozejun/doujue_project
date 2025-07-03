import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_string.dart';
import 'package:djqs/common/module/other/entity/qrcode_entity.dart';
import 'package:djqs/module/mine/viewmodel/scaninfo_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanInfoPage extends StatefulWidget {
  final QrcodeEntity? qrEntity;

  ScanInfoPage({super.key, this.qrEntity});

  @override
  _ScanInfoState createState() => _ScanInfoState();
}

class _ScanInfoState extends BasePageState<ScanInfoPage, ScanInfoVM> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => buildViewModel<ScanInfoVM>(
      appBar: BaseWidgetUtil.getAppbar(context, "识别结果"),
      create: (context) => ScanInfoVM(context, widget.qrEntity),
      viewBuild: (context, vm) => Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseGaps().vGap40,
                BaseWidgetUtil.getButtonCircleWithBorder(
                    size: 120.r,
                    url: AppUtil().parseAvatar(vm.scanData?.avatar)),
                BaseGaps().vGap30,
                infoView(),
              ],
            ),
          ));

  Widget infoView() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        itemView('昵       称：', vm.scanData?.nickname ?? '未设置'),
        BaseGaps().vGap15,
        if (!ObjectUtil.isEmptyStr(vm.scanData?.mobile))
          if (!ObjectUtil.isEmptyStr(vm.scanData?.mobile))
            itemView('手       机：',
                BaseStrUtil.getEncryptNumber(vm.scanData!.mobile!)),
        BaseGaps().vGap10,
        itemView('性       别：', vm.scanData?.sex == '1' ? '男' : '女'),
        BaseGaps().vGap15,
        itemView('注册时间：', ObjectUtil.strToZH_Wu(vm.dataStr))
      ]);

  Widget itemView(String title, String content) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text(title,
            style: TextStyle(
                fontSize: 22.r,
                fontWeight: BaseDimens.fw_l,
                color: BaseUIUtil()
                    .getTheme()
                    .primaryTextTheme
                    .displayLarge!
                    .color)),
        Text(content,
            style: TextStyle(
                fontSize: 22.r,
                fontWeight: BaseDimens.fw_m,
                color: BaseUIUtil()
                    .getTheme()
                    .primaryTextTheme
                    .displayLarge!
                    .color))
      ]);
}
