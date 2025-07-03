import 'package:djqs/app/netDuo/base_service_duo.dart';
import 'package:djqs/base/net/base_entity.dart';
import 'package:djqs/base/net/base_net_const.dart';
import 'package:djqs/base/net/base_service.dart';
import 'package:djqs/module/purse/entity/billlist_entity.dart';
import 'package:djqs/module/purse/entity/check_withdrawl_entity.dart';
import 'package:djqs/module/purse/entity/mpqrcode_entity.dart';
import 'package:djqs/module/purse/entity/purse_entity.dart';
import 'package:djqs/module/purse/entity/purse_today_entity.dart';
import 'package:djqs/module/purse/entity/withdrawal_result_entity.dart';

class PurseService extends BaseService {
  Future<dynamic> getPurseRecord( page,{String? startTime, String? endTime, dayKey}) =>
      requestSync(
          data: {
            'start_time': startTime,
            'end_time': endTime,
            'date_key': dayKey,
            'p': page
          },
          path: "${BaseNetConst().commonUrl}Rider.Balance.GetRecord",
          create: (resource) => PurseListEntity().parseList(resource));

  Future<dynamic?> sendSmS() => requestSync(
      path: "${BaseNetConst().commonUrl}Rider.Cash.GetCode",
      create: (resource) => resource);

  Future<FuncEntity?> sendWithDrawal(
          String? money, String? code, String? name) =>
      requestSync(
          returnBaseEntity: true,
          data: {
            'money': money,
            'account': '',
            'code': code,
            'name': name,
            'type': WithdrawalResultEntity.PAY_TYPE_WX
          },
          path: "${BaseNetConst().commonUrl}Rider.Cash.Set",
          create: (resource) => resource);
}

class PurseServiceDuo extends BaseServiceDuo {
  Future<CheckWithdrawlEntity?> checkWithdrawl() => requestSync(
      showLoading: false,
      path: "${BaseNetConst().commonUrl}Rider.Withdrawal.GetChannelList",
      create: (resource) => CheckWithdrawlEntity.fromJson(resource));

  Future<MPQRcodeEntity?> getMPQrcode() => requestSync(
      showLoading: false,
      data: {'page': 'subPackage/Mypurse/Withdrawal/index', 'scene': '123d'},
      path: "${BaseNetConst().commonUrl}Rider.Wechat.GetWxACode",
      create: (resource) => MPQRcodeEntity.fromJson(resource));

  Future<PurseEntity?> getPurseData() => requestSync(
      showLoading: false,
      path: "${BaseNetConst().commonUrl}Rider.Balance.Summary",
      create: (resource) => PurseEntity.fromJson(resource));


  Future<BillListEntity?> getBillList() => requestSync(
      showLoading: false,
      path: "${BaseNetConst().commonUrl}Rider.Balance.BillList",
      create: (resource) => BillListEntity.fromJson(resource));
}
