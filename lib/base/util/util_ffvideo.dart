// import 'dart:io';
//
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
// import 'package:ffmpeg_kit_flutter/media_information_session.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
// import 'package:djqs/app/app_const.dart';
// import 'package:djqs/base/const/base_const.dart';
// import 'package:djqs/base/util/util_file.dart';
// import 'package:djqs/base/util/util_file_cache.dart';
// import 'package:djqs/base/util/util_log.dart';
// import 'package:djqs/base/util/util_object.dart';
// import 'package:djqs/base/util/util_system.dart';
//
// // import 'package:video_compress/video_compress.dart';
// // import 'package:video_thumbnail/video_thumbnail.dart';
//
// class FFVideoUtil {
//   FFVideoUtil._internal();
//
//   factory FFVideoUtil() => _instance;
//
//   static late final FFVideoUtil _instance = FFVideoUtil._internal();
//
//   //注意路径不要有空格，ffmpeg会识别不到
//   Future<String?> videoToAudio(String videoPath) async {
//     // //mp4->wav->pcm
//     // String cmd1 ="-i $lastestVideoFile -vn $lastestWavFile";
//     // Sring cmd2="-y -i $wavFile -acodec pcm_s16le -f s16le -ac 1 -ar 16000 $lastestAudioFile";
//
//     //mp4-->pcm
//     String filename = BaseFileUtil().getFileName(videoPath, includeDir: true)!;
//     String audioPath = '$filename.pcm';
//     String cmd =
//         "-i $videoPath -vn -acodec pcm_s16le -f s16le -ac 1 -ar 16000 $audioPath";
//     bool result = await _excuteFF(cmd: cmd);
//     return result ? audioPath : null;
//   }
//
//   Future<int?> getVideoDuration(String path) async {
//     MediaInformationSession session =
//         await FFprobeKit.getMediaInformation(path);
//     String? duration = session.getMediaInformation()?.getDuration();
//     if (ObjectUtil.isEmptyStr(duration)) return null;
//
//     return (double.parse(duration!) * 1000).round();
//   }
//
//   // 20s 33M压缩android 14s ios 20s
//   Future<String?> compressVideo(String videoPath) async {
//     File file = File(videoPath);
//     int size = await file.length();
//     if (size <= AppConst.LIMIT_VIDEO_SIZE_MAX * BaseConst.SIZE_MB)
//       return videoPath;
//
//     String outPath =
//         '${BaseFileCacheUtil().recCacheDir + Platform.pathSeparator + BaseFileUtil().getFileName(videoPath)!}_compressed.${BaseFileUtil().getFileSuffix(videoPath)}';
//     String cmd = '';
//
//     if (BaseSystemUtil().isAndroid)
//       cmd = "-i $videoPath -s 720x1080  -b:v 1M  -r 24 $outPath";
//     if (BaseSystemUtil().isIOS)
//       cmd = "-i $videoPath -s 720x1080  -b:v 1M  -r 24 $outPath";
//     bool result = await _excuteFF(cmd: cmd);
//     return result ? outPath : null;
//   }
//
//   Future<bool> _excuteFF({String? cmd, List<String>? args}) async {
//     final FFmpegSession session = await (args == null
//         ? FFmpegKit.execute(cmd!)
//         : FFmpegKit.executeWithArguments(args));
//     final ReturnCode? code = await session.getReturnCode();
//     if (ReturnCode.isSuccess(code)) return true;
//
//     BaseLogUtil().e(await session.getLogsAsString());
//     return false;
//   }
//
//   //position单位毫秒
//   Future<String?> getVideoThumbnail(String videoPath, int position,
//       {String? thumbPath}) async {
//     String outPath = thumbPath ??
//         '${BaseFileCacheUtil().recCacheDir + Platform.pathSeparator + BaseFileUtil().getFileName(videoPath)!}_cover.png';
//
//     var cmd = [
//       '-i',
//       videoPath,
//       '-ss',
//       (position / 1000).toString(),
//       '-vframes',
//       '1',
//       outPath
//     ];
//     bool result = await _excuteFF(args: cmd);
//     return result ? outPath : null;
//
//     // return await VideoThumbnail.thumbnailFile(
//     //     thumbnailPath: thumbPath,
//     //     video: videoPath,
//     //     maxWidth: (1.sw.toInt()),
//     //     quality: 100,
//     //     timeMs: position);
//   }
//
//   Future<int?> getDurationWithPlugin(String path) async {
//     // //with videocompress
//     // MediaInfo mediaInfo = await VideoCompress.getMediaInfo(path);
//     // if (mediaInfo == null) return 0;
//     // return mediaInfo.duration?.toInt();
//   }
//
//   ///压缩 VideoCompres相关缓存位置emulated/0/Android/data/com.bfhd.kmsp/files/video_compress/
// //origin在内部,/data/com.bfhd.kmsp/cache中
// //20秒视频压缩时长15秒
// // Future<String?> compressWithPlugin(String path) async {
// //   MediaInfo? compressInfo = await VideoCompress.compressVideo(
// //     path,
// //     quality: VideoQuality.MediumQuality,
// //     includeAudio: true,
// //     deleteOrigin: false,
// //   );
// //
// //   if (!ObjectUtil.isEmptyStr(compressInfo?.path)) {
// //     String compressPath = compressInfo!.path!;
// //     String outPath =
// //         '${BaseFileCacheUtil().recCacheDir + Platform.pathSeparator + BaseFileUtil().getFileName(compressPath.replaceAll(" ", ""))!}_compressed.${BaseFileUtil().getFileSuffix(compressPath)}';
// //     BaseFileUtil().moveFile(compressPath, outPath);
// //     return outPath;
// //   }
// //   return null;
// // }
// }
