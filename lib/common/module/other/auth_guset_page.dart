import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:djqs/common/module/login/util/util_account.dart';
import 'package:djqs/common/module/other/viewmodel/auth_vm.dart';
import 'package:djqs/common/util/common_util_auth_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthGuestPage extends StatefulWidget {
  AuthEntity? authEntity;

  AuthGuestPage({super.key, this.authEntity});

  @override
  _AuthGuestPageState createState() => _AuthGuestPageState();
}

class _AuthGuestPageState extends BasePageState<AuthGuestPage, AuthVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<AuthVM>(
      appBar: BaseWidgetUtil.getInVisbileAppbar(),
      create: (context) => AuthVM(context, widget.authEntity),
      viewBuild: (context, vm) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              BaseWidgetUtil.getButton(
                  color: BaseColors.trans,
                  paddingH: 5.h,
                  paddingV: 5.w,
                  borderColor: BaseColors.trans,
                  child: Text('关闭',
                      style:
                          BaseUIUtil().getTheme().primaryTextTheme.titleLarge),
                  onTap: () => BaseSystemUtil().exitApp()),
              BaseGaps().vGap20,
              Row(children: [
                BaseWidgetUtil.getTextWithWidgetH(vm.authEntity?.appName ?? '',
                    primaryStyle:
                        BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                    minor: BaseImageUtil().getCachedImageWidgetSized(
                        width: 30.r,
                        height: 30.r,
                        url: vm.authEntity?.appIcon,
                        showPlaceHolderImg: false),
                    space: 5.w),
                BaseGaps().hGap15,
                Text('申请使用',
                    style: BaseUIUtil().getTheme().textTheme.titleMedium)
              ]),
              BaseGaps().vGap10,
              Text('获取你的昵称、头像',
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 18.sp,
                      color: BaseUIUtil()
                          .getTheme()
                          .primaryTextTheme
                          .displayMedium!
                          .color,
                      fontWeight: BaseDimens.fw_l_x)),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: BaseWidgetUtil.getTextWithWidgetV(
                          isCenter: true,
                          primary: ObjectUtil.strToZH_Wu(
                              AccountUtil().getAccount()?.userNickname),
                          primaryStyle:
                              BaseUIUtil().getTheme().textTheme.titleLarge,
                          minorWidget: BaseWidgetUtil.getButtonCircleWithBorder(
                              url: AppUtil().parseAvatar(
                                  AccountUtil().getAccount()?.avatar),
                              size: 70.h),
                          padding: 5.h))),
              BaseWidgetUtil.getBottomButton('允许',
                  includeBottomMargin: false,
                  onPressed: vm.btn_onPos,
                  marginH: 50.w),
              BaseGaps().vGap20,
              BaseWidgetUtil.getBottomButton('拒绝',
                  onPressed: vm.btn_onNeg,
                  backgroudColor: BaseColors.a4a4a4,
                  marginH: 50.w),
              BaseGaps().vGap15
            ]),
          ));
}
