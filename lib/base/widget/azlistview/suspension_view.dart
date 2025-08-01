import 'package:flutter/material.dart';

import 'az_common.dart';

/// on all sus section callback(map: Used to scroll the list to the specified tag location).
typedef void OnSusSectionCallBack(Map<String, int> map);
typedef void OnSusSectionCallBackValue(String key);

///Suspension Widget.Currently only supports fixed height items!
class SuspensionView extends StatefulWidget {
  /// with  ISuspensionBean Data
  final List<ISuspensionBean>? data;

  /// content widget(must contain ListView).
  final Widget? contentWidget;

  /// suspension widget.
  final Widget? suspensionWidget;

  /// ListView ScrollController.
  final ScrollController? controller;

  /// suspension widget Height.
  final int? suspensionHeight;

  /// item Height.
  final int? itemHeight;

  /// on sus tag change callback.
  final ValueChanged<String>? onSusTagChanged;

  /// on sus section callback.
  final OnSusSectionCallBack? onSusSectionInited;

  final AzListViewHeader? header;
  final OnSusSectionCallBackValue? sectionCallBackValue;

  SuspensionView({
    Key? key,
    @required this.data,
    @required this.contentWidget,
    @required this.suspensionWidget,
    @required this.controller,
    this.suspensionHeight = 40,
    this.itemHeight = 50,
    this.onSusTagChanged,
    this.onSusSectionInited,
    this.sectionCallBackValue,
    this.header,
  })  : assert(contentWidget != null),
        assert(controller != null),
        super(key: key);

  @override
  _SuspensionWidgetState createState() => new _SuspensionWidgetState();
}

class _SuspensionWidgetState extends State<SuspensionView> {
  int _suspensionTop = 0;
  int? _lastIndex;
  int? _suSectionListLength;

  List<int> _suspensionSectionList = [];
  Map<String, int> _suspensionSectionMap = new Map(); //记录了每个字母的悬停位置的偏移量

  @override
  void initState() {
    super.initState();
    if (widget.header != null) {
      _suspensionTop = -widget.header!.height!;
    }
    widget.controller!.addListener(() {
      int offset = widget.controller!.offset.toInt();
      int _index = _getIndex(offset);
      if (_index != -1 && _lastIndex != _index) {
        _lastIndex = _index;
        if (widget.onSusTagChanged != null) {
          var indexList = _suspensionSectionMap.keys.toList();
          widget.onSusTagChanged!(indexList[_index]);
          widget.sectionCallBackValue!(indexList[_index]);
        }
      }
    });
  }

  int _getIndex(int offset) {
    if (widget.header != null && offset < widget.header!.height!) {
      if (_suspensionTop != -widget.header!.height! &&
          widget.suspensionWidget != null) {
        setState(() {
          _suspensionTop = -widget.header!.height!;
        });
      }
      return 0;
    }
    for (int i = 0; i < _suSectionListLength! - 1; i++) {
      int space = _suspensionSectionList[i + 1] - offset;
      if (space > 0 && space < widget.suspensionHeight!) {
        space = space - widget.suspensionHeight!;
      } else {
        space = 0;
      }

      if (_suspensionTop != space && widget.suspensionWidget != null) {
        setState(() {
          _suspensionTop = space;
        });
      }
      int a = _suspensionSectionList[i];
      int b = _suspensionSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
      if (offset >= _suspensionSectionList[_suSectionListLength! - 1]) {
        return _suSectionListLength! - 1;
      }
    }
    return -1;
  }

  void _init() {
    _suspensionSectionMap.clear();
    int offset = 0; //这是自定义添加的高度（定位和热门城市）
    String? tag;
    if (widget.header != null) {
      _suspensionSectionMap[widget.header!.tag] = 0;
      offset = widget.header!.height!;
    }

    widget.data?.forEach((v) {
      if (tag != v.getSuspensionTag()) {
        tag = v.getSuspensionTag();
        _suspensionSectionMap.putIfAbsent(tag!, () => offset);
        if (tag == '定位') {
          offset = offset + 80;
        } else if (tag == '热门') {
          offset = offset + 160;
        } else {
          offset = offset + widget.suspensionHeight! + widget.itemHeight! + 1;
        }
      } else {
        offset = offset + widget.itemHeight! + 1;
      }
    });
    _suspensionSectionList
      ..clear()
      ..addAll(_suspensionSectionMap.values);
    _suSectionListLength = _suspensionSectionList.length;
    if (widget.onSusSectionInited != null) {
      widget.onSusSectionInited!(_suspensionSectionMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    var children = <Widget>[
      widget.contentWidget!,
    ];
    if (widget.suspensionWidget != null) {
      children.add(Positioned(
        ///-0.1修复部分手机丢失精度问题
        top: _suspensionTop.toDouble() - 0.1,
        left: 0.0,
        right: 0.0,
        child: widget.suspensionWidget!,
      ));
    }
    return Stack(children: children);
  }
}
