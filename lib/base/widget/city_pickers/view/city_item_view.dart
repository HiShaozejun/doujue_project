/**
 * Created with Android Studio.
 * User: 三帆
 * Date: 28/01/2019
 * Time: 18:20
 * email: sanfan.hx@alibaba-inc.com
 * tartget:  xxx
 */
import 'dart:async';

import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/widget/city_pickers/model/base_citys.dart';
import 'package:djqs/base/widget/city_pickers/model/point.dart';
import 'package:djqs/base/widget/city_pickers/model/result.dart';
import 'package:djqs/base/widget/city_pickers/utils/show_types.dart';
import 'package:djqs/base/widget/city_pickers/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'inherit_process.dart';

class CityView extends StatefulWidget {
  final double? progress;
  final String? locationCode;
  final ShowType? showType;
  final Map<String, dynamic>? provincesData;
  final Map<String, dynamic>? citiesData;
  final ItemWidgetBuilder? itemBuilder;

  /// 是否对数据进行排序
  final bool? isSort;

  /// ios选择框的高度. 配合 itemBuilder中的字体使用.
  final double? itemExtent;

  /// 容器高度
  final double? height;

  /// 取消按钮的Widget
  /// 当用户设置该属性. 会优先使用用户设置的widget, 否则使用代码中默认的文本, 使用primary主题色
  final Widget? cancelWidget;

  /// 确认按钮的widget
  /// 当用户设置该属性. 会优先使用用户设置的widget, 否则使用代码中默认的文本, 使用primary主题色
  final Widget? confirmWidget;

  CityView(
      {this.progress,
      this.showType,
      this.height,
      this.locationCode,
      this.citiesData,
      this.provincesData,
      this.itemBuilder,
      this.itemExtent,
      this.cancelWidget,
      this.confirmWidget,
      this.isSort})
      : assert(!(itemBuilder != null && itemExtent == null),
            "\ritemExtent could't be null if itemBuilder exits");

  _BaseView createState() => _BaseView();
}

class _BaseView extends State<CityView> {
  Timer? _changeTimer;
  bool _resetControllerOnce = false;
  FixedExtentScrollController? provinceController;
  FixedExtentScrollController? cityController;
  FixedExtentScrollController? areaController;

  // 所有省的列表. 因为性能等综合原因,
  // 没有一次性构建整个以国为根的树. 动态的构建以省为根的树, 效率高.
  List<Point>? provinces;
  CityTree? cityTree;

  Point? targetProvince;
  Point? targetCity;
  Point? targetArea;

  @override
  void initState() {
    super.initState();

    provinces = new Provinces(
            metaInfo: widget.provincesData as Map<String, String>,
            sort: widget.isSort)
        .provinces;

    cityTree = new CityTree(
        metaInfo: widget.citiesData,
        provincesInfo: widget.provincesData as Map<String, String>);

    try {
      _initLocation(widget.locationCode);
    } catch (e) {
      print('Exception details:\n 初始化地理位置信息失败, 请检查省分城市数据 \n $e');
    }
    _initController();
  }

  void dispose() {
    provinceController?.dispose();
    cityController?.dispose();
    areaController?.dispose();
    if (_changeTimer != null && _changeTimer!.isActive) {
      _changeTimer?.cancel();
    }
    super.dispose();
  }

  // 初始化controller, 为了使给定的默认值, 在选框的中心位置
  void _initController() {
    provinceController = new FixedExtentScrollController(
        initialItem: (provinces
                ?.indexWhere((Point p) => p.code == targetProvince?.code)) ??
            0);

    cityController = new FixedExtentScrollController(
        initialItem: (targetProvince?.child
                ?.indexWhere((Point p) => p.code == targetCity?.code)) ??
            0);

    areaController = new FixedExtentScrollController(
        initialItem: (targetCity?.child
                ?.indexWhere((Point p) => p.code == targetArea?.code)) ??
            0);
  }

  // 重置Controller的原因在于, 无法手动去更改initialItem, 也无法通过
  // jumpTo or animateTo去更改, 强行更改, 会触发 _onProvinceChange  _onCityChange 与 _onAreacChange
  // 只为覆盖初始化化的参数initialItem
  void _resetController() {
    if (_resetControllerOnce) return;
    provinceController = new FixedExtentScrollController(initialItem: 0);

    cityController = new FixedExtentScrollController(initialItem: 0);
    areaController = new FixedExtentScrollController(initialItem: 0);
    _resetControllerOnce = true;
  }

  // initialize tree by locationCode
  void _initLocation(String? locationCode) {
    int _locationCode;
    if (locationCode != null) {
      try {
        _locationCode = int.parse(locationCode);
      } catch (e) {
        print(ArgumentError(
            "The Argument locationCode must be valid like: '100000' but get '$locationCode' "));
        return;
      }

      targetProvince = cityTree?.initTreeByCode(_locationCode);

      /// 为用户给出的locationCode不正确做一个容错
      if (targetProvince == null) {
        targetProvince = cityTree?.initTreeByCode(provinces?.first.code);
      }
      targetProvince?.child?.forEach((Point _city) {
        if (_city.code == _locationCode) {
          targetCity = _city;
          targetArea = _getTargetChildFirst(_city);
        }
        _city.child?.forEach((Point _area) {
          if (_area.code == _locationCode) {
            targetCity = _city;
            targetArea = _area;
          }
        });
      });
    } else {
      /// 本来默认想定在北京, 但是由于有可能出现用户的省份数据为不包含北京, 所以采用第一个省份做为初始
      targetProvince = cityTree
          ?.initTreeByCode(int.parse(widget.provincesData?.keys.first ?? ''));
    }
    // 尝试试图匹配到下一个级别的第一个,
    if (targetCity == null) {
      targetCity = _getTargetChildFirst(targetProvince);
    }
    // 尝试试图匹配到下一个级别的第一个,
    if (targetArea == null) {
      targetArea = _getTargetChildFirst(targetCity);
    }
  }

  Point? _getTargetChildFirst(Point? target) {
    if (target == null) {
      return null;
    }
    if (target.child != null && target.child!.isNotEmpty) {
      return target.child!.first;
    }
    return null;
  }

  // 通过选中的省份, 构建以省份为根节点的树型结构
  List<String?> getCityItemList() {
    List<String?> result = [];

    if (targetProvince?.child != null) {
      result
          .addAll(targetProvince!.child!.toList().map((p) => p.name).toList());
    }

    return result;
  }

  List<String?> getAreaItemList() {
    List<String?> result = [];

    if (targetCity?.child != null) {
      result.addAll((targetCity!.child!.toList().map((p) => p.name).toList()));
    }
    return result;
  }

  // province change handle
  // 加入延时处理, 减少构建树的消耗
  _onProvinceChange(Point? _province) {
    if (_changeTimer != null && _changeTimer!.isActive) {
      _changeTimer!.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      Point _provinceTree =
          cityTree?.initTree(int.parse(_province?.code?.toString() ?? ''));
      setState(() {
        targetProvince = _provinceTree;
        targetCity = _getTargetChildFirst(_provinceTree);
        targetArea = _getTargetChildFirst(targetCity);
        _resetController();
      });
    });
  }

  _onCityChange(Point? _targetCity) {
    if (_changeTimer != null && _changeTimer!.isActive) {
      _changeTimer!.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        targetCity = _targetCity;
        targetArea = _getTargetChildFirst(targetCity);
      });
    });
    _resetController();
  }

  _onAreaChange(Point? _targetArea) {
    if (_changeTimer != null && _changeTimer!.isActive) {
      _changeTimer!.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        targetArea = _targetArea;
      });
    });
  }

  CityPickerResult _buildResult() {
    CityPickerResult result = CityPickerResult();
    ShowType showType = widget.showType!;
    if (showType.contain(ShowType.p)) {
      result.provinceId = targetProvince?.code.toString();
      result.provinceName = targetProvince?.name;
    }
    if (showType.contain(ShowType.c)) {
      result.provinceId = targetProvince?.code.toString();
      result.provinceName = targetProvince?.name;
      result.cityId = targetCity != null ? targetCity?.code.toString() : null;
      result.cityName = targetCity != null ? targetCity?.name : null;
    }
    if (showType.contain(ShowType.a)) {
      result.provinceId = targetProvince?.code.toString();
      result.provinceName = targetProvince?.name;
      result.cityId = targetCity != null ? targetCity?.code.toString() : null;
      result.cityName = targetCity != null ? targetCity?.name : null;
      result.areaId = targetArea != null ? targetArea?.code.toString() : null;
      result.areaName = targetArea != null ? targetArea?.name : null;
    }
    // 台湾异常数据. 需要过滤
    if (result.provinceId == "710000") {
      result.cityId = null;
      result.cityName = null;
      result.areaId = null;
      result.areaName = null;
    }
    return result;
  }

  Widget _bottomBuild() {
    return new Container(
        width: double.infinity,
        color: BaseUIUtil().getTheme().bottomSheetTheme.backgroundColor,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: widget.cancelWidget ??
                        new Text('取消',
                            style: BaseUIUtil()
                                .getTheme()
                                .primaryTextTheme
                                .displayMedium)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _buildResult());
                  },
                  child: widget.confirmWidget ??
                      new Text('确定',
                          style: BaseUIUtil()
                              .getTheme()
                              .primaryTextTheme
                              .displayMedium),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Expanded(
              child: new Row(
                children: <Widget>[
                  new _MyCityPicker(
                    key: Key('province'),
                    isShow: widget.showType?.contain(ShowType.p),
                    height: widget.height,
                    controller: provinceController,
                    itemBuilder: widget.itemBuilder,
                    itemExtent: widget.itemExtent,
                    value: targetProvince?.name,
                    itemList: (provinces?.toList().map((v) => v.name).toList()),
                    changed: (index) {
                      _onProvinceChange(provinces?[index]);
                    },
                  ),
                  new _MyCityPicker(
                    key: Key('citys $targetProvince'),
                    // 这个属性是为了强制刷新
                    isShow: widget.showType?.contain(ShowType.c),
                    controller: cityController,
                    itemBuilder: widget.itemBuilder,
                    itemExtent: widget.itemExtent,
                    height: widget.height,
                    value: targetCity == null ? null : targetCity?.name,
                    itemList: getCityItemList(),
                    changed: (index) {
                      _onCityChange(targetProvince?.child?[index]);
                    },
                  ),
                  new _MyCityPicker(
                    key: Key('towns $targetCity'),
                    isShow: widget.showType?.contain(ShowType.a),
                    controller: areaController,
                    itemBuilder: widget.itemBuilder,
                    itemExtent: widget.itemExtent,
                    value: targetArea == null ? null : targetArea?.name,
                    height: widget.height,
                    itemList: getAreaItemList(),
                    changed: (index) {
                      _onAreaChange(targetCity?.child?[index]);
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget build(BuildContext context) {
    final route = InheritRouteWidget.of(context)?.router;
    return new AnimatedBuilder(
      animation: route!.animation!,
      builder: (BuildContext context, Widget? child) {
        return new CustomSingleChildLayout(
          delegate: _WrapLayout(
              progress: route.animation?.value, height: widget.height),
          child: new GestureDetector(
            child: new Material(
              color: Colors.transparent,
              child:
                  new Container(width: double.infinity, child: _bottomBuild()),
            ),
          ),
        );
      },
    );
  }
}

class _MyCityPicker extends StatefulWidget {
  final List<String?>? itemList;
  final Key? key;
  final String? value;
  final bool? isShow;
  final FixedExtentScrollController? controller;
  final ValueChanged<int>? changed;
  final double? height;
  final ItemWidgetBuilder? itemBuilder;

  // ios选择框的高度. 配合 itemBuilder中的字体使用.
  final double? itemExtent;

  _MyCityPicker(
      {this.key,
      this.controller,
      this.isShow = false,
      this.changed,
      this.height,
      this.itemList,
      this.itemExtent,
      this.itemBuilder,
      this.value});

  @override
  State createState() {
    return new _MyCityPickerState();
  }
}

class _MyCityPickerState extends State<_MyCityPicker> {
  List<Widget>? children;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isShow!) {
      return Container();
    }
    if (widget.itemList == null || widget.itemList!.isEmpty) {
      return new Expanded(
        child: Container(),
      );
    }
    return new Expanded(
      child: new Container(
          padding: EdgeInsets.all(5.0).r,
          alignment: Alignment.center,
          child: CupertinoPicker.builder(
              magnification: 1.0,
              itemExtent: widget.itemExtent ?? 35.h,
              scrollController: widget.controller,
              onSelectedItemChanged: (index) {
                if (widget.changed != null) {
                  widget.changed!(index);
                }
              },
              itemBuilder: (context, index) {
                if (widget.itemBuilder != null) {
                  return widget.itemBuilder!(
                      widget.itemList?[index], widget.itemList, index);
                }
                return Center(
                  child: Text(
                    '${widget.itemList?[index]}',
                    maxLines: 1,
                    style:
                        BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                  ),
                );
              },
              childCount: widget.itemList?.length)),
      flex: 1,
    );
  }
}

class _WrapLayout extends SingleChildLayoutDelegate {
  _WrapLayout({
    this.progress,
    this.height,
  });

  final double? progress;
  final double? height;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = height!;

    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress!;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_WrapLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
