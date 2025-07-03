import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/common/module/login/util/account_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'register_page.dart';
import 'viewmodel/login_vm.dart';

//一种方式
// class LoginPage extends StatefulWidget {
//   final bool isCanBack;
//   LoginPage({this.isCanBack = true});
//   @override
//   _LoginPageState createState() => _LoginPageState(isCanBack: isCanBack);
// }
//
// class _LoginPageState extends State<LoginPage> {
//   bool isCanBack;
//   _LoginPageState({required this.isCanBack});
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class LoginPage extends RegisterPage {
  final bool? isCanBack;

  LoginPage({
    this.isCanBack = true,
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends RegisterState<LoginPage, LoginVM>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => buildViewModel<LoginVM>(
      safeArea: false,
      create: (context) => LoginVM(context),
      viewBuild: (context, vm) => DefaultTabController(
          length: 2,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              appBar: BaseWidgetUtil.getAppbar(
                context,
                "登录",
                showLeft: (widget as LoginPage).isCanBack!,
                onLeftCilck: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                },
                rightItem:
                    NormalListItem(rightType: ItemType.TEXT, suffixStr: '设置'),
                onRightClick: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  vm.btn_gotoSetting();
                },
              ),
              body: SafeArea(child: _bodyView()))));

  Widget _bodyView() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(children: [
        _tabTopView(),
        BaseGaps().vGap15,
        _tabBarView(),
        _bottomView()
      ]));

  Widget _bottomView() => Column(children: <Widget>[
        agreeView(),
        Container(
            margin: EdgeInsets.only(top: 5.h, bottom: 15.h),
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: vm.btn_gotoResetPwd,
              child: Text('忘记密码？',
                  style: BaseUIUtil().getTheme().primaryTextTheme.bodyMedium),
            )),
        BaseWidgetUtil.getBottomButton('登录', onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          vm.btn_login(_scaffoldKey.currentContext!);
        }, includeBottomMargin: false),
        BaseGaps().vGap8,
        // RichText(
        //     softWrap: true,
        //     text: TextSpan(children: [
        //       TextSpan(
        //           text: '还没有账号吗？',
        //           style: BaseUIUtil().getTheme().primaryTextTheme.bodyMedium),
        //       TextSpan(
        //         recognizer: vm.registerTapRecognizer,
        //         text: '点击注册',
        //         style: TextStyle(fontSize: 14.sp, color: BaseColors.e70012),
        //       )
        //     ]))
      ]);

  Widget _tabTopView() => TabBar(
          indicatorColor:
              BaseUIUtil().getTheme(context: context).indicatorColor,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 10.w),
          enableFeedback: false,
          tabs: <Widget>[
            Tab(
              text: '密码登录',
            ),
            Tab(text: '验证码登录')
          ]);

  Widget _tabBarView() => Container(
      height: 150.h,
      child: TabBarView(children: <Widget>[_passwordTabBody(), _smsTabBody()]));

  Widget _smsTabBody() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mobileView(),
          BaseGaps().vGap10,
          smscodeView(
              btn_smscode: () => vm.btn_smscode(AccountService.SMS_TYPE_LOGIN)),
          BaseGaps().vGap2,
          RichText(
              softWrap: true,
              text: TextSpan(children: [
                TextSpan(
                    text: '如果长期收不到验证码，请使用',
                    style: BaseUIUtil().getTheme().primaryTextTheme.bodySmall),
                TextSpan(
                  text: '密码登录',
                  style: TextStyle(fontSize: 12.sp, color: BaseColors.e70012),
                )
              ]))
        ],
      );

  Widget _passwordTabBody() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [mobileView(), BaseGaps().vGap10, passwordView()]);
}
