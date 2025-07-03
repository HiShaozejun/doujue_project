import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'viewmodel/user_profile_edit_vm.dart';

class UserProfileEditPage extends StatefulWidget {
  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState
    extends BasePageState<UserProfileEditPage, UserProfileEditVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<UserProfileEditVM>(
      appBar: BaseWidgetUtil.getAppbar(context, '用户信息'),
      create: (context) => UserProfileEditVM(context),
      viewBuild: (context, vm) => Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Column(children: [
            _topView(),
            BaseGaps().vGap10,
            _textView(),
            BaseGaps().vGap20,
            BaseWidgetUtil.getBottomButton('保存',
                onPressed: vm.btn_onSave, marginH: 15.w)
          ])));

  Widget _textView() => Row(children: [
        BaseGaps().hGap15,
        Text('昵 称',
            style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
        Text('*', style: TextStyle(fontSize: 14, color: BaseColors.e70012)),
        BaseGaps().hGap5,
        Expanded(
            child: TextField(
                controller: vm.textController,
                style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                autofocus: false,
                decoration:
                    InputDecoration(isCollapsed: true, hintText: '请输入昵称'),
                textInputAction: TextInputAction.done)),
        BaseGaps().hGap15
      ]);

  Widget _topView() => Column(children: [
        BaseWidgetUtil.getButtonCircleWithBorder(
            onTap: vm.btn_onAvatar,
            url: AppUtil().parseAvatar(vm.profileEntity?.avatar)),
        BaseGaps().vGap5,
        Text('数据表明招聘者对真实头像更有好感',
            style: BaseUIUtil().getTheme().primaryTextTheme.labelSmall),
        BaseGaps().vGap5,
        InkWell(
            onTap: vm.btn_onAvatar,
            child: Text('上传头像',
                style: TextStyle(fontSize: 14.sp, color: BaseColors.e70012)))
      ]);
}
