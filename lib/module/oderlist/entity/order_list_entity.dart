import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/ui/paging/paging_data.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_num.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/util/util_string.dart';

class OrderEntityProductProductAttr {
  String? attrName;
  String? useAttrName;

  OrderEntityProductProductAttr({
    this.attrName,
    this.useAttrName,
  });

  OrderEntityProductProductAttr.fromJson(Map<String, dynamic> json) {
    attrName = json['attr_name']?.toString();
    useAttrName = json['use_attr_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attr_name'] = attrName;
    data['use_attr_name'] = useAttrName;
    return data;
  }
}

class OrderEntityProductProduct {
  String? name;
  String? useName;

  OrderEntityProductProduct({
    this.name,
    this.useName,
  });

  OrderEntityProductProduct.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    useName = json['use_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['use_name'] = useName;
    return data;
  }
}

class OrderEntityProduct {
  int? productId;
  int? cartNum;
  OrderEntityProductProduct? product;
  OrderEntityProductProductAttr? productAttr;

  OrderEntityProduct({
    this.productId,
    this.cartNum,
    this.product,
    this.productAttr,
  });

  OrderEntityProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toInt();
    cartNum = json['cart_num']?.toInt();
    product = (json['product'] != null)
        ? OrderEntityProductProduct.fromJson(json['product'])
        : null;
    productAttr = (json['productAttr'] != null)
        ? OrderEntityProductProductAttr.fromJson(json['productAttr'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['cart_num'] = cartNum;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (productAttr != null) {
      data['productAttr'] = productAttr!.toJson();
    }
    return data;
  }
}

class OrderEntityStoreIm {
  String? userId;

  OrderEntityStoreIm({
    this.userId,
  });

  OrderEntityStoreIm.fromJson(Map<String, dynamic>? json) {
    userId = json?['userId']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    return data;
  }
}

class OrderEntityUsersIm {
  String? userId;

  OrderEntityUsersIm({
    this.userId,
  });

  OrderEntityUsersIm.fromJson(Map<String, dynamic>? json) {
    userId = json?['userId']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    return data;
  }
}

class OrderEntityExtraComputed {
  // double? moneyBasic;
  String? moneyBasicTxt;
  double? moneyDistance;
  String? moneyDistanceTxt;
  int? moneyWeight;
  String? moneyWeightTxt;
  double? distance;
  int? weight;
  double? discountRate;
  double? discountMoney;

  OrderEntityExtraComputed({
    // this.moneyBasic,
    this.moneyBasicTxt,
    this.moneyDistance,
    this.moneyDistanceTxt,
    this.moneyWeight,
    this.moneyWeightTxt,
    this.distance,
    this.weight,
    this.discountRate,
    this.discountMoney,
  });

  OrderEntityExtraComputed.fromJson(Map<String, dynamic> json) {
    // moneyBasic = json['money_basic']?.toDouble();
    moneyBasicTxt = json['money_basic_txt']?.toString();
    // moneyDistance = json['money_distance']?.toDouble();
    moneyDistanceTxt = json['money_distance_txt']?.toString();
    moneyWeight = json['money_weight']?.toInt();
    moneyWeightTxt = json['money_weight_txt']?.toString();
    // distance = json['distance']?.toDouble();
    weight = json['weight']?.toInt();
    // discountRate = json['discount_rate']?.toDouble();
    // discountMoney = json['discount_money']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['money_basic'] = moneyBasic;
    data['money_basic_txt'] = moneyBasicTxt;
    data['money_distance'] = moneyDistance;
    data['money_distance_txt'] = moneyDistanceTxt;
    data['money_weight'] = moneyWeight;
    data['money_weight_txt'] = moneyWeightTxt;
    data['distance'] = distance;
    data['weight'] = weight;
    data['discount_rate'] = discountRate;
    data['discount_money'] = discountMoney;
    return data;
  }
}

class OrderEntityExtra {
  double? distance;

  // int? weight;
  // int? cateid;
  String? catename;
  OrderEntityExtraComputed? computed;
  double? deliveryMoneyTotal;
  int? deliveryDiscountMoney;
  double? deliveryMoneyTotalRider;
  String? deliverySubsidyMoneyRider;
  double? merSerFee;
  String? timemoney;
  String? length;
  int? tradeNo;
  String? orderType;
  int? orderNum;
  String? storeId;

  OrderEntityExtra(
      {this.distance,
      // this.weight,
      // this.cateid,
      this.catename,
      this.computed,
      this.deliveryMoneyTotal,
      this.deliveryDiscountMoney,
      this.deliveryMoneyTotalRider,
      this.deliverySubsidyMoneyRider,
      this.merSerFee,
      this.timemoney,
      this.length,
      this.tradeNo,
      this.orderType,
      this.orderNum,
      this.storeId});

  OrderEntityExtra.fromJson(Map<String, dynamic> json) {
    // distance = json['distance']?.toDouble();
    // weight = json['weight']?.toInt();
    // cateid = json['cateid']?.toInt();
    catename = json['catename']?.toString();
    computed = (json['computed'] != null)
        ? OrderEntityExtraComputed.fromJson(json['computed'])
        : null;
    // deliveryMoneyTotal = json['delivery_money_total']?.toDouble();
    deliveryDiscountMoney = json['delivery_discount_money']?.toInt();
    // deliveryMoneyTotalRider = json['delivery_money_total_rider']?.toDouble();
    deliverySubsidyMoneyRider =
        json['delivery_subsidy_money_rider']?.toString();
    // merSerFee = json['mer_ser_fee']?.toDouble();
    timemoney = json['timemoney']?.toString();
    length = json['length']?.toString();
    // tradeNo = json['trade_no']?.toInt();
    orderType = json['order_type']?.toString();
    // orderNum = json['order_num']?.toInt();
    storeId = json['store_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['distance'] = distance;
    // data['weight'] = weight;
    // data['cateid'] = cateid;
    data['catename'] = catename;
    if (computed != null) {
      data['computed'] = computed!.toJson();
    }
    data['delivery_money_total'] = deliveryMoneyTotal;
    data['delivery_discount_money'] = deliveryDiscountMoney;
    data['delivery_money_total_rider'] = deliveryMoneyTotalRider;
    data['delivery_subsidy_money_rider'] = deliverySubsidyMoneyRider;
    data['mer_ser_fee'] = merSerFee;
    data['timemoney'] = timemoney;
    data['length'] = length;
    data['trade_no'] = tradeNo;
    data['order_type'] = orderType;
    data['order_num'] = orderNum;
    data['store_id'] = storeId;
    return data;
  }
}

class OrderEntity {
/*
{
  "id": "1029",
  "store_oid": "0",
  "type": "6",
  "cityid": "33",
  "channel": "",
  "channel_money": "0.00",
  "rider_money_total": "4.50",
  "rider_calc_money_total": "0.00",
  "d_channel": "",
  "fee": "0.00",
  "servicetime": "1744975585",
  "des": "【JD312820679713】 缺货时电话与我沟通 ",
  "paytype": "11",
  "orderno": "53_250418192625662",
  "trade_no": "312820679713",
  "pay_trade_no": "",
  "status": "4",
  "canceltime": "0",
  "sendtime": "0",
  "refundtime": "0",
  "pre_start_delivery_time": "2025-04-08 14:24:00",
  "pre_end_delivery_time": "2025-04-08 15:09:00",
  "source": "3",
  "f_name": "大炸院羊杂面小吃店",
  "f_addr": "辽宁省鞍山市海城市腾鳌镇保安中兴小区8",
  "f_lng": "122.824406",
  "f_lat": "41.076228",
  "t_name": "辽宁鞍山市海城市腾鳌镇祥和人家2期3号楼3单元",
  "t_addr": "辽宁鞍山市海城市腾鳌镇祥和人家2期3号楼3单元",
  "t_lng": "122.827079",
  "t_lat": "41.074629",
  "riderid": "21",
  "extra": {
    "distance": 1,
    "weight": 1,
    "cateid": 2,
    "catename": "外卖",
    "computed": {
      "money_basic": 6,
      "money_basic_txt": "(2km)",
      "money_distance": 0,
      "money_distance_txt": "",
      "money_weight": 0,
      "money_weight_txt": "",
      "distance": 0.29,
      "weight": 0,
      "discount_rate": -1,
      "discount_money": -1
    },
    "delivery_money_total": 6.1,
    "delivery_discount_money": 0,
    "delivery_money_total_rider": 4.5,
    "delivery_subsidy_money_rider": "0.5",
    "mer_ser_fee": 0.1,
    "timemoney": "0",
    "length": "30",
    "trade_no": 312820679713,
    "order_type": "jd",
    "order_num": 76,
    "store_id": "42"
  },
  "pick_name": "18888880004",
  "pick_phone": "18888880004",
  "recip_name": "涵**",
  "recip_phone": "17896224372,9151",
  "thumbs": [
    null
  ],
  "isdel": "0",
  "deltime": "0",
  "istrans": "0",
  "transtime": "0",
  "oldriderid": "21",
  "sys_rider_income": "0.00",
  "commission_type": "0",
  "fixed_money": "0.00",
  "substation_rate": "0.00",
  "rider_add": "0.00",
  "is_system": "0",
  "reminder_count": "0",
  "reminder_content": "",
  "is_now": "1",
  "is_cancel": "0",
  "is_mer": "1",
  "refund_order_id": "",
  "refund_result": "",
  "time_out": "0",
  "reach_store_time": "1747562861",
  "dispatch_trans": "0",
  "dispatch_riderid": "0",
  "dispatch_transtime": "0",
  "dispatch_time": "0",
  "mer_take": "1",
  "update_time": "2025-05-18 18:08:24",
  "pay_type": "",
  "type_t": "外卖",
  "users_im": {
    "userId": "users_53"
  },
  "meal_time_text": 0,
  "store_im": {},
  "tips": "",
  "over_time": "已超时29日23时22分58秒",
  "service_time": "立即取件",
  "add_time": "19:26",
  "order_type_desc": "京东",
  "order_type": "jd",
  "order_num": "76",
  "trans_time": "",
  "grap_time": "2025-04-20 15:54",
  "pick_time": "2025-05-18 18:08",
  "complete_time": "",
  "reach_store_time2": "18:07",
  "grap_time2": "15:54",
  "pick_time2": "18:08",
  "complete_time2": "",
  "isevaluate": "0",
  "ispre": "0",
  "rider_basic": 6,
  "rider_distance": 0,
  "rider_weight": 0,
  "rider_length": 0,
  "rider_prepaid": 0,
  "rider_timemoney": "0",
  "rider_fee": "0.00",
  "income": 4.5,
  "base_income": 4,
  "product": [
    {
      "product_id": 2585075865,
      "cart_num": 2,
      "product": {
        "name": "冰红茶 1瓶",
        "use_name": "冰红茶 1瓶"
      },
      "productAttr": {
        "attr_name": "",
        "use_attr_name": ""
      }
    }
  ],
  "expect_time": ""
}
*/

  String? id;
  String? storeOid;
  String? type;
  String? cityid;
  String? channel;
  String? channelMoney;
  String? riderMoneyTotal;
  String? riderCalcMoneyTotal;
  String? dChannel;
  String? fee;
  String? servicetime;
  String? des;
  String? paytype;
  String? orderno;
  String? tradeNo;
  String? payTradeNo;
  String? status;
  String? canceltime;
  String? sendtime;
  String? refundtime;
  String? preStartDeliveryTime;
  String? preEndDeliveryTime;
  String? source;
  String? fName;
  String? fAddr;
  String? fLng;
  String? fLat;
  String? tName;
  String? tAddr;
  String? tLng;
  String? tLat;
  String? riderid;
  OrderEntityExtra? extra;
  String? pickName;
  String? pickPhone;
  String? recipName;
  String? recipPhone;
  List<String?>? thumbs;
  String? isdel;
  String? deltime;
  String? istrans;
  String? transtime;
  String? oldriderid;
  String? sysRiderIncome;
  String? commissionType;
  String? fixedMoney;
  String? substationRate;
  String? riderAdd;
  String? isSystem;
  String? reminderCount;
  String? reminderContent;
  String? isNow;
  String? isCancel;
  String? isMer;
  String? refundOrderId;
  String? refundResult;
  String? timeOut;
  String? reachStoreTime;
  String? dispatchTrans;
  String? dispatchRiderid;
  String? dispatchTranstime;
  String? dispatchTime;
  String? merTake;
  String? updateTime;
  String? payType;
  String? typeT;
  OrderEntityUsersIm? usersIm;
  int? mealTimeText;
  OrderEntityStoreIm? storeIm;
  String? tips;
  String? overTime;
  String? serviceTime;
  String? addTime;
  String? orderTypeDesc;
  String? orderType;
  String? orderNum;
  String? transTime;
  String? grapTime;
  String? pickTime;
  String? completeTime;
  String? reachStoreTime2;
  String? grapTime2;
  String? pickTime2;
  String? completeTime2;
  String? isevaluate;
  String? ispre;
  int? riderBasic;
  double? riderDistance;
  int? riderWeight;
  double? riderLength;
  int? riderPrepaid;
  String? riderTimemoney;
  String? riderFee;
  double? income;
  double? baseIncome;
  List<OrderEntityProduct?>? product;
  String? expectTime;
  String? exceptionReport;
  String? distance;

  OrderEntity(
      {this.id,
      this.storeOid,
      this.type,
      this.cityid,
      this.channel,
      this.channelMoney,
      this.riderMoneyTotal,
      this.riderCalcMoneyTotal,
      this.dChannel,
      this.fee,
      this.servicetime,
      this.des,
      this.paytype,
      this.orderno,
      this.tradeNo,
      this.payTradeNo,
      this.status,
      this.canceltime,
      this.sendtime,
      this.refundtime,
      this.preStartDeliveryTime,
      this.preEndDeliveryTime,
      this.source,
      this.fName,
      this.fAddr,
      this.fLng,
      this.fLat,
      this.tName,
      this.tAddr,
      this.tLng,
      this.tLat,
      this.riderid,
      this.extra,
      this.pickName,
      this.pickPhone,
      this.recipName,
      this.recipPhone,
      this.thumbs,
      this.isdel,
      this.deltime,
      this.istrans,
      this.transtime,
      this.oldriderid,
      this.sysRiderIncome,
      this.commissionType,
      this.fixedMoney,
      this.substationRate,
      this.riderAdd,
      this.isSystem,
      this.reminderCount,
      this.reminderContent,
      this.isNow,
      this.isCancel,
      this.isMer,
      this.refundOrderId,
      this.refundResult,
      this.timeOut,
      this.reachStoreTime,
      this.dispatchTrans,
      this.dispatchRiderid,
      this.dispatchTranstime,
      this.dispatchTime,
      this.merTake,
      this.updateTime,
      this.payType,
      this.typeT,
      this.usersIm,
      this.mealTimeText,
      this.storeIm,
      this.tips,
      this.overTime,
      this.serviceTime,
      this.addTime,
      this.orderTypeDesc,
      this.orderType,
      this.orderNum,
      this.transTime,
      this.grapTime,
      this.pickTime,
      this.completeTime,
      this.reachStoreTime2,
      this.grapTime2,
      this.pickTime2,
      this.completeTime2,
      this.isevaluate,
      this.ispre,
      this.riderBasic,
      this.riderDistance,
      this.riderWeight,
      this.riderLength,
      this.riderPrepaid,
      this.riderTimemoney,
      this.riderFee,
      this.income,
      this.baseIncome,
      this.product,
      this.expectTime,
      this.exceptionReport,
      this.distance});

  OrderEntity.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id']?.toString();
      storeOid = json['store_oid']?.toString();
      type = json['type']?.toString();
      cityid = json['cityid']?.toString();
      channel = json['channel']?.toString();
      channelMoney = json['channel_money']?.toString();
      riderMoneyTotal = json['rider_money_total']?.toString();
      riderCalcMoneyTotal = json['rider_calc_money_total']?.toString();
      dChannel = json['d_channel']?.toString();
      fee = json['fee']?.toString();
      servicetime = json['servicetime']?.toString();
      des = json['des']?.toString();
      paytype = json['paytype']?.toString();
      orderno = json['orderno']?.toString();
      tradeNo = json['trade_no']?.toString();
      payTradeNo = json['pay_trade_no']?.toString();
      status = json['status']?.toString();
      canceltime = json['canceltime']?.toString();
      sendtime = json['sendtime']?.toString();
      refundtime = json['refundtime']?.toString();
      preStartDeliveryTime = json['pre_start_delivery_time']?.toString();
      preEndDeliveryTime = json['pre_end_delivery_time']?.toString();
      source = json['source']?.toString();
      fName = json['f_name']?.toString();
      fAddr = json['f_addr']?.toString();
      fLng = json['f_lng']?.toString();
      fLat = json['f_lat']?.toString();
      tName = json['t_name']?.toString();
      tAddr = json['t_addr']?.toString();
      tLng = json['t_lng']?.toString();
      tLat = json['t_lat']?.toString();
      riderid = json['riderid']?.toString();
      extra = (json['extra'] != null)
          ? OrderEntityExtra.fromJson(json['extra'])
          : null;
      pickName = json['pick_name']?.toString();
      pickPhone = json['pick_phone']?.toString();
      recipName = json['recip_name']?.toString();
      recipPhone = json['recip_phone']?.toString();
      isdel = json['isdel']?.toString();
      deltime = json['deltime']?.toString();
      istrans = json['istrans']?.toString();
      transtime = json['transtime']?.toString();
      oldriderid = json['oldriderid']?.toString();
      sysRiderIncome = json['sys_rider_income']?.toString();
      commissionType = json['commission_type']?.toString();
      fixedMoney = json['fixed_money']?.toString();
      substationRate = json['substation_rate']?.toString();
      riderAdd = json['rider_add']?.toString();
      isSystem = json['is_system']?.toString();
      reminderCount = json['reminder_count']?.toString();
      reminderContent = json['reminder_content']?.toString();
      isNow = json['is_now']?.toString();
      isCancel = json['is_cancel']?.toString();
      isMer = json['is_mer']?.toString();
      refundOrderId = json['refund_order_id']?.toString();
      refundResult = json['refund_result']?.toString();
      timeOut = json['time_out']?.toString();
      reachStoreTime = json['reach_store_time']?.toString();
      dispatchTrans = json['dispatch_trans']?.toString();
      dispatchRiderid = json['dispatch_riderid']?.toString();
      dispatchTranstime = json['dispatch_transtime']?.toString();
      dispatchTime = json['dispatch_time']?.toString();
      merTake = json['mer_take']?.toString();
      updateTime = json['update_time']?.toString();
      payType = json['pay_type']?.toString();
      typeT = json['type_t']?.toString();
      usersIm = (json['users_im'] != null)
          ? OrderEntityUsersIm.fromJson(json['users_im'])
          : null;
      mealTimeText = json['meal_time_text']?.toInt();
      storeIm = (json['store_im'] != null)
          ? OrderEntityStoreIm.fromJson(json['store_im'])
          : null;
      tips = json['tips']?.toString();
      overTime = json['over_time']?.toString();
      serviceTime = json['service_time']?.toString();
      addTime = json['add_time']?.toString();
      orderTypeDesc = json['order_type_desc']?.toString();
      orderType = json['order_type']?.toString();
      orderNum = json['order_num']?.toString();
      transTime = json['trans_time']?.toString();
      grapTime = json['grap_time']?.toString();
      pickTime = json['pick_time']?.toString();
      completeTime = json['complete_time']?.toString();
      reachStoreTime2 = json['reach_store_time2']?.toString();
      grapTime2 = json['grap_time2']?.toString();
      pickTime2 = json['pick_time2']?.toString();
      completeTime2 = json['complete_time2']?.toString();
      isevaluate = json['isevaluate']?.toString();
      ispre = json['ispre']?.toString();
      riderBasic = json['rider_basic']?.toInt();
      riderDistance = json['rider_distance']?.toDouble();
      riderWeight = json['rider_weight']?.toInt();
      riderLength = json['rider_length']?.toDouble();
      riderPrepaid = json['rider_prepaid']?.toInt();
      riderTimemoney = json['rider_timemoney']?.toString();
      riderFee = json['rider_fee']?.toString();
      income = json['income']?.toDouble();
      baseIncome = json['base_income']?.toDouble();
      exceptionReport = json['exception_report']?.toString();
      distance = json['distance']?.toString();
      if (json['product'] != null) {
        final v = json['product'];
        final arr0 = <OrderEntityProduct>[];
        v.forEach((v) {
          arr0.add(OrderEntityProduct.fromJson(v));
        });
        product = arr0;
      }
      expectTime = json['expect_time']?.toString();
      if (json['thumbs'] != null) {
        final v = json['thumbs'];
        final arr0 = <String>[];
        v.forEach((v) {
          arr0.add(v.toString());
        });
        thumbs = arr0;
      }
    } catch (e) {
      e.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['store_oid'] = storeOid;
    data['type'] = type;
    data['cityid'] = cityid;
    data['channel'] = channel;
    data['channel_money'] = channelMoney;
    data['rider_money_total'] = riderMoneyTotal;
    data['rider_calc_money_total'] = riderCalcMoneyTotal;
    data['d_channel'] = dChannel;
    data['fee'] = fee;
    data['servicetime'] = servicetime;
    data['des'] = des;
    data['paytype'] = paytype;
    data['orderno'] = orderno;
    data['trade_no'] = tradeNo;
    data['pay_trade_no'] = payTradeNo;
    data['status'] = status;
    data['canceltime'] = canceltime;
    data['sendtime'] = sendtime;
    data['refundtime'] = refundtime;
    data['pre_start_delivery_time'] = preStartDeliveryTime;
    data['pre_end_delivery_time'] = preEndDeliveryTime;
    data['source'] = source;
    data['f_name'] = fName;
    data['f_addr'] = fAddr;
    data['f_lng'] = fLng;
    data['f_lat'] = fLat;
    data['t_name'] = tName;
    data['t_addr'] = tAddr;
    data['t_lng'] = tLng;
    data['t_lat'] = tLat;
    data['riderid'] = riderid;
    if (extra != null) {
      data['extra'] = extra!.toJson();
    }
    data['pick_name'] = pickName;
    data['pick_phone'] = pickPhone;
    data['recip_name'] = recipName;
    data['recip_phone'] = recipPhone;
    data['isdel'] = isdel;
    data['deltime'] = deltime;
    data['istrans'] = istrans;
    data['transtime'] = transtime;
    data['oldriderid'] = oldriderid;
    data['sys_rider_income'] = sysRiderIncome;
    data['commission_type'] = commissionType;
    data['fixed_money'] = fixedMoney;
    data['substation_rate'] = substationRate;
    data['rider_add'] = riderAdd;
    data['is_system'] = isSystem;
    data['reminder_count'] = reminderCount;
    data['reminder_content'] = reminderContent;
    data['is_now'] = isNow;
    data['is_cancel'] = isCancel;
    data['is_mer'] = isMer;
    data['refund_order_id'] = refundOrderId;
    data['refund_result'] = refundResult;
    data['time_out'] = timeOut;
    data['reach_store_time'] = reachStoreTime;
    data['dispatch_trans'] = dispatchTrans;
    data['dispatch_riderid'] = dispatchRiderid;
    data['dispatch_transtime'] = dispatchTranstime;
    data['dispatch_time'] = dispatchTime;
    data['mer_take'] = merTake;
    data['update_time'] = updateTime;
    data['pay_type'] = payType;
    data['type_t'] = typeT;
    if (usersIm != null) {
      data['users_im'] = usersIm!.toJson();
    }
    data['meal_time_text'] = mealTimeText;
    if (storeIm != null) {
      data['store_im'] = storeIm!.toJson();
    }
    data['tips'] = tips;
    data['over_time'] = overTime;
    data['service_time'] = serviceTime;
    data['add_time'] = addTime;
    data['order_type_desc'] = orderTypeDesc;
    data['order_type'] = orderType;
    data['order_num'] = orderNum;
    data['trans_time'] = transTime;
    data['grap_time'] = grapTime;
    data['pick_time'] = pickTime;
    data['complete_time'] = completeTime;
    data['reach_store_time2'] = reachStoreTime2;
    data['grap_time2'] = grapTime2;
    data['pick_time2'] = pickTime2;
    data['complete_time2'] = completeTime2;
    data['isevaluate'] = isevaluate;
    data['ispre'] = ispre;
    data['rider_basic'] = riderBasic;
    data['rider_distance'] = riderDistance;
    data['rider_weight'] = riderWeight;
    data['rider_length'] = riderLength;
    data['rider_prepaid'] = riderPrepaid;
    data['rider_timemoney'] = riderTimemoney;
    data['rider_fee'] = riderFee;
    data['income'] = income;
    data['base_income'] = baseIncome;
    data['exception_report'] = exceptionReport;
    data['distance'] = distance;

    if (product != null) {
      final v = product;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['product'] = arr0;
    }
    if (thumbs != null) {
      final v = thumbs;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['thumbs'] = arr0;
    }
    data['expect_time'] = expectTime;
    return data;
  }

  String getTopTimeStr(int listType) => listType ==
          OrderListEntity.LIST_TYPE_FINISHED
      ? (status == OrderListEntity.ORDER_STATUS_CANCEL
          ? (tips ?? '')
          : BaseDateUtil.formatZHDateTime(completeTime,
              format: BaseDateType.ZH_YEAR_MONTH_DAY_HOUR_MINUTE,
              timeSeparate: ':'))
      : '${BaseDateUtil.formatZHDateTime(preStartDeliveryTime, format: BaseDateType.ZH_YEAR_MONTH_DAY_HOUR_MINUTE, timeSeparate: ':')} ~ ${BaseDateUtil.formatDateTime(preEndDeliveryTime, format: BaseDateType.HOUR_MINUTE)}';

  String getOrderNum() => (ObjectUtil.isEmptyStr(orderNum) ||
          status == OrderListEntity.ORDER_STATUS_PAY_YES)
      ? ''
      : '#${orderNum}';

  String getOrderIncome() {
    if (status == OrderListEntity.ORDER_STATUS_FINISHED) return '';
    if (ObjectUtil.isEmptyDouble(baseIncome))
      return ObjectUtil.isEmptyDouble(income)
          ? ''
          : '￥${BaseNumUtil.formatDecimalPlace(income!)}';
    else {
      String value =
          BaseNumUtil.formatDecimalPlace(((income ?? 0) - (baseIncome ?? 0)));
      return '￥${BaseNumUtil.formatDecimalPlace(baseIncome!)}${double.parse(value) == 0 ? '' : "+" + value}';
    }
  }

  double get fDistance => BaseLocationUtil().getDistance(
      BaseLocationUtil().getLocationData()?.lat,
      BaseLocationUtil().getLocationData()?.lng,
      fLat,
      fLng);

  String get fDistanceStr => BaseLocationUtil().getDistanceUnit(fDistance);

  double get tDistance => BaseLocationUtil().getDistance(
      BaseLocationUtil().getLocationData()?.lat,
      BaseLocationUtil().getLocationData()?.lng,
      tLat,
      tLng);

  String get tDistanceStr => BaseLocationUtil()
      .getDistanceUnit(double.parse(distance ?? fDistance.toString()));
}

class OrderListEntity {
  static const LIST_TYPE_NEW = 1;
  static const LIST_TYPE_TAKE = 2;
  static const LIST_TYPE_NOT_FIN = 3;
  static const LIST_TYPE_FINISHED = 4;

  //1待支付 2已支付 3已接单 4已取件 5已送达 6已完成 7退款中 8退款完成 9 退款失败10已取消
  static const ORDER_STATUS_PAY_NO = '1';
  static const ORDER_STATUS_PAY_YES = '2';
  static const ORDER_STATUS_PICK = '3';
  static const ORDER_STATUS_TAKE = '4';
  static const ORDER_STATUS_SEND = '5';
  static const ORDER_STATUS_FINISHED = '6';
  static const ORDER_STATUS_REFUNDING = '7';
  static const ORDER_STATUS_REFUNDED = '8';
  static const ORDER_STATUS_REFUND_FAIL = '9';
  static const ORDER_STATUS_CANCEL = '10';
  static const ORDER_STATUS_ARRIVAL = '11';

  //1帮送,2帮取,3帮买,4帮排队,5帮办,6店铺
  static const ORDER_TYPE_DELIEVER = '1';
  static const ORDER_TYPE_TAKE = '2';

  // static const ORDER_TYPE_BUY = '3';
  // static const ORDER_TYPE_QUEUE = '4';
  // static const ORDER_TYPE_DEAL = '5';
  static const ORDER_TYPE_SHOP = '6';

  List<OrderEntity>? list;

  parseList(List<dynamic>? jsonList) {
    if (ObjectUtil.isEmptyList(jsonList)) return this;
    List<dynamic> data = jsonList!;
    this.list = data
        .map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    return this;
  }
}
