// import 'package:djqs/base/res/base_colors.dart';
// import 'package:djqs/base/res/base_icons.dart';
// import 'package:djqs/base/widget/media/video_util.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:video_player/video_player.dart';
//
// import 'media_enum.dart';
//
// class VideoViewWidget extends StatefulWidget {
//   final String? videoPath;
//   final bool showBack;
//   final bool needSDPermission;
//
//   final MediaSourceType sourceType;
//
//   VideoViewWidget(
//       {Key? key,
//       required this.videoPath,
//       this.showBack = true,
//       this.sourceType = MediaSourceType.net,
//       this.needSDPermission = false})
//       : super(key: key) {}
//
//   @override
//   _VideoViewWidgetState createState() => _VideoViewWidgetState();
// }
//
// class _VideoViewWidgetState extends State<VideoViewWidget> {
//   VideoUtil _videoUtil = VideoUtil();
//
//   @override
//   void initState() {
//     super.initState();
//     getPermissionAndInit(widget.sourceType);
//   }
//
//   void getPermissionAndInit(MediaSourceType type) async {
//     if (type == MediaSourceType.net)
//       await _videoUtil.initVCFromUrl(widget.videoPath!);
//     else if (type == MediaSourceType.file)
//       await _videoUtil.initVCFromFilePath(widget.videoPath!,
//           needPermission: widget.needSDPermission);
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         backgroundColor: BaseColors.trans,
//         body: Stack(
//           children: <Widget>[
//             _videoView(),
//             Positioned(
//               width: 1.sw,
//               child: VideoProgressIndicator(
//                 _videoUtil.videoController!,
//                 allowScrubbing: false,
//                 colors: VideoProgressColors(
//                     bufferedColor: BaseColors.c9c9c9,
//                     playedColor: BaseColors.f29b2d),
//               ),
//               bottom: 0,
//             ),
//             if (!_videoUtil.videoController!.value.isPlaying)
//               Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   top: 0,
//                   child: InkWell(
//                       onTap: () async {
//                         _videoUtil.videoController!.play();
//                         setState(() {});
//                       },
//                       child: Icon(
//                         Icons.play_circle_outline,
//                         color: Colors.white,
//                         size: 45.w,
//                       ))),
//             if (_videoUtil.videoController!.value.isPlaying)
//               Positioned(
//                   child: InkWell(
//                       onTap: () async {
//                         _videoUtil.videoController!.pause();
//                         setState(() {});
//                       },
//                       child: Icon(
//                         Icons.pause,
//                         color: Colors.white,
//                         size: 25.w,
//                       )),
//                   left: 3.w,
//                   bottom: 3.h),
//             if (widget.showBack)
//               Positioned(
//                   child: IconButton(
//                 icon: Icon(BaseIcons.iconXiangzuo,
//                     size: 20.w, color: Colors.white),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )),
//           ],
//         ),
//       );
//
//   Widget _videoView() => Container(
//         alignment: Alignment.center,
//         color: BaseColors.c161616.withOpacity(0.5),
//         child: (_videoUtil.videoController?.value.isInitialized ?? false)
//             ? Container(
//                 height: double.infinity,
//                 child: AspectRatio(
//                   aspectRatio: _videoUtil.videoController!.value.aspectRatio.h,
//                   child: VideoPlayer(_videoUtil.videoController!),
//                 ),
//               )
//             : Container(
//                 color: BaseColors.trans,
//               ),
//       );
//
//   void stopPlay() async {
//     if (_videoUtil.videoController?.value.isPlaying ?? false)
//       await _videoUtil.videoController?.pause();
//   }
//
//   @override
//   void dispose() {
//     stopPlay();
//   }
// }
