import 'package:djqs/base/widget/city_pickers/cities_selector/cities_selector.dart';
import 'package:djqs/base/widget/city_pickers/cities_selector/utils.dart';
import 'package:djqs/base/widget/city_pickers/model/result.dart';
import 'package:djqs/base/widget/city_pickers/utils/location.dart';
import 'package:djqs/base/widget/city_pickers/utils/picker_popup_route.dart';
import 'package:djqs/base/widget/city_pickers/utils/show_types.dart';
import 'package:djqs/base/widget/city_pickers/utils/util.dart';
import 'package:djqs/base/widget/city_pickers/view/city_item_view.dart';
import 'package:djqs/base/widget/city_pickers/view/full_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'meta/province.dart' as meta;
import 'view/cities_style.dart';

class CityPickers {
  static Map<String, dynamic> metaCities = meta.citiesData;

  static Map<String, dynamic> metaProvinces = meta.provincesData;

  CityPickerResult getAssetAreaResultByCode(String code) {
    Location location =
        new Location(citiesData: metaCities, provincesData: metaProvinces);
    return location.initLocation(code);
  }

  static showCityPicker(
      {@required BuildContext? context,
      showType = ShowType.pca,
      height = null,
      String locationCode = '2',
      ThemeData? theme,
      Map<String, dynamic>? citiesData,
      Map<String, dynamic>? provincesData,
      // CityPickerRoute params
      bool barrierDismissible = true,
      double barrierOpacity = 0.5,
      ItemWidgetBuilder? itemBuilder,
      double? itemExtent,
      Widget? cancelWidget,
      Widget? confirmWidget,
      bool isSort = false}) {
    return Navigator.of(context!, rootNavigator: true).push(
      new CityPickerRoute(
          theme: theme ?? Theme.of(context),
          canBarrierDismiss: barrierDismissible,
          barrierOpacity: barrierOpacity,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          child: CityView(
              isSort: isSort,
              showType: showType,
              height: height == null ? 250.h : height,
              itemExtent: itemExtent,
              itemBuilder: itemBuilder,
              cancelWidget: cancelWidget,
              confirmWidget: confirmWidget,
              citiesData: citiesData ?? meta.citiesData,
              provincesData: provincesData ?? meta.provincesData,
              locationCode: locationCode)),
    );
  }

  /// @theme Theme used it's primaryColor
  static showFullPageCityPicker({
    @required BuildContext? context,
    ThemeData? theme,
    ShowType showType = ShowType.pca,
    String locationCode = '110000',
    Map<String, dynamic>? citiesData,
    Map<String, dynamic>? provincesData,
  }) {
    return Navigator.push(
        context!,
        new PageRouteBuilder(
          settings: RouteSettings(name: 'fullPageCityPicker'),
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, _, __) => new Theme(
              data: theme ?? Theme.of(context),
              child: FullPage(
                showType: showType,
                locationCode: locationCode,
                citiesData: citiesData ?? meta.citiesData,
                provincesData: provincesData ?? meta.provincesData,
              )),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) =>
                  new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset(0.0, 1.0),
                        end: Offset(0.0, 0.0),
                      ).animate(animation),
                      child: child),
        ));
  }

  static showCitiesSelector({
    @required BuildContext? context,
    ThemeData? theme,
    bool? showAlpha,
    String? locationCode,
    String title = '城市选择器',
    Map<String, dynamic> citiesData = meta.citiesData,
    Map<String, dynamic> provincesData = meta.provincesData,
    List<HotCity>? hotCities,
    BaseStyle? sideBarStyle,
    BaseStyle? cityItemStyle,
    BaseStyle? topStickStyle,
  }) {
    BaseStyle _sideBarStyle = BaseStyle(
        fontSize: 14.sp,
        color: defaultTagFontColor,
        activeColor: defaultTagActiveBgColor,
        backgroundColor: defaultTagBgColor,
        backgroundActiveColor: defaultTagActiveBgColor);
    _sideBarStyle = _sideBarStyle.merge(sideBarStyle!);

    BaseStyle _cityItemStyle = BaseStyle(
      fontSize: 12.sp,
      color: Colors.black,
      activeColor: Colors.red,
    );
    _cityItemStyle = _cityItemStyle.merge(cityItemStyle!);

    BaseStyle _topStickStyle = BaseStyle(
        fontSize: 16.sp,
        height: 40.h,
        color: defaultTopIndexFontColor,
        backgroundColor: defaultTopIndexBgColor);

    _topStickStyle = _topStickStyle.merge(topStickStyle!);
    return Navigator.push(
        context!,
        new PageRouteBuilder(
          settings: RouteSettings(name: 'CitiesPicker'),
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, _, __) => new Theme(
              data: theme ?? Theme.of(context),
              child: CitiesSelector(
                  title: title,
                  provincesData: provincesData,
                  citiesData: citiesData,
                  hotCities: hotCities,
                  locationCode: locationCode,
                  tagBarActiveColor: _sideBarStyle.backgroundActiveColor!,
                  tagBarFontActiveColor: _sideBarStyle.activeColor!,
                  tagBarBgColor: _sideBarStyle.backgroundColor!,
                  tagBarFontColor: _sideBarStyle.color!,
                  tagBarFontSize: _sideBarStyle.fontSize!,
                  topIndexFontSize: _topStickStyle.fontSize!,
                  topIndexHeight: _topStickStyle.height!,
                  topIndexFontColor: _topStickStyle.color!,
                  topIndexBgColor: _topStickStyle.backgroundColor!,
                  itemFontColor: _cityItemStyle.color!,
                  cityItemFontSize: _cityItemStyle.fontSize!,
                  itemSelectFontColor: _cityItemStyle.activeColor!)),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) =>
                  new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset(0.0, 1.0),
                        end: Offset(0.0, 0.0),
                      ).animate(animation),
                      child: child),
        ));
  }
}
