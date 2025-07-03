import 'package:djqs/base/frame/base_notifier.dart';

class ChatVM extends BaseNotifier {
  ChatVM(super.context);

  @override
  void init() {}

  @override
  void onCleared() {}

  void btn_gotoReport() {
   // BaseRouteUtil.push(baseContext!, ChatReportPage(isFromNative: true));
  }
}
