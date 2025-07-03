import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:djqs/app/app_const.dart';
import 'package:djqs/base/const/base_const.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_file.dart';
import 'package:djqs/base/util/util_file_cache.dart';
import 'package:djqs/base/util/util_permission.dart';
import 'package:djqs/base/widget/media/media_enum.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:djqs/common/util/common_util_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import 'util_object.dart';

enum ImageFormat { png, jpg, gif, webp, svg }

enum ImageRaw { asset, res }

extension ImageFormatExtension on ImageFormat {
  String get value => ['png', 'jpg', 'gif', 'webp', 'svg'][index];
}

class BaseImageUtil {
  late final ImagePicker _picker = ImagePicker();

  late final ScreenshotController screenController = ScreenshotController();

  factory BaseImageUtil() => _instance;
  static late final BaseImageUtil _instance = BaseImageUtil._internal();

  BaseImageUtil._internal();

  Image getRawImg(String name,
          {double? height,
          double? width,
          BoxFit? fit = BoxFit.fill,
          ImageFormat format = ImageFormat.png,
          ImageRaw source = ImageRaw.asset}) =>
      Image.asset(
        source == ImageRaw.asset ? getAssetImgPath(name) : getResImgPath(name),
        height: height,
        width: width,
        fit: fit,
      );

  String getResImgPath(String name, {ImageFormat format = ImageFormat.png}) =>
      'res/images/$name.${format.value}';

  String getAssetImgPath(String name, {ImageFormat format = ImageFormat.png}) =>
      'assets/images/$name.${format.value}';

  Widget getAssetSvg(String name,
      {ImageFormat format = ImageFormat.png, double? size, Color? color}) {
    return SvgPicture.asset(
      getAssetImgPath(name, format: ImageFormat.svg),
      colorFilter: color == null
          ? ColorFilter.mode(Colors.transparent, BlendMode.color)
          : ColorFilter.mode(color, BlendMode.srcIn),
      width: size,
      height: size,
    );
  }

  //图片缓存
  Widget getCachedImageWidget(
          {required String? url,
          BoxFit? fit = BoxFit.cover,
          bool showPlaceHolderImg = true,
          Widget? errorWidget,
          String? defaultImgUrl}) =>
      CachedNetworkImage(
          fit: fit,
          fadeOutDuration: const Duration(milliseconds: 100),
          fadeInDuration: const Duration(milliseconds: 100),
          imageUrl: url ?? defaultImgUrl ?? BaseConst.IMG_DEFAULT_LOGO,
          // cacheManager: BaseFileCacheUtil()
          //     .getCacheManager(BaseConst.CACHE_DIR_NAME, 500),
          placeholder: (context, url) => showPlaceHolderImg
              ? getRawImg(BaseConst.IMG_ASSET_PLACEHOLDER)
              : Container(),
          //Placeholder()
          errorWidget: (context, url, error) =>
              errorWidget ??
              getCachedImageWidget(
                  url: defaultImgUrl ?? BaseConst.IMG_DEFAULT_LOGO,
                  errorWidget: const Icon(Icons.error_outline)));

  Widget getCachedImageWidgetSized(
          {required String? url,
          BoxFit fit = BoxFit.cover,
          bool showPlaceHolderImg = true,
          Widget? errorWidget,
          required double? width,
          required double? height,
          String? defaultImgUrl}) =>
      CachedNetworkImage(
          fit: fit,
          width: width,
          height: height,
          fadeOutDuration: const Duration(milliseconds: 100),
          fadeInDuration: const Duration(milliseconds: 100),
          imageUrl: url ?? defaultImgUrl ?? BaseConst.IMG_DEFAULT_LOGO,
          // cacheManager: BaseFileCacheUtil()
          //     .getCacheManager(BaseConst.CACHE_DIR_NAME, 500),
          placeholder: (context, url) => showPlaceHolderImg
              ? getRawImg(BaseConst.IMG_ASSET_PLACEHOLDER)
              : Container(),
          //Placeholder()
          errorWidget: (context, url, error) =>
              errorWidget ??
              getCachedImageWidget(
                  url: defaultImgUrl ?? BaseConst.IMG_DEFAULT_LOGO,
                  errorWidget: const Icon(Icons.error_outline)));

  //图片变更时整个container空白,无法自然过渡
  Widget getCachedProviderWithChild(
          {required String? url,
          BoxFit fit = BoxFit.cover,
          Widget? child,
          String? defaultImgUrl}) =>
      CachedNetworkImage(
          fadeOutDuration: const Duration(milliseconds: 100),
          fadeInDuration: const Duration(milliseconds: 100),
          //使用errorWidget处理不生效
          imageUrl: url ?? defaultImgUrl ?? AppConst.IMAGE_DEFAULT,
          imageBuilder: (context, imageProvider) => Container(
              child: child,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ))
              //placeholder: (context, url) => const CircularProgressIndicator(),
              // errorWidget: (context, url) =>const Icon(Icons.error_outline),
              ));

  ImageProvider getCachedProvider(String? url,
          {BoxFit fit = BoxFit.cover, String? defaultImgUrl}) =>
      CachedNetworkImageProvider(
          url ?? defaultImgUrl ?? BaseConst.IMG_DEFAULT_LOGO);

  Future<void> clearImageCache(String url) async =>
      await CachedNetworkImageProvider(url).evict();

  //图片压缩
  Future<XFile?> compressImage(String filePath, {int quality = 88}) async {
    String suffix = BaseFileUtil().getFileSuffix(filePath);
    String outPath =
        '${BaseFileCacheUtil().recCacheDir + Platform.pathSeparator + BaseFileUtil().getFileName(filePath)!}_compressed.${suffix}';

    final XFile? file = await FlutterImageCompress.compressAndGetFile(
      format: _getImgFormat(suffix),
      filePath,
      outPath,
      quality: quality,
    );

    return file;
  }

  CompressFormat _getImgFormat(String suffix) {
    switch (suffix) {
      case 'jpg':
      case 'jpeg':
        return CompressFormat.jpeg;
      case 'png':
        return CompressFormat.png;
      case 'webp':
        return CompressFormat.webp;
      case 'heic':
        return CompressFormat.heic;
      default:
        return CompressFormat.jpeg;
    }
  }

  //保存网络资源到本地相册，适用于照片视频等
  FutureOr<dynamic> saveImgToGallary(String? path,
      {required MediaSourceType? type, required MediaType mediaType}) async {
    if (ObjectUtil.isEmptyStr(path)) return;

    BasePermissionUtil().requestSDPermission(() async {
      if (type == MediaSourceType.net) {
        Response<dynamic> response = await Dio()
            .get(path!, options: Options(responseType: ResponseType.bytes));

        if (mediaType == MediaType.image)
          return await ImageGallerySaver.saveImage(
              Uint8List.fromList(response.data));
        else if (mediaType == MediaType.video) {
          Uint8List videoBytes = Uint8List.fromList(response.data);

          String name = BaseFileUtil().getFileName(path)!;
          String outPath =
              '${BaseFileUtil().tempDirectory?.path}${Platform.pathSeparator}${name}_saved${BaseFileUtil().getFileSuffix(path, includeDot: true)}';
          File videoFile = File(outPath);
          try {
            await videoFile.writeAsBytes(videoBytes);
            var result = await ImageGallerySaver.saveFile(videoFile.path);
            videoFile.delete();
            return result;
          } catch (e) {
            return null;
          }
        }
      } else if (type == MediaSourceType.file) {
        return await ImageGallerySaver.saveFile(path!);
      }
    });
  }

  //访问媒体照片(拍照or相册)
  Future<XFile?>? gotoPickImage({source = ImageSource.gallery}) async {
    if (source == ImageSource.camera &&
        !_picker!.supportsImageSource(ImageSource.camera)) {
      BaseWidgetUtil.showToast("不支持拍照");
      return null;
    }
    return await _picker.pickImage(
      source: source,
      maxWidth: 720,
      maxHeight: 1920,
      imageQuality: null, //原画质
    );
  }

  //访问媒体视频
  Future<XFile?>? gotoPickVideo({source = ImageSource.gallery}) async {
    if (source == ImageSource.camera &&
        !_picker!.supportsImageSource(ImageSource.camera)) {
      BaseWidgetUtil.showToast("不支持拍摄");
      return null;
    }
    return await _picker?.pickVideo(source: ImageSource.gallery);
  }

  //通过拍照or相册获取照片并上传
  void showImagePickerDialog(BuildContext context,
      {Function(String? url)? callback}) {
    _showMediaPickerBS(context, type: MediaType.image,
        callback: (XFile? file) async {
      if (file != null) {
        XFile? compressFile = await compressImage(file.path);
        if (compressFile != null) {
          CommonUploadUtil().uploadToCos(compressFile.path, callback: callback);
        } else {
          BaseWidgetUtil.showToast('图片压缩失败，请检查后缀名是否正确！');
        }
      } else
        BaseWidgetUtil.showToast('未选择照片');
    });
  }

  //通过拍照获取照片并上传
  void getImageByCamera(BuildContext context,
      {Function(String? url)? callback}) async {
    XFile? file = await gotoPickImage(source: ImageSource.camera);
    if (file != null) {
      XFile? compressFile = await compressImage(file.path);
      if (compressFile != null) {
        CommonUploadUtil().uploadToCos(compressFile.path, callback: callback);
      } else {
        BaseWidgetUtil.showToast('图片压缩失败，请检查后缀名是否正确！');
      }
    } else
      BaseWidgetUtil.showToast('未选择照片');
  }

  //通过拍照or相册获取视频并上传
  void showVideoPickerDialog(BuildContext context,
      {Function(String? url)? callback, bool upload = true}) {
    _showMediaPickerBS(context, type: MediaType.video,
        callback: (XFile? file) async {
      // if (file != null) {
      //   if (!upload)
      //     callback?.call(file?.path);
      //   else {
      //     String? compressPath = await _ffUtil.compressVideo(file.path);
      //     if (!ObjectUtil.isEmpty(compressPath)) {
      //       CommonUploadUtil().uploadToVod(compressPath,
      //           callback: (TXPublishResult? entity) =>
      //               callback?.call(entity?.videoURL));
      //     } else {
      //       BaseWidgetUtil.showToast('视频压缩失败，请检查后缀名是否正确！');
      //     }
      //   }
      // } else
      //   BaseWidgetUtil.showToast('未选择视频');
    });
  }

  void _showMediaPickerBS(BuildContext context,
      {Function(XFile? file)? callback, MediaType type = MediaType.image}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: BaseColors.trans,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BaseWidgetUtil.getContainer(
                  color:
                      BaseUIUtil().getTheme().bottomSheetTheme.backgroundColor!,
                  marginL: 5.h,
                  marginR: 5.h,
                  paddingH: 20.h,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            callback!.call(type == MediaType.image
                                ? await gotoPickImage(
                                    source: ImageSource.camera)
                                : await gotoPickVideo(
                                    source: ImageSource.camera));
                          },
                          child: Container(
                            width: 1.sw,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            alignment: Alignment.center,
                            child: Text(type == MediaType.image ? '拍照' : '拍摄',
                                style: BaseUIUtil()
                                    .getTheme()
                                    .textTheme
                                    .titleMedium),
                          )),
                      Divider(),
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            callback!.call(type == MediaType.image
                                ? await gotoPickImage(
                                    source: ImageSource.gallery)
                                : await gotoPickVideo(
                                    source: ImageSource.gallery));
                          },
                          child: Container(
                              width: 1.sw,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              alignment: Alignment.center,
                              child: Text('本地相册',
                                  style: BaseUIUtil()
                                      .getTheme()
                                      .textTheme
                                      .titleMedium))),
                    ],
                  ),
                ),
                BaseGaps().vGap10,
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: BaseUIUtil()
                              .getTheme()
                              .bottomSheetTheme
                              .backgroundColor!,
                        ),
                        width: 1.sw,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        alignment: Alignment.center,
                        child: Text('取消',
                            style: TextStyle(
                                color: BaseUIUtil()
                                    .getTheme()
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontWeight: BaseDimens.fw_s)))),
              ],
            ),
          );
        });
  }

  Future<ui.Image?> getImageSize(XFile? file) async {
    return file == null ? null : decodeImageFromList(await file.readAsBytes());
  }

  //第一次会报错,首次失败会进行第二次，且capure时间较久，250为测试通过值
  Future<Uint8List?> widgetToImgU8L(Widget widget,
      {double pixelRatio = 1.5, bool? isFirst}) async {
    await BaseWidgetUtil.showLoading();
    try {
      Uint8List? data = await screenController.captureFromWidget(widget,
          context: AppInitUtil().curContext!,
          pixelRatio: pixelRatio,
          delay: Duration(milliseconds: 250));
      await BaseWidgetUtil.cancelLoading();
      return data;
    } catch (e) {
      if (isFirst == true) {
        isFirst = false;
        return await widgetToImgU8L(
          widget,
          isFirst: isFirst,
          pixelRatio: pixelRatio,
        );
      } else {
        await BaseWidgetUtil.cancelLoading();
        return null;
      }
    }
  }

  Future<String?> widgetToImg(globalKey, String name) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      File file = File(
          '${BaseFileUtil().tempDirectory?.path ?? ''}/${DateTime.now().millisecondsSinceEpoch}${name}.png');
      await file.writeAsBytes(byteData!.buffer.asInt8List(), flush: true);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List?> captureScreen({double pixelRatio = 1.0}) async {
    try {
      Uint8List? data = await screenController.capture(
          delay: Duration(milliseconds: 10), pixelRatio: pixelRatio);
      return data;
    } catch (e) {
      return null;
    }
  }

//todo
  Future<dynamic?>? loadImage(String path) {
    if (ObjectUtil.isEmptyAny(path)) {
      return null;
    }
    ImageStream stream;
    if (path.startsWith('http')) {
      stream = NetworkImage(
        path,
      ).resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(
        path,
      ).resolve(ImageConfiguration.empty);
    }

    Completer<ui.Image> completer = Completer();
    void listen(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(ImageStreamListener(listen));
    }

    stream.addListener(ImageStreamListener(listen));
    return completer.future;
  }

  Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStreamListener? listener;
    ImageStream stream = provider.resolve(config);
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener!);
    });
    stream.addListener(listener);
    return completer.future;
  }

  Future<ui.Image> getPaintImage(String filePath) async =>
      decodeImageFromList(await XFile(filePath).readAsBytes())
          .then((ui.Image value) {
        return value;
      });

  Future<String?> drawMark(
    String path,
    String text,
    TextStyle style,
    Offset offset,
  ) async {
    ui.Image baseImage = await BaseImageUtil().getPaintImage(path);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(baseImage, Offset.zero, Paint());

    final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx, baseImage.height - offset.dy));

    final Picture picture = recorder.endRecording();
    final ui.Image img =
        await picture.toImage(baseImage.width, baseImage.height);

    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);
    String name = BaseFileUtil().getFileName(path)!;
    File file = File(
        '${BaseFileUtil().tempDirectory?.path ?? ''}/${DateTime.now().millisecondsSinceEpoch}${name}.png');
    await file.writeAsBytes(byteData!.buffer.asInt8List(), flush: true);
    return file.path;
  }
}
