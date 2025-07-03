// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:djqs/app/app_icondata.dart';
// import 'package:djqs/base/frame/base_pagestate.dart';
// import 'package:djqs/base/res/base_colors.dart';
// import 'package:djqs/base/res/base_gaps.dart';
// import 'package:djqs/base/ui/base_ui_util.dart';
// import 'package:djqs/base/ui/base_widget.dart';
// import 'package:djqs/base/util/util_image.dart';
// import 'package:djqs/base/util/util_object.dart';
// import 'package:djqs/common/util/common_util_im.dart';
// import 'package:djqs/module/message/viewmodel/chat_report_vm.dart';
//
// //todo 重构
// class ChatReportPage extends StatefulWidget {
//   final isFromNative;
//
//   ChatReportPage({this.isFromNative = false});
//
//   @override
//   _ChatReportPageState createState() => _ChatReportPageState();
// }
//
// class _ChatReportPageState extends BasePageState<ChatReportPage, ChatReportVM> {
//   int index = 0;
//   List<String> urlList = [];
//   String inputValue = '';
//
//   @override
//   void initState() {
//     urlList.add('');
//     super.initState();
//   }
//
//   _back() {
//     if (widget.isFromNative) CommonIMUtil().invokeChatActivity(null);
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) => buildViewModel<ChatReportVM>(
//       appBar: BaseWidgetUtil.getAppbar(context, '举报', onLeftCilck: _back),
//       create: (context) => ChatReportVM(context),
//       viewBuild: (context, vm) {
//         double _screenWidth = 1.sw;
//         double imageSize = _screenWidth / 3 - 15;
//         index = urlList.length - 1;
//         return _body(imageSize);
//       });
//
//   _body(imageSize) => SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 Text('图片证据',
//                     style: BaseUIUtil().getTheme().textTheme.titleMedium),
//                 Text('$index张/9',
//                     style: BaseUIUtil().getTheme().primaryTextTheme.bodyMedium)
//               ]),
//               BaseGaps().vGap10,
//               _image(imageSize),
//               BaseGaps().vGap10,
//               Divider(),
//               _intput(),
//               BaseGaps().vGap10,
//               BaseWidgetUtil.getBottomButton("提交",
//                   onPressed: () => _onSaveInfo())
//             ],
//           ),
//         ),
//       );
//
//   Widget _image(imageSize) => Wrap(
//         spacing: 5,
//         runSpacing: 8,
//         children: urlList.asMap().keys.map<Widget>((key) {
//           String entity = urlList[key];
//           if (entity == '') {
//             return InkWell(
//               onTap: () {
//                 if (index == 9) {
//                   BaseWidgetUtil.showToast('最多上传9张');
//                   return;
//                 }
//                 BaseImageUtil().showImagePickerDialog(context,
//                     callback: (String? url) {
//                   if (!ObjectUtil.isEmptyAny(url)) {
//                     urlList.insert(0, url!);
//                     setState(() {});
//                   } else {
//                     BaseWidgetUtil.showToast('头像更新失败');
//                   }
//                 });
//               },
//               child: Container(
//                 width: imageSize,
//                 height: imageSize,
//                 color: BaseColors.c828282,
//                 child: Icon(Icons.add, size: 50.r, color: Colors.white),
//               ),
//             );
//           }
//           return Stack(children: [
//             Container(
//               width: imageSize,
//               height: imageSize,
//               child: Image.network(
//                 entity,
//                 fit: BoxFit.fitWidth,
//               ),
//             ),
//             Positioned(
//               child: InkWell(
//                 child: Container(
//                   child: Icon(AppIcons.iconGuanbi,
//                       size: 20.r, color: BaseColors.ffffff),
//                   decoration: BoxDecoration(
//                       color: BaseColors.e70012,
//                       borderRadius: BorderRadius.all(Radius.circular(3))),
//                 ),
//                 onTap: () {
//                   urlList.removeAt(key);
//                   setState(() {});
//                 },
//               ),
//               right: 0,
//               top: 0,
//             ),
//           ]);
//         }).toList(),
//       );
//
//   Widget _intput() => TextField(
//         keyboardType: TextInputType.multiline,
//         maxLines: 5,
//         onChanged: (String value) => inputValue = value,
//         decoration: InputDecoration(
//             hintText: '投诉内容',
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//             filled: true,
//             fillColor: BaseColors.ffffff),
//       );
//
//   _onSaveInfo() async {
//     if (ObjectUtil.isEmptyAny(inputValue)) {
//       BaseWidgetUtil.showToast('内容不能为空');
//       return;
//     }
//     if (index == 0) {
//       BaseWidgetUtil.showToast('至少要上传一张图片');
//       return;
//     }
//     String urlBuffer = '';
//     urlList.forEach((element) {
//       if (!ObjectUtil.isEmptyAny(element)) {
//         if (urlBuffer == '') {
//           urlBuffer = '$element';
//         } else {
//           urlBuffer = '$urlBuffer,$element';
//         }
//       }
//     });
//     var res = await Api.reportIM(inputValue, urlBuffer);
//     if (res != null) {
//       if (res['code'] == 2000) {
//         BaseWidgetUtil.showToast('举报成功');
//         _back();
//       } else
//         BaseWidgetUtil.showToast('服务器错误');
//     }
//   }
// }
