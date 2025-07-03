import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'util_object.dart';

/**
 * getTemporaryDirectory app内部缓存目录  data/data/packagename/cache,webview的缓存等都在这里
 * getApplicationDocumentsDirectory() app文档目录 data/data/packagename/app_flutter
 *getExternalStorageDirectory 外部存储目录，如SD卡  /storage/emulated/0/Android/data/packagename/files,仅适用于android,ios不支持会抛出异常
 *getApplicationSupportDirectory /data/user/0/com.bfhd.kmsp/files
 * */
class BaseFileUtil {
  late final Directory? _tempDirectory;

  BaseFileUtil._internal();

  factory BaseFileUtil() => _instance;

  static late final BaseFileUtil _instance = BaseFileUtil._internal();

  Future<void> init() async {
    _tempDirectory = await getTemporaryDirectory();
  }

  Directory? get tempDirectory => _tempDirectory;

  void initPath(String path) {
    Directory fileDir = Directory(path);
    try {
      if (!(fileDir.existsSync())) {
        fileDir.createSync();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> loadAsset(String path) async =>
      await rootBundle.loadString(path);

  Future<Directory?> createDir(String path) async {
    if (ObjectUtil.isEmpty(path)) {
      return null;
    }

    Directory dir = new Directory(path);
    bool exist = await dir.exists();
    if (!exist) {
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  void renameFile(String oldPath, String newPath) =>
      File(oldPath).renameSync(newPath);

  void moveFile(String oldPath, String newPath) {
    File oldFile = File(oldPath);
    try {
      oldFile.copySync(newPath);
      oldFile.deleteSync();
    } catch (e) {}
  }

  void deleteFilePath(String? path) {
    if (ObjectUtil.isEmptyStr(path)) return;

    File file = File(path!);
    deleteFile(file);
  }

  void deleteFile(File? file) async => file?.deleteSync();

  void deleteDir(Directory dir, {bool keepDir = true}) {
    if (dir.existsSync()) {
      if (keepDir) {
        List<FileSystemEntity> files = dir.listSync();
        for (var file in files) {
          file.deleteSync();
        }
      } else
        dir.deleteSync();
    }
  }

  String getFileDir(String fullPath) =>
      fullPath.substring(0, fullPath.lastIndexOf(Platform.pathSeparator));

  String getFileSuffix(String fullPath, {bool includeDot = false}) =>
      fullPath.substring(
          fullPath.toLowerCase().lastIndexOf('.') + (includeDot ? 0 : 1));

  String? getFileName(String? fullPath,
      {bool includeSuffix = false, bool includeDir = false}) {
    if (ObjectUtil.isEmptyStr(fullPath)) return null;
    int lastDotIndex = fullPath!.toLowerCase().lastIndexOf('.');
    int lastIndex = fullPath!.toLowerCase().lastIndexOf(Platform.pathSeparator);
    String name = fullPath.substring(lastIndex + 1, lastDotIndex);
    if (includeSuffix) return fullPath?.substring(lastIndex + 1);
    if (includeDir) return fullPath?.substring(0, lastDotIndex);

    return name;
  }

  String formatSize(double size) =>
      '${(size / 1024.0 / 1024.0).toStringAsFixed(2)} MB';

  double getDirSize(Directory root) {
    double totalSize = 0;
    for (FileSystemEntity file in root.listSync(recursive: true)) {
      if (file is File && file.existsSync()) {
        totalSize += file.lengthSync();
      }
    }
    return totalSize;
  }

  String renderSize(double value) {
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
