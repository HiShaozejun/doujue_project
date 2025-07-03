import 'package:djqs/base/ui/paging/paging_data.dart';

class PurseItemEntity {
  static const String PUSER_TYPE_ADD = "1";
  static const String PUSER_TYPE_REDUCE = "2";

/*
{
  "id": "471",
  "type": "1",
  "action": "1",
  "uid": "21",
  "actionid": "1076",
  "nums": "1",
  "total": "4.50",
  "addtime": "1745563452",
  "balance": "28.50",
  "orderno": "53_250422085821515",
  "action_txt": "配送收入",
  "add_time": "04月25日 14:44"
}
*/

  String? id;
  String? type;
  String? action;
  String? uid;
  String? actionid;
  String? nums;
  String? total;
  String? addtime;
  String? balance;
  String? orderno;
  String? actionTxt;
  String? addTime;

  PurseItemEntity({
    this.id,
    this.type,
    this.action,
    this.uid,
    this.actionid,
    this.nums,
    this.total,
    this.addtime,
    this.balance,
    this.orderno,
    this.actionTxt,
    this.addTime,
  });

  PurseItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    type = json['type']?.toString();
    action = json['action']?.toString();
    uid = json['uid']?.toString();
    actionid = json['actionid']?.toString();
    nums = json['nums']?.toString();
    total = json['total']?.toString();
    addtime = json['addtime']?.toString();
    balance = json['balance']?.toString();
    orderno = json['orderno']?.toString();
    actionTxt = json['action_txt']?.toString();
    addTime = json['add_time']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['action'] = action;
    data['uid'] = uid;
    data['actionid'] = actionid;
    data['nums'] = nums;
    data['total'] = total;
    data['addtime'] = addtime;
    data['balance'] = balance;
    data['orderno'] = orderno;
    data['action_txt'] = actionTxt;
    data['add_time'] = addTime;
    return data;
  }

  String get totalVale => this.type == PUSER_TYPE_ADD
      ? "+" + total.toString()
      : "-" + total.toString();
}

class PurseListEntity extends PagingData<PurseItemEntity> {
  List<PurseItemEntity>? list;
  int total = 0;

  parseList(List<dynamic> jsonList) {
    List<dynamic> data = jsonList;
    this.list = data
        .map((e) => PurseItemEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    return this;
  }

  @override
  int getDataTotalCount() => 10;


  @override
  List<PurseItemEntity>? getDataSource() => list;
}
