import 'package:djqs/app/app_util.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/module/purse/vm/withdrawl_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//to-do
class WithdrawlPage extends StatefulWidget {
  String? withdrawlValue;

  WithdrawlPage({required this.withdrawlValue});

  @override
  _WithdrawlPageState createState() => _WithdrawlPageState();
}

class _WithdrawlPageState extends BasePageState<WithdrawlPage, WithdrawalVM> {
  final FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) => buildViewModel<WithdrawalVM>(
        resizeToAvoidBottomInset: false,
        appBar: BaseWidgetUtil.getAppbar(context, "提现"),
        create: (context) => WithdrawalVM(context, widget.withdrawlValue),
        viewBuild: (context, vm) => Container(
            color: BaseUIUtil().getTheme().bottomSheetTheme.backgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView(children: [
                    _topView(),
                    BaseGaps().vGap10,
                    _withdrawalView(),
                    BaseGaps().vGap10,
                    _wxView(),
                    BaseGaps().vGap10,
                    _nameView(),
                    BaseGaps().vGap10,
                    _phoneView(),
                    BaseGaps().vGap10,
                    _codeView(),
                    descView(),
                  ]),
                ),
                BaseGaps().vGap10,
                BaseWidgetUtil.getBottomButton('提现',
                    onPressed: vm.btn_onWithdrawal,
                    marginH: 30.w,
                    includeBottomMargin: false),
                BaseGaps().vGap20
              ],
            )),
      );

  Widget _topView() => Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      color: BaseColors.ffffff,
      child: BaseWidgetUtil.getTextWithWidgetH('可提现金额',
          primaryStyle: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
          minor: Text('￥${AppUtil().formatYuan(vm.withdrawlValue)}',
              style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
          isLeft: false,
          space: 1.w));

  Widget _wxView() => _rowView(
        '提现至微信',
        paddingV: 10.h,
        rightChild: BaseWidgetUtil.getTextWithWidgetH('微信',
            minor: Icon(
              Icons.radio_button_checked,
              color: BaseColors.c00a0e7,
              size: 16.r,
            ),
            isLeft: true,
            space: 5,
            primaryStyle: TextStyle(
                fontWeight: BaseDimens.fw_l,
                color: BaseColors.c00a0e7,
                fontSize: 14.sp)),
      );

  Widget _withdrawalView() => Container(
      padding: EdgeInsets.only(top: 1.h, bottom: 1.h, left: 10.w, right: 10.w),
      color: BaseColors.ffffff,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('￥',
            style: TextStyle(
                color: BaseUIUtil()
                    .getTheme()
                    .primaryTextTheme
                    .displayMedium!
                    .color,
                fontSize: 25,
                fontWeight: BaseDimens.fw_m)),
        Expanded(
          child: _textField(vm.moneyController,
              hintStr: '请输入提现金额',
              labelStyle:
                  BaseUIUtil().getTheme().primaryTextTheme.displayLarge),
        ),
        InkWell(
            splashColor: BaseColors.trans,
            highlightColor: BaseColors.trans,
            child: Text('全部提现',
                style: TextStyle(
                    color: BaseColors.f29b2d,
                    fontSize: 12.sp,
                    fontWeight: BaseDimens.fw_m)),
            onTap: vm.btn_onAll)
      ]));

  Widget _phoneView() => Container(
      padding:
          EdgeInsets.only(top: 10.h, bottom: 10.h, left: 15.w, right: 15.w),
      color: BaseColors.ffffff,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          width: 95.w,
          child: Text('提现手机号',
              style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
        ),
        BaseGaps().hGap5,
        Expanded(
          child: Text(vm.phoneStr,
              style: BaseUIUtil().getTheme().primaryTextTheme.titleMedium),
        ),
        InkWell(
          splashColor: BaseColors.trans,
          highlightColor: BaseColors.trans,
          child: Text(vm.isCountDown() ? '${vm.countdown}s' : '发送验证码',
              style: TextStyle(
                  color: vm.isCountDown()
                      ? BaseUIUtil()
                          .getTheme()
                          .primaryTextTheme
                          .bodyMedium!
                          .color
                      : BaseColors.c2872fc,
                  fontSize: 14.sp)),
          onTap: () => vm.isCountDown() ? null : vm.btn_smscode(),
        )
      ]));

  Widget _nameView() => _rowView('提现用户名',
      paddingV: 1.h,
      rightChild: _textField(vm.nameController, hintStr: '请填写真实姓名'));

  Widget _codeView() => _rowView('请输入验证码',
      paddingV: 1.h,
      rightChild: _textField(vm.codeController, hintStr: '请输入验证码'));

  Widget _textField(TextEditingController controller,
          {TextStyle? labelStyle, String? hintStr, bool isOnlyNumber = true}) =>
      TextFormField(
        style:
            labelStyle ?? BaseUIUtil().getTheme().primaryTextTheme.titleMedium,
        keyboardType:
            isOnlyNumber == true ? TextInputType.phone : TextInputType.text,
        // inputFormatters: [
        //   FilteringTextInputFormatter.digitsOnly,
        //   LengthLimitingTextInputFormatter(6),
        // ],
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintStr,
          hintStyle: BaseUIUtil().getTheme().primaryTextTheme.labelMedium,
        ),
        textInputAction: TextInputAction.next,
      );

  Widget _rowView(String title, {Widget? rightChild, double? paddingV}) =>
      Container(
        padding:
            EdgeInsets.symmetric(vertical: paddingV ?? 5.h, horizontal: 15.w),
        color: BaseColors.ffffff,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 95.w,
            child: Text(title,
                style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
          ),
          BaseGaps().hGap5,
          Expanded(child: rightChild ?? Container())
        ]),
      );

  Widget descView() => BaseWidgetUtil.getContainer(
        paddingV: 10.h,
        paddingH: 10.w,
        marginL: 10.w,
        marginR: 10.w,
        marginT: 10.h,
        marginB: 10.h,
        color: BaseColors.fff0f0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(vm.descEntity?.notice?.header ?? '',
              style: BaseUIUtil().getTheme().primaryTextTheme.bodyMedium),
          BaseGaps().vGap10,
          Text((vm.descEntity?.notice?.content ?? '').replaceAll(' ', ''),
              style: BaseUIUtil().getTheme().primaryTextTheme.labelSmall),
          BaseGaps().vGap10,
          Text(vm.descEntity?.notice?.footer ?? '',
              style: BaseUIUtil().getTheme().primaryTextTheme.labelSmall),
          BaseGaps().vGap10,
          BaseWidgetUtil.getTextWithWidgetH('继续提现（已知晓风险）',
              primaryStyle: TextStyle(
                  fontWeight: BaseDimens.fw_l,
                  fontSize: 14.sp,
                  color: vm.isAgree ? BaseColors.c2872fc : BaseColors.c606069),
              minor: Icon(
                vm.isAgree
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: vm.isAgree ? BaseColors.c2872fc : BaseColors.c606069,
                size: 20.r,
              ),
              onTap: vm.btn_checkAgreement,
              space: 5.w),
        ]),
      );
}
