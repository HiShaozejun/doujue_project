import 'package:djqs/base/extensions/function_extensions.dart';
import 'package:djqs/base/ui/paging/status_controller.dart';
import 'package:djqs/base/ui/paging/status_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BaseListView extends StatefulWidget {
  final ScrollController? scrollController;
  final StatusController statusController;
  final int itemCount;
  final Function? onPageReload;
  final Function? onItemReload;
  final Function? onLoadMore;
  final IndexedWidgetBuilder? itemBuilder;
  final AnimatedItemBuilder? itemAnimatedBuilder;
  final Widget? pageLoading;
  final Widget? pageEmpty;
  final Widget? pageError;
  final Widget? itemLoading;
  final Widget? itemError;
  final Widget? itemNoMore;
  final List<Widget> headerChildren;
  final List<Widget> footerChildren;
  final int itemMoreCount = 1;
  final bool isLoadMore;
  final bool isListView;
  final bool isAnimatedListView;
  final GlobalKey? listKey;

  const BaseListView(
      {Key? key,
      required this.statusController,
      required this.itemCount,
      this.itemBuilder,
      this.itemAnimatedBuilder,
      this.scrollController,
      this.onPageReload,
      this.onItemReload,
      this.onLoadMore,
      this.pageLoading,
      this.pageEmpty,
      this.pageError,
      this.itemLoading,
      this.itemError,
      this.itemNoMore,
      this.isLoadMore = false,
      this.isListView = true,
      this.isAnimatedListView = false,
      this.listKey,
      this.headerChildren = const <Widget>[],
      this.footerChildren = const <Widget>[]})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BaseListViewState();
}

class _BaseListViewState extends State<BaseListView> {
  late PageStatus _pageStatus;
  late ItemStatus _itemStatus;
  late ScrollController _controller;

  void initScrollController() {
    _controller = widget.scrollController ?? ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (widget.statusController.itemStatus != ItemStatus.end &&
            widget.statusController.itemStatus != ItemStatus.error) {
          widget.onLoadMore?.checkNullInvoke();
        }
      }
    });
  }

  void changeStatus() {
    setState(() {
      _pageStatus = widget.statusController.pageStatus;
      _itemStatus = widget.statusController.itemStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageStatus = widget.statusController.pageStatus;
    _itemStatus = widget.statusController.itemStatus;
    widget.statusController.addListener(changeStatus);
    initScrollController();
  }

  @override
  void dispose() {
    widget.statusController.removeListener(changeStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildPageWidget(context);

  Widget buildPageWidget(BuildContext context) {
    switch (_pageStatus) {
      case PageStatus.loading:
        return widget.pageLoading ?? pageLoading(context);
      case PageStatus.empty:
        return widget.pageEmpty ?? pageEmpty(context);
      case PageStatus.error:
        return widget.pageError ??
            pageError(context, () {
              widget.statusController.pageLoading().itemEmpty();
              widget.onPageReload.checkNullInvoke();
            });
      case PageStatus.completed:
        return widget.isAnimatedListView
            ? buildAnimatedListViewPageData(context)
            : (widget.isListView
                ? buildListViewPageData(context)
                : Container());
      default:
        return pageLoading(context);
    }
  }

  Widget buildListViewPageData(BuildContext context) {
    // 屏蔽滚动水波纹效果
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification? overscroll) {
          overscroll?.disallowIndicator();
          return true;
        },
        child: ListView.builder(
            controller: _controller,
            padding: const EdgeInsets.all(0),
            itemCount: widget.itemCount +
                widget.headerChildren.length +
                widget.footerChildren.length +
                widget.itemMoreCount,
            itemBuilder: (BuildContext context, int index) {
              //headerItem
              if (index < widget.headerChildren.length) {
                return widget.headerChildren[index];
              }

              //contentItem
              if (index < (widget.headerChildren.length + widget.itemCount)) {
                return widget.itemBuilder!(
                    context, index - widget.headerChildren.length);
              }

              //footerItem
              if (index <
                  (widget.headerChildren.length +
                      widget.itemCount +
                      widget.footerChildren.length)) {
                return widget.footerChildren[
                    index - (widget.headerChildren.length + widget.itemCount)];
              }

              return buildItemWidget(context);
            }));
  }

  Widget buildAnimatedListViewPageData(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification? overscroll) {
          overscroll?.disallowIndicator();
          return true;
        },
        child: AnimatedList(
            key: widget.listKey,
            controller: _controller,
            padding: const EdgeInsets.all(0),
            initialItemCount: widget.itemCount +
                widget.headerChildren.length +
                widget.footerChildren.length +
                widget.itemMoreCount,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              if (index < widget.headerChildren.length)
                return widget.headerChildren[index];

              if (index < (widget.headerChildren.length + widget.itemCount))
                return widget.itemAnimatedBuilder!(
                    context, index - widget.headerChildren.length, animation);

              if (index <
                  (widget.headerChildren.length +
                      widget.itemCount +
                      widget.footerChildren.length))
                return widget.footerChildren[
                    index - (widget.headerChildren.length + widget.itemCount)];

              return buildItemWidget(context);
            }));
  }

  // Widget buildGridViewPageData(BuildContext context) {
  //   return NotificationListener<OverscrollIndicatorNotification>(
  //       onNotification: (OverscrollIndicatorNotification? overscroll) {
  //         overscroll?.disallowIndicator();
  //         return true;
  //       },
  //       child: MasonryGridView.count(
  //           controller: _controller,
  //           padding: const EdgeInsets.all(0),
  //           itemCount: widget.itemCount +
  //               widget.headerChildren.length +
  //               widget.footerChildren.length +
  //               widget.itemMoreCount,
  //           crossAxisCount: 2,
  //           mainAxisSpacing: 5.w,
  //           crossAxisSpacing: 5.w,
  //           itemBuilder: (BuildContext context, int index) {
  //             if (index < widget.headerChildren.length)
  //               return widget.headerChildren[index];
  //
  //             if (index < (widget.headerChildren.length + widget.itemCount))
  //               return widget.itemBuilder!(
  //                   context, index - widget.headerChildren.length);
  //
  //             if (index <
  //                 (widget.headerChildren.length +
  //                     widget.itemCount +
  //                     widget.footerChildren.length))
  //               return widget.footerChildren[
  //                   index - (widget.headerChildren.length + widget.itemCount)];
  //
  //             return buildItemWidget(context);
  //           }));
  // }

  Widget buildItemWidget(BuildContext context) {
    switch (_itemStatus) {
      case ItemStatus.loading:
        return itemLoading(context);
      case ItemStatus.empty:
        return itemEmpty(context);
      case ItemStatus.error:
        return itemError(context, () {
          widget.statusController.itemLoading();
          widget.onItemReload.checkNullInvoke();
        });
      case ItemStatus.end:
        return itemNoMore(context);
      default:
        return itemEmpty(context);
    }
  }
}
