import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message, {Function(String code)? callback}) {}

class BaseSMSUtil {
  final telephony = Telephony.instance;

  BaseSMSUtil._internal();

  factory BaseSMSUtil() => _instance;

  static late final BaseSMSUtil _instance = BaseSMSUtil._internal();

  void observeSMS({Function(String? code)? callback}) async {
    bool hasReceive = false;
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != true) return;
    telephony.listenIncomingSms(
        // onBackgroundMessage: (SmsMessage msg) =>
        //     onBackgroundMessage(msg, callback: callback),
        listenInBackground: false,
        onNewMessage: (SmsMessage msg) {
          hasReceive = true;
          callback?.call(_getCode(msg.body));
        });
    await Future.delayed(const Duration(milliseconds: 10000));
    if (hasReceive == false) _querySMS();
    callback?.call(_getCode(await _querySMS()));
  }

  Future<String?> _querySMS() async {
    List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.BODY).like('%斗角%'),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)]);
    List<NormalListItem>? data = [];
    messages.forEach((item) {
      data.add(NormalListItem(
          primary: BaseDateUtil.formatDateMs(item.date!),
          minor: _getCode(item.body.toString())));
    });

    // BaseDialogUtil.showListBSLH(AppInitUtil().curContext!,
    //     title: '短信', titleCenter: false, topData: data);
    SmsMessage msg = messages[0];
    if (BaseDateUtil.curTimeMS - msg.date! > 1000 * 60 * 60)
      return messages[0].body;
    return null;
  }

  String? _getCode(String? msg) {
    if (ObjectUtil.isEmptyStr(msg)) return null;
    if (msg!.contains(AppConst.APP_NAME)) return null;

    RegExp regExp = RegExp(r'\d{6}');
    Match? match = regExp.firstMatch(msg!);
    if (match != null) return match.group(0);

    return null;
  }
}
