import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:djqs/base/res/base_icons.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'media_enum.dart';

//todo  StatelessWidget
class PhotoViewWidget extends StatefulWidget {
  List<String?>? images = [];
  int index;
  String? heroTag;
  bool showTitle;
  bool showBack;
  PageController? controller;

  MediaSourceType? sourceType;

  PhotoViewWidget(
      {Key? key,
      required this.images,
      this.index = 0,
      this.controller,
      this.heroTag,
      this.sourceType = MediaSourceType.net,
      this.showTitle = true,
      this.showBack = true})
      : super(key: key) {
    controller = PageController(initialPage: index!);
  }

  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BaseWidgetUtil.getInVisbileAppbar(),
        body: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
                builder: (BuildContext context, int index) =>
                    PhotoViewGalleryPageOptions(
                        onTapUp: (
                          BuildContext context,
                          TapUpDetails details,
                          PhotoViewControllerValue controllerValue,
                        ) =>
                            Navigator.of(context).pop(),
                        imageProvider: _imageView(widget.images![index] ?? ''),
                        heroAttributes: widget.heroTag == null
                            ? null
                            : PhotoViewHeroAttributes(tag: widget.heroTag!)),
                itemCount: widget.images!.length,
                pageController: widget.controller,
                onPageChanged: (int index) => setState(() {
                      widget.index = index;
                    })),
            Container(
              height: 60,
              child: Stack(
                children: [
                  if (widget.showBack)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: Icon(BaseIcons.iconXiangzuo,
                              size: 22.w, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop()),
                    ),
                  if (widget.showTitle)
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            "${widget.index + 1}/${widget.images!.length}",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.sp))),
                ],
              ),
            ),
          ],
        ),
      );

  ImageProvider? _imageView(String path) {
    switch (widget.sourceType) {
      case MediaSourceType.net:
        return CachedNetworkImageProvider(path);
      case MediaSourceType.asset:
        return AssetImage(path);
      case MediaSourceType.file:
        return FileImage(File(path));
      default:
        break;
    }
  }
}
