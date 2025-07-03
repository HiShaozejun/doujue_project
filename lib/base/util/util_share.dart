// import 'dart:typed_data';
//
// import 'package:djqs/base/const/base_const.dart';
// import 'package:djqs/base/res/base_colors.dart';
// import 'package:djqs/base/res/base_icons.dart';
// import 'package:djqs/base/ui/base_dialog.dart';
// import 'package:djqs/base/ui/base_widget.dart';
// import 'package:djqs/base/util/util_clipboard.dart';
// import 'package:djqs/base/util/util_image.dart';
// import 'package:djqs/base/util/util_object.dart';
// import 'package:djqs/base/widget/media/media_enum.dart';
// import 'package:djqs/common/module/start/util/app_init_util.dart';
// import 'package:flutter/material.dart';
// import 'package:fluwx/fluwx.dart';
//
// class BaseShareUtil {
//   static final String MP_NAME = 'gh_bb7765681c5a';
//   static final String MP_HOST = 'https://m.kuaimasupin.com/';
//   static final String MP_PATH = '/pages/index/index';
//
//   static final String SHARE_TIMELINE_TYPE_TASK = 'moments';
//   static final String SHARE_TIMELINE_TYPE_WITHDRAWAL = 'cash_out';
//
//   List<NormalListItem> _sheetData = [];
//
//   late final Fluwx _fluwx = Fluwx();
//
//   BaseShareUtil._internal() {
//     _sheetData.add(NormalListItem(
//       prefixIconData: BaseIcons.iconWeixin,
//       prefixIconColor: BaseColors.c34cc00,
//       primary: '微信好友',
//     ));
//     _sheetData.add(NormalListItem(
//       prefixIconData: BaseIcons.iconPengyouquan,
//       prefixIconColor: BaseColors.c34cc00,
//       primary: '朋友圈',
//     ));
//   }
//
//   init(String appId, {String? unisersalLink}) async {
//     await _fluwx.registerApi(
//       appId: appId,
//       doOnAndroid: true,
//       doOnIOS: true,
//       universalLink: unisersalLink,
//     );
//
//     _fluwx.addSubscriber((WeChatResponse response) {
//       //android
//       if (response is WeChatShowMessageFromWXRequest) {
//         if (!ObjectUtil.isEmptyStr(response.extMsg))
//           BaseClipboardUtil()
//               .dealWithContent(AppInitUtil().curContext!, response.extMsg!);
//       } //ios //todo
//       else if (response is WeChatLaunchFromWXRequest) {}
//     });
//   }
//
//   factory BaseShareUtil() => _instance;
//
//   static late final BaseShareUtil _instance = BaseShareUtil._internal();
//
//   void Function(WeChatResponse event) {}
//
//   void showBottomSheet(BuildContext context,
//       {Function(WeChatScene scene)? onSheetItemClick}) async {
//     if (!(await _fluwx.isWeChatInstalled)) {
//       BaseWidgetUtil.showToast('尚未安装微信，无法分享');
//       return;
//     }
//     BaseDialogUtil.showListBS(context,
//         title: '分享', titleCenter: false, topData: _sheetData, onTopItemClick:
//             (BuildContext sheetBC, BuildContext context, int index) {
//       Navigator.pop(sheetBC);
//       onSheetItemClick?.call(_getScene(index));
//     });
//   }
//
//   WeChatScene _getScene(int index) {
//     if (index == 0)
//       return WeChatScene.session;
//     else if (index == 1) return WeChatScene.timeline;
//     return WeChatScene.session;
//   }
//
//   void shareImage(
//       {required dynamic img,
//       required String thumbnail,
//       required MediaSourceType type,
//       String? title,
//       String? desc,
//       WeChatScene scene = WeChatScene.session}) async {
//     WeChatImage? weChatImage = await _getWeChatImage(type, img);
//     if (weChatImage != null)
//       _fluwx.share(WeChatShareImageModel(weChatImage,
//           title: title,
//           description: desc,
//           thumbnail: WeChatImage.network(thumbnail),
//           scene: scene));
//     else
//       BaseWidgetUtil.showToast('分享内容生成失败');
//   }
//
//   Future<WeChatImage?> _getWeChatImage(
//       MediaSourceType type, dynamic img) async {
//     switch (type) {
//       case MediaSourceType.net:
//         return WeChatImage.network(img);
//       case MediaSourceType.binary:
//         Uint8List? data =
//             await BaseImageUtil().widgetToImgU8L(img, isFirst: true);
//         return data == null ? null : WeChatImage.binary(data);
//       default:
//         null;
//     }
//   }
//
//   void shareText(String text, {WeChatScene scene = WeChatScene.session}) =>
//       _fluwx.share(WeChatShareTextModel(text, scene: scene));
//
//   void shareVideo(
//       {required String videoUrl,
//       required String? thumbnail,
//       String? title,
//       String? desc,
//       WeChatScene scene = WeChatScene.session}) {
//     _fluwx.share(WeChatShareVideoModel(
//       videoUrl: videoUrl,
//       thumbnail: WeChatImage.network(thumbnail!),
//       description: desc,
//       scene: scene,
//       title: title,
//     ));
//   }
//
//   void shareH5(
//       {required String url,
//       String? title,
//       String? desc,
//       String? thumbnail,
//       WeChatScene scene = WeChatScene.session,
//       Function()? callback}) async {
//     bool result = await _fluwx.share(WeChatShareWebPageModel(
//       url,
//       description: desc,
//       title: title ?? '',
//       thumbnail: WeChatImage.network(ObjectUtil.isEmptyStr(thumbnail)
//           ? BaseConst.IMG_DEFAULT_LOGO
//           : thumbnail!),
//       scene: scene,
//     ));
//     BaseWidgetUtil.showToast('分享${result ? '成功' : '失败'}');
//     if (result) callback?.call();
//   }
//
//   void shareToMP({
//     required String? thumbUrl,
//     String? title,
//     String? mpPath,
//     String? mpName,
//     String? mpHost,
//   }) {
//     WeChatShareMiniProgramModel model = WeChatShareMiniProgramModel(
//       webPageUrl: mpHost ?? MP_HOST,
//       userName: mpName ?? MP_NAME,
//       title: title ?? '',
//       path: mpPath ?? MP_PATH,
//       thumbnail: WeChatImage.network(thumbUrl!),
//     );
//     _fluwx.share(model);
//   }
//
//   void openMP(String mpName) =>
//       _fluwx.open(target: MiniProgram(username: mpName));
// }
