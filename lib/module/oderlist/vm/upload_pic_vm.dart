import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/widget/media/photo_view_widget.dart';
import 'package:djqs/module/oderlist/camera_photo_page.dart';
import 'package:djqs/module/oderlist/entity/order_error_entity.dart';
import 'package:djqs/module/oderlist/entity/upload_pic_data.dart';
import 'package:djqs/module/oderlist/entity/watermark_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class UploadPicVM extends BaseNotifier {
  static const int UPLOAD_TYPE_SEND = 0;
  static const int UPLOAD_TYPE_ERROR = 1;

  static const LIMIT_IMAGE_COUNT_MIN = 0;
  static const LIMIT_IMAGE_COUNT_MAX = 3;

  final List<OrderPickItem> sendData = [
    OrderPickItem(name: '指定位置', code: 'OC00074'),
    OrderPickItem(name: '外卖存放桌/架', code: 'OC00073'),
    OrderPickItem(name: '自提柜', code: 'OC00072'),
    OrderPickItem(name: '放门口', code: 'BT00011'),
    OrderPickItem(name: '前台', code: 'OC00038'),
    OrderPickItem(name: '小区超市', code: 'OC00036'),
    OrderPickItem(name: '小区门口', code: 'OC00034'),
    OrderPickItem(name: '门卫/保安室', code: 'OC00035')
  ];
  final List<OrderErrorEntity> errorData = [
    OrderErrorEntity(name: "顾客异常", code: "1", children: [
      OrderPickItem(name: "联系不上顾客", code: "10001"),
      OrderPickItem(name: "顾客位置无法进入", code: "10002"),
      OrderPickItem(name: "顾客地址错误或顾客地址和实际定位位置不符", code: "10003"),
      OrderPickItem(name: "顾客更改收货地址", code: "10004"),
      OrderPickItem(name: "顾客拒收货品", code: "10005"),
      OrderPickItem(name: "顾客更改期望送达时间", code: "10006"),
      OrderPickItem(name: "顾客的其他异常", code: "10099"),
    ]),
    OrderErrorEntity(name: "商家异常", code: "2", children: [
      OrderPickItem(name: "商家出餐慢", code: "20001"),
      OrderPickItem(name: "商家关店/未营业", code: "20002"),
      OrderPickItem(name: "联系不上商家", code: "20003"),
      OrderPickItem(name: "商家定位错误", code: "20004"),
      OrderPickItem(name: "商家更改取货地址", code: "20005"),
      OrderPickItem(name: "商家的其他异常", code: "20099"),
    ]),
    OrderErrorEntity(name: "骑手异常", code: "3", children: [
      OrderPickItem(name: "托寄物丢失或损坏", code: "30001"),
      OrderPickItem(name: "配送工具损坏或异常", code: "30002"),
      OrderPickItem(name: "骑手的其他异常", code: "30099"),
    ])
  ];

  int? uploadType;
  late List<String> images;

  //
  List<String>? sendPickerData;
  List<PickerItem<String>>? errorPickerData;
  List<int>? pickIndexes;
  String? code;
  late final TextEditingController textController = TextEditingController();
  String? desc;

  UploadPicVM(super.context, {required this.uploadType});

  @override
  void init() {
    images = <String>[];
    images.add('');
    sendPickerData = sendData.map((e) => e.name!).toList();
    errorPickerData = errorData.map((category) {
      return PickerItem(
          text: Text(category.name ?? ''),
          value: category.code,
          children: category.children?.map((child) {
            return PickerItem(
                text: Text(child?.name ?? ''), value: child?.code);
          }).toList());
    }).toList();
    pickIndexes = (uploadType == UPLOAD_TYPE_SEND ? [0] : [0, 0]);
  }

  @override
  void onCleared() {}

  void btn_onAdd() async {
    if (!_isCheckLimitMax()) return;
    WatermarkData data = WatermarkData()
      ..locationData = BaseLocationUtil().getLocationData();
    String? imgUrl = await pagePush(CameraPhotoPage(markData: data));
    // if (!ObjectUtil.isEmptyStr(imgUrl)) { //to-do
    images.insert(images.length - 1, imgUrl!);
    notifyListeners();
    //  }
  }

  void btn_onItemDelete(String url) {
    images!.remove(url);
    notifyListeners();
  }

  void btn_onShowImage(String url) => pagePush(
      PhotoViewWidget(images: [url], showBack: true, showTitle: false));

  void btn_upload() {
    if (!isCheck()) return;
    UploadPicData data = UploadPicData();
    data.images = this.images.sublist(0,images.length-1);
    data.code = this.code;
    data.desc = this.desc;
    pagePop(params: data);
  }

  bool isCheck() => _isCheckLimitMin() && _isCheckLimitMax() && _isCheckDesc();

  bool _isCheckLimitMin() {
    if (images.length - 1 < LIMIT_IMAGE_COUNT_MIN) {
      toast('至少要有${LIMIT_IMAGE_COUNT_MIN}张图片');
      return false;
    }
    return true;
  }

  bool _isCheckDesc() {
    if (isShowTF() && ObjectUtil.isEmptyStr(desc)) {
      toast('请填写异常原因');
      return false;
    }
    return true;
  }

  bool _isCheckLimitMax() {
    if (images.length > LIMIT_IMAGE_COUNT_MAX) {
      toast('最多只能有${LIMIT_IMAGE_COUNT_MAX}张图片');
      return false;
    }
    return true;
  }

  String get typeInfoStr =>
      '请选择${uploadType == UploadPicVM.UPLOAD_TYPE_SEND ? '送达地点' : '异常类型'}：';

  String get typeStr {
    OrderPickItem? item;
    if (uploadType == UPLOAD_TYPE_SEND) {
      item = sendData[pickIndexes![0]];
    } else {
      var parent = errorData[pickIndexes![0]];
      item = parent.children![pickIndexes![1]]!;
    }

    this.code = item!.code!;
    return item!.name!;
  }

  bool isShowTF() => code == '10099' || code == '20099' || code == '30099';

  void btn_onItemPick(List<int> selecteds) {
    pickIndexes = selecteds;
    notifyListeners();
  }
}
