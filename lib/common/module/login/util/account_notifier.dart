import 'package:djqs/base/frame/base_global_notifier.dart';
import 'package:flutter/material.dart';

class AccountNotifier extends BaseGlobalNotifier {
  // final _service = AccountService();
  // final viewStates = AccountViewState();

  AccountNotifier(super.context);

  @override
  void init() {}

  void requestAccountData(Function callback) {
    // _service.getAccountInfoAsync().then((value) {
    //   updateAccountStatus(value, true);
    // }).catchError((error)  {
    //   // 登陆token失效
    //   if (error is HttpException &&
    //       error.message == ApiConstants.REQUEST_TOKEN_ERROR_MESSAGE) {
    //     updateAccountStatus(null, false);
    //     return;
    //   }
    //   // 获取本地数据
    //   var localAccount = await Preferences.getCache(
    //       ThemeAccount.constants.accountData,
    //       (json) => AccountData.fromJson(json));
    //   updateAccountStatus(localAccount, localAccount != null);
    // }).whenComplete(() => callback());
  }

// void requestLogout(BuildContext context) {
//   _accountService.getLogoutAsync().then((value) {
//     updateAccountStatus(null, false);
//     Toast.show(ThemeAccount.strings.logoutSuccess);
//   }).catchError((onError) {
//     onFailedToast(onError);
//   }).whenComplete(() => Navigator.pop(context));
// }
//
// void updateAccountStatus(AccountData? accountData, bool isLogin) {
//   Preferences.saveCache(ThemeAccount.constants.accountData, accountData);
//   Preferences.save(ThemeCommon.constants.isLogin, isLogin);
//   viewStates.accountData = accountData;
//   viewStates.isLogin = isLogin;
//   notifyListeners();
// }
}

extension AccountContextExtensions on BuildContext {
  // String userKey(String key) {
  //   return "$key${read<AccountService>().viewStates.userId}";
  // }
}
