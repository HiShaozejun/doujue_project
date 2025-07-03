import 'dart:io';

import 'package:djqs/base/const/base_const.dart';
import 'package:djqs/base/util/util_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'util_file.dart';

class BaseFileCacheUtil {
  Directory? _cacheDir;
  Directory? _webCacheDir;
  Directory? _recCacheDir;

  late final _cacheManager = DefaultCacheManager();

  BaseFileCacheUtil._internal();

  Future<void> init() async {
    _cacheDir = Directory(
        (join((await getTemporaryDirectory()).path, DefaultCacheManager.key)));
    _webCacheDir = Directory((join(
        (await getTemporaryDirectory()).path, 'WebView'))); //默认webview缓存路径
    _recCacheDir =
        Directory((join((await getTemporaryDirectory()).path, 'cache_rec')));
    _recCacheDir!.create();
  }

  factory BaseFileCacheUtil() => _instance;

  static late final BaseFileCacheUtil _instance = BaseFileCacheUtil._internal();

  //默认缓存目录getTemporaryDirectory
  // /data/data/pacakage/cache/libCachedImageData，默认值和CachedNetworkImage共用一个
  CacheManager getCacheManager(String name, int maxNum) {
    final config = Config(
      name,
      stalePeriod: Duration(days: BaseConst.CACHE_DURATION),
      maxNrOfCacheObjects: maxNum,
    );
    final CacheManager cacheManager = CacheManager(config);
    return cacheManager;
  }

  cacheFileStream(BuildContext context, String url) async {
    Stream<FileResponse>? fileStream =
        _cacheManager.getFileStream(url, withProgress: false);

    StreamBuilder<FileResponse>(
        stream: fileStream,
        builder: (context, snapshot) {
          final loading =
              !snapshot.hasData || snapshot.data is DownloadProgress;
          if (snapshot.hasError) {
          } else if (loading) {
          } else {
            //finish
            FileInfo fileInfo = snapshot.requireData as FileInfo;
          }
          return Container();
        });
  }

  Future<File> cacheFile(String url) async =>
      await _cacheManager.getSingleFile(url);

  void dispose() => _cacheManager.dispose();

  Future<void> removeFile(String key) async => _cacheManager.removeFile(key);

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
    BaseFileUtil().deleteDir(_recCacheDir!);
  }

  String get recCacheDir => _recCacheDir!.path;

  String getCacheSize() {
    return _cacheDir!.existsSync()
        ? BaseFileUtil().formatSize(BaseFileUtil().getDirSize(_cacheDir!) +
            BaseFileUtil().getDirSize(_recCacheDir!))
        : BaseConst.CACHE_EMPTY;
  }

  String getWebViewCacheSize() {
    if (BaseSystemUtil().isAndroid)
      return _webCacheDir!.existsSync()
          ? BaseFileUtil().formatSize(BaseFileUtil().getDirSize(_webCacheDir!))
          : BaseConst.CACHE_EMPTY;
    else
      return '';
  }

  Future<void> clearWebviewCache() async {
    await WebViewController().clearCache();
    await WebViewController().clearLocalStorage();
  }
}
