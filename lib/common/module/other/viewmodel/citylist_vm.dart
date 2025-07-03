import 'package:djqs/base/entity/base_location_entity.dart';
import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/util/util_location.dart';
import 'package:djqs/base/widget/azlistview/az_common.dart';
import 'package:djqs/common/module/other/entity/citylist_entity.dart';
import 'package:djqs/common/module/other/util/other_service.dart';
import 'package:lpinyin/lpinyin.dart';

class CityListVM extends BaseNotifier {
  CityListVM(super.context);

  List<CityEntity> cityList = [];

  List<CityEntity> hotCityList = [];

  bool isLocating = false;

  String curSusTag = '';
  late final OtherService _service = OtherService();

  @override
  void init() async {
    EventBus().on(EventCode.LOCATION_REFRESH, (_) {
      isLocating = false;
      notifyListeners();
    });
    //
    CityListEntity? data = await _service.getCityList();
    if (data == null) return;
    cityList = data.operationCity!;
    hotCityList = data.hotCity!;
    hotCityList.insert(0, CityEntity(name: '全国', adcode: ''));
    _dealWithCity();
    notifyListeners();
  }

  String? getCurrentLocation() {
    BaseLocationData? locationData = BaseLocationUtil().getLocationData();
    if (locationData == null || locationData?.lat == null) return '未知';
    return locationData?.city;
  }

  void _dealWithCity() {
    if (cityList == null || (cityList?.isEmpty ?? true)) return;
    for (int i = 0, length = cityList.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(cityList[i].name!);
      String tag = pinyin.substring(0, 1).toUpperCase();
      String shrink = "";
      List<String> strings = pinyin.split(" ");
      strings.forEach((element) {
        shrink += element.substring(0, 1);
      });
      cityList[i].shrink = shrink;
      cityList[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        cityList[i].tag = tag;
      } else {
        cityList[i].tag = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(cityList);
  }

  void btn_onStartLocation() {
    isLocating = true;
    notifyListeners();
    BaseLocationUtil().startLocation();
  }

  void btn_onSelectCity({isFromLocation = false, CityEntity? cityEntity}) {
    if (isFromLocation) {
      BaseLocationData? locationData = BaseLocationUtil().getLocationData();
      if (locationData != null) {
        cityEntity?.name = locationData.city;
        cityEntity?.adcode = locationData.cityCode;
      }
    }
    pagePop(params: cityEntity);
  }

  @override
  void onCleared() {
    EventBus().off(EventCode.LOCATION_REFRESH);
  }
}
