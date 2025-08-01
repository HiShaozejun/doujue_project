import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/widget/azlistview/suspension_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'az_common.dart';
import 'index_bar.dart';

/// Called to build children for the listview.
typedef Widget ItemWidgetBuilder(BuildContext context, ISuspensionBean model);

/// Called to build IndexBar.
typedef Widget IndexBarBuilder(
    BuildContext context, List<String> tags, IndexBarTouchCallback onTouch);

/// Called to build index hint.
typedef Widget IndexHintBuilder(BuildContext context, String hint);

/// _Header.
class _Header extends ISuspensionBean {
  late String tag;

  @override
  String getSuspensionTag() => tag;

  @override
  bool get isShowSuspension => false;
}

/// AzListView.
class AzListView extends StatefulWidget {
  AzListView(
      {Key? key,
      this.data,
      this.topData,
      this.itemBuilder,
      this.controller,
      this.physics,
      this.shrinkWrap = true,
      this.padding = EdgeInsets.zero,
      this.suspensionWidget,
      this.isUseRealIndex = true,
      this.itemHeight = 50,
      this.suspensionHeight = 40,
      this.onSusTagChanged,
      this.header,
      this.indexBarBuilder,
      this.indexHintBuilder,
      this.showIndexHint = true,
      this.indexBarItemHeight,
      this.locationBean,
      this.hotBean})
      : assert(itemBuilder != null),
        super(key: key);
  final indexBarItemHeight;

  ///with ISuspensionBean Data
  final List<ISuspensionBean>? data;

  ///with ISuspensionBean topData, Do not participate in [A-Z] sorting (such as hotList).
  final List<ISuspensionBean>? topData;

  final ItemWidgetBuilder? itemBuilder;

  final ScrollController? controller;

  final ScrollPhysics? physics;

  final bool? shrinkWrap;

  final EdgeInsetsGeometry? padding;

  ///suspension widget.
  final Widget? suspensionWidget;

  final ISuspensionBean? locationBean;
  final ISuspensionBean? hotBean;

  ///is use real index data.(false: use INDEX_DATA_DEF)
  final bool? isUseRealIndex;

  ///item Height.
  final int? itemHeight;

  ///suspension widget Height.
  final int? suspensionHeight;

  ///on sus tag change callback.
  final ValueChanged<String>? onSusTagChanged;

  final AzListViewHeader? header;

  final IndexBarBuilder? indexBarBuilder;

  final IndexHintBuilder? indexHintBuilder;

  final bool? showIndexHint;

  @override
  State<StatefulWidget> createState() {
    return new _AzListViewState();
  }
}

class _AzListViewState extends State<AzListView> {
  Map<String, int> _suspensionSectionMap = Map();
  List<ISuspensionBean> _cityList = [];
  List<String> _indexTagList = [];
  bool _isShowIndexBarHint = false;
  String _indexBarHint = "";

  late ScrollController _scrollController;
  late IndexBarUpdateValue indexBarUpdateValue;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _onIndexBarTouch(IndexBarDetails model) {
    setState(() {
      _indexBarHint = model.tag!;
      _isShowIndexBarHint = model.isTouchDown!;
      int? offset = _suspensionSectionMap[model.tag];
      if (offset != null) {
        _scrollController.jumpTo(offset
            .toDouble()
            .clamp(.0, _scrollController.position.maxScrollExtent));
      }
    });
  }

  void _init() {
    _cityList.clear();
    _cityList.insert(0, widget.hotBean!);
    _cityList.insert(0, widget.locationBean!);
    if (widget.topData != null && widget.topData!.isNotEmpty) {
      _cityList.addAll(widget.topData!);
    }
    List<ISuspensionBean> list = widget.data!;
    if (list != null && list.isNotEmpty) {
//      SuspensionUtil.sortListBySuspensionTag(list);
      _cityList.addAll(list);
    }

    SuspensionUtil.setShowSuspensionStatus(_cityList);

    if (widget.header != null) {
      _cityList.insert(0, _Header()..tag = widget.header!.tag);
    }
    _indexTagList.clear();
    if (widget.isUseRealIndex!) {
      _indexTagList.addAll(SuspensionUtil.getTagIndexList(_cityList));
    } else {
      _indexTagList.addAll(INDEX_DATA_DEF);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    var children = <Widget>[
      SuspensionView(
        data: widget.header == null ? _cityList : _cityList.sublist(1),
        contentWidget: ListView.builder(
            controller: _scrollController,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap!,
            padding: widget.padding,
            itemCount: _cityList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0 && _cityList[index] is _Header) {
                return SizedBox(
                    height: widget.header!.height!.toDouble(),
                    child: widget.header!.builder!(context));
              }
              return widget.itemBuilder!(context, _cityList[index]);
            }),
        suspensionWidget: widget.suspensionWidget,
        controller: _scrollController,
        suspensionHeight: widget.suspensionHeight,
        itemHeight: widget.itemHeight,
        onSusTagChanged: widget.onSusTagChanged,
        header: widget.header,
        onSusSectionInited: (Map<String, int> map) =>
            _suspensionSectionMap = map,
        sectionCallBackValue: (index) {
          indexBarUpdateValue(index);
        },
      )
    ];

    Widget indexBar;
    if (widget.indexBarBuilder == null) {
      indexBar = IndexBar(
        data: _indexTagList,
        width: 36,
        onTouch: _onIndexBarTouch,
        itemHeight: widget.indexBarItemHeight,
        indexBarUpdateValueCallback: (indexBarUpdateValue) {
          this.indexBarUpdateValue = indexBarUpdateValue;
        },
      );
    } else {
      indexBar = widget.indexBarBuilder!(
        context,
        _indexTagList,
        _onIndexBarTouch,
      );
    }
    children.add(Align(
      alignment: Alignment.centerRight,
      child: Container(
          margin: EdgeInsets.only(right: 10, top: 170, bottom: 30),
          child: indexBar),
    ));
    Widget indexHint;
    if (widget.indexHintBuilder != null) {
      indexHint = widget.indexHintBuilder!(context, '$_indexBarHint');
    } else {
      indexHint = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: BaseColors.c828282,
        ),
        child: Container(
          alignment: Alignment.center,
          width: 70.r,
          height: 70.r,
          child: Text(
            '$_indexBarHint',
            style: TextStyle(
              fontSize: 32.sp,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (_isShowIndexBarHint && widget.showIndexHint!) {
      children.add(Center(
        child: indexHint,
      ));
    }

    return new Stack(children: children);
  }
}
