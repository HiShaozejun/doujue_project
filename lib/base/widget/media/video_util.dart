// import 'dart:io';
//
// import 'package:djqs/base/util/util_file_cache.dart';
// import 'package:djqs/base/util/util_permission.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoUtil {
//   VideoUtil._internal();
//
//   factory VideoUtil() => _instance;
//
//   static late final VideoUtil _instance = VideoUtil._internal();
//
//   VideoPlayerController? videoController;
//
//   Future<void> initVCFromFilePath(String path,
//       {bool needPermission = false}) async {
//     if (needPermission)
//       BasePermissionUtil()
//           .requestSDPermission(() async => _initVCFromFile(path));
//     else
//       return _initVCFromFile(path);
//   }
//
//   Future<void> _initVCFromFile(String path) async {
//     videoController = VideoPlayerController.file(File(path));
//     return videoController?.initialize();
//   }
//
//   Future<void> initVCFromUrl(String url, {bool isCache = false}) async {
//     if (isCache) {
//       File file = await BaseFileCacheUtil().cacheFile(url);
//       videoController = VideoPlayerController.file(file);
//     } else
//       videoController = VideoPlayerController.networkUrl(Uri.parse(url));
//
//     return await videoController?.initialize();
//   }
//
//   void dispose() => videoController?.dispose();
// }
