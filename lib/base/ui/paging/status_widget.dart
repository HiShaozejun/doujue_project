import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/widget/delay_visibility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PageStatus { loading, empty, completed, error }

enum ItemStatus { loading, empty, end, error }

const double _itemHeight = 48.0;

Widget pageLoading(BuildContext context) =>
    const DelayVisibility(child: Center(child: CircularProgressIndicator()));

Widget pageEmpty(BuildContext context) =>
    Center(child: Text("暂无数据", style: TextStyle(color: BaseColors.c2872fc)));

Widget pageError(BuildContext context, Function reload) => Center(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text("加载失败",
          style: TextStyle(color: BaseColors.fc3e5a)),
      CupertinoButton(
          child:
              const Text("点击重试", style: TextStyle(color: BaseColors.c2872fc)),
          onPressed: () => reload())
    ]));

Widget itemEmpty(BuildContext context) => Container(height: _itemHeight);

Widget itemLoading(BuildContext context) => SizedBox(
    height: _itemHeight,
    child: Center(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      const SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(strokeWidth: 2)),
      Container(
          padding: const EdgeInsets.only(left: 10),
          child: Text("加载中...",
              style: TextStyle(color: Theme.of(context).primaryColorLight)))
    ])));

Widget itemNoMore(BuildContext context) => SizedBox(
    height: _itemHeight,
    child: Center(
        child: Text("没有更多了",
            style: TextStyle(color: Theme.of(context).primaryColorLight))));

Widget itemError(BuildContext context, Function reload) => SizedBox(
    height: _itemHeight,
    child: Center(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text("加载失败",
          style: TextStyle(color: Theme.of(context).primaryColorLight)),
      GestureDetector(
          child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: const Text("点击重试",
                  style: TextStyle(color: BaseColors.c2872fc))),
          onTap: () => reload())
    ])));
