import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/setting/volume_setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'viewmodel/setting_vm.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends BasePageState<SettingPage, SettingVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<SettingVM>(
        appBar: BaseWidgetUtil.getAppbar(context, "设置"),
        create: (context) => SettingVM(context),
        viewBuild: (context, vm) => Column(
          children: [
            BaseGaps().vGap10,
            Padding(padding: EdgeInsets.only(left: 15.w,right:15.w,bottom: 5.h),child: VolumeSettingWidget()),
            Divider(),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vm.listData.length,
                  itemBuilder: (context, index) {
                    return BaseWidgetUtil.getHorizontalListItem(
                        index,
                        itemHPadding: 15.w,
                        divider: Divider(height: 1),
                        showDivider: true,
                        onItemClick: () => vm.btn_onListItemClick(
                            vm.listData[index].type as SettingType, index),
                        vm.listData[index]);
                  }),
            ),
            BaseGaps().vGap20,
            BaseWidgetUtil.getButton(
                color: BaseColors.trans,
                onTap: vm.btn_onFile,
                text: 'ICP备案号：京ICP备19049464号-7A >',
                textStyle: BaseUIUtil().getTheme().primaryTextTheme.bodyMedium),
            BaseGaps().vGap5,
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '北京斗角科技有限公司',
                      style:
                          BaseUIUtil().getTheme().primaryTextTheme.bodyMedium),
                  TextSpan(
                      text: ' 版权',
                      style: BaseUIUtil().getTheme().textTheme.bodySmall,
                      recognizer: vm.tapRecognizer),
                  TextSpan(
                      text: '所有',
                      style: BaseUIUtil().getTheme().textTheme.bodySmall)
                ],
              ),
            ),
            BaseGaps().vGap30
          ],
        ),
      );
}
