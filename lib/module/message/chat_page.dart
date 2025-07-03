import 'dart:async';
import 'dart:convert';

import 'package:djqs/base/event/event_bus.dart';
import 'package:djqs/base/event/event_code.dart';
import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/route/base_util_route.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_log.dart';
import 'package:djqs/base/util/util_notification.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/base/widget/bubble_widget.dart';
import 'package:djqs/base/widget/media/photo_view_widget.dart';
import 'package:djqs/common/util/common_util_im.dart';
import 'package:djqs/module/message/util/emoji_util.dart';
import 'package:djqs/module/message/vm/chat_vm.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_text_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';

//todo 重构
class ChatPage extends StatefulWidget {
  String? title;
  String? chatId;
  String? cardEntity;

  ChatPage({this.title, this.chatId, this.cardEntity});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends BasePageState<ChatPage, ChatVM> {
  MediaQueryData? mediaQuery;
  List<V2TimMessage> msgList = [];
  String? lastMsgID;

  ScrollController listViewController = ScrollController();
  Map<String, Emoji> emojis = {};

  @override
  Widget build(BuildContext context) => buildViewModel<ChatVM>(
      appBar: BaseWidgetUtil.getAppbar(
        context, widget.title ?? '消息',
        // rightItem: NormalListItem(rightType: ItemType.TEXT, suffixStr: '举报'),
        // onRightClick: () =>
        //     BaseRouteUtil.push(context, ChatReportPage(isFromNative: true))
      ),
      create: (context) => ChatVM(context),
      viewBuild: (context, vm) => body());

  @override
  void initState() {
    super.initState();
    EventBus().on(EventCode.MSG_CHAT_NEW, (args) {
      CommonIMUtil().markC2CMessageAsRead(userID: widget.chatId);
      V2TimMessage msg = args;
      setState(() => msgList.add(msg));
      Future.delayed(
          Duration(milliseconds: 500),
          () => listViewController.position.moveTo(
              listViewController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200)));
    });
    BaseNotificationUtil().cancelAllNotifications();
    Future.delayed(Duration(milliseconds: 100), () async {
      if (!ObjectUtil.isEmptyAny(widget.cardEntity)) {
        CommonIMUtil()
            .sendC2CTextMessage(text: widget.cardEntity, userID: widget.chatId)
            .then((_) => setState(() => _refreshMsgList()));
      } else
        setState(() => _getMsgList());
    });
  }

  _getMsgList() async {
    V2TimValueCallback<List<V2TimMessage>>? result = await CommonIMUtil()
        .getC2CHistoryMessageList(
            userID: widget.chatId, count: 10, lastMsgID: lastMsgID);
    if (result.data != null && result.data!.length > 0) {
      setState(() {
        msgList.insertAll(0, result.data!.reversed);
        if (msgList.length > 0) {
          lastMsgID = msgList[0].msgID;
        }
      });
    } else
      BaseWidgetUtil.showToast('没有更多消息');
  }

  _refreshMsgList() async {
    V2TimValueCallback<List<V2TimMessage>> result = await CommonIMUtil()
        .getHistoryMessageList(userID: widget.chatId, count: 1);
    if (result != null && result.data != null && result.data!.length > 0) {
      setState(() {
        if (result != null) {
          msgList.add(result.data![0]);
          lastMsgID = msgList[0].msgID;
          Future.delayed(Duration(milliseconds: 500), () {
            listViewController.position.moveTo(
                listViewController.position.maxScrollExtent,
                duration: Duration(milliseconds: 200));
          });
        }
      });
    } else {}
  }

  Widget body() => Column(children: <Widget>[
        Container(width: 1.sw,
          padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
          alignment: Alignment.centerLeft,
          color: BaseColors.f5f5f5,
          child: Text('订单：${widget.cardEntity}',style: BaseUIUtil().getTheme().primaryTextTheme.displayMedium,),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: listViewController,
                itemCount: msgList.length,
                itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: _buildMsgContext(index),
                    )),
          ),
        ),
        _buildBottomView()
      ]);

  Future<void> _onRefresh() async {
    await _getMsgList();
  }

  Widget _buildMsgContext(index) {
    Widget? messageContent;
    V2TimMessage message = msgList[index];
    if (message.isSelf!) {
      if (isJobCard(message))
        messageContent = _buildJobCard(message);
      else
        messageContent = _buildContent(message, isLeft: false);
    } else
      messageContent = _buildContent(message);

    return messageContent;
  }

  bool isJobCard(V2TimMessage message) {
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
      V2TimTextElem textMessage = message.textElem!;
      String element = textMessage.text!;
      if (element.contains('chatExtraType')) {
        try {
          Map result = jsonDecode(element);
          if (result['chatExtraType'] == 1000) return true;
        } catch (e) {
          return false;
        }
      }
    }
    return false;
  }

  Widget _buildJobCard(V2TimMessage message) {
    // JobCardEntity jobCardEntity =
    //     JobCardEntity.fromJson(jsonDecode(message.textElem!.text!));

    return InkWell(
        onTap: () => {},
        child: Container(width: 45, color: BaseColors.c828282));
  }

  Widget _avatarView(String? url) => CircleAvatar(
      backgroundImage: BaseImageUtil().getCachedProvider(url), radius: 20.r);

  Widget _buildContent(V2TimMessage data, {bool isLeft = true}) => Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Row(
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            isLeft ? _avatarView(data?.faceUrl) : _buildMessageContent(data),
            BaseGaps().hGap5,
            isLeft ? _buildMessageContent(data) : _avatarView(data?.faceUrl)
          ],
        ),
      );

  Widget _buildMessageContent(V2TimMessage message) {
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT)
      return _buildTextMessageContent(message.isSelf, message.textElem!.text!);
    else if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE)
      return _buildImageMessageContent(message);
    else {
      return _bubbleWidget(message.isSelf,
          child: Text('[不支持的自定义消息]' ?? '',
              style: TextStyle(color: Colors.blueAccent, fontSize: 14.sp)));
    }
  }

  Widget _bubbleWidget(bool? isSelf, {Widget? child}) => BubbleWidget(
        innerPaddingH: 15.w,
        color: isSelf == true
            ? BaseUIUtil().isThemeDark()
                ? BaseColors.c5d6feb
                : BaseColors.c34cc00
            : BaseUIUtil().isThemeDark()
                ? BaseColors.c393939
                : BaseColors.f5f5f5,
        position: isSelf == true
            ? BubbleArrowDirection.right
            : BubbleArrowDirection.left,
        child: child,
      );

  Widget _buildTextMessageContent(bool? isSelf, String string) => _bubbleWidget(
      isSelf,
      child: _isEmoji(string)
          ? RichText(
              text: buildEmojiRichText(
                  string, BaseUIUtil().getTheme().textTheme.titleMedium!),
            )
          : Text(string, style: BaseUIUtil().getTheme().textTheme.titleMedium));

  Widget _buildImageMessageContent(V2TimMessage message) {
    V2TimImageElem? imageMessage = message.imageElem!;
    List<V2TimImage?>? imageList = imageMessage.imageList;
    String? imageUrl = '';
    if (imageList!.length > 0) imageUrl = imageList[0]!.url;

    return InkWell(
      onTap: () => BaseRouteUtil.push(
          context,
          PhotoViewWidget(
            images: [imageUrl], //传入图片list
            index: 0, //传入当前点击的图片的index
            heroTag: '',
          )),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: BaseColors.f5f5f5,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _buildBottomView() => ChatBottomView(
        userID: widget.chatId,
        sendCallBack: () {
          _refreshMsgList();
        },
      );

  TextSpan buildEmojiRichText(String data, TextStyle textStyle,
      {SpecialTextGestureTapCallback? onTap}) {
    final List<InlineSpan> inlineList = <InlineSpan>[];
    SpecialText? specialText;
    String textStack = '';
    //String text
    for (int i = 0; i < data.length; i++) {
      final String char = data[i];
      textStack += char;
      if (specialText != null) {
        // always append
        // and remove endflag in getContent method
        specialText.appendContent(char);
        if (specialText.isEnd(textStack)) {
          inlineList.add(specialText.finishText());
          specialText = null;
          textStack = '';
        }
      } else {
        specialText = createSpecialText(textStack,
            textStyle: textStyle, onTap: onTap, index: i);
        if (specialText != null) {
          if (textStack.length - specialText.startFlag.length >= 0) {
            textStack = textStack.substring(
                0, textStack.length - specialText.startFlag.length);
            if (textStack.isNotEmpty) {
              inlineList.add(TextSpan(text: textStack, style: textStyle));
            }
          }
          textStack = '';
        }
      }
    }

    if (specialText != null) {
      inlineList.add(TextSpan(
          text: specialText.startFlag + specialText.getContent(),
          style: textStyle));
    } else if (textStack.isNotEmpty) {
      inlineList.add(TextSpan(text: textStack, style: textStyle));
    }
    return TextSpan(children: inlineList, style: textStyle);
  }

  SpecialText? createSpecialText(String? flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == null || flag == "") return null;
    // TODO: implement createSpecialText

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle!, start: index! - (EmojiText.flag.length - 1));
    }
    return null;
  }

  bool isStart(String value, String startFlag) {
    return value.endsWith(startFlag);
  }

  ///检测是否含有表情
  _isEmoji(text) {
    String regex = "\\[(\\S+?)\\]"; //表示[多个非空字符]？尽量少的包含，然后生成组
    if (RegExp(regex).firstMatch(text) != null) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off(EventCode.MSG_CHAT_NEW);
  }
}

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  /// whether show background for @somebody
  final bool showAtBackground;
  final BuilderType type;

  MySpecialTextSpanBuilder(
      {this.showAtBackground = false, this.type = BuilderType.extendedText});

  @override
  TextSpan build(String? data, {TextStyle? textStyle, onTap}) {
    // TODO: implement build
    var textSpan = super.build(data!, textStyle: textStyle, onTap: onTap);
    //for performance, make sure your all SpecialTextSpan are only in textSpan.children
    //extended_text_field will only check SpecialTextSpan in textSpan.children
    return textSpan;
  }

  @override
  SpecialText? createSpecialText(String? flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == null || flag == "") return null;
    // TODO: implement createSpecialText

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, AtText.flag)) {
      return AtText(textStyle!, onTap!,
          start: index! - (AtText.flag.length - 1),
          showAtBackground: showAtBackground,
          type: type);
    } else if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle!, start: index! - (EmojiText.flag.length - 1));
    }
    return null;
  }
}

enum BuilderType { extendedText, extendedTextField }

class AtText extends SpecialText {
  static const String flag = "@";
  final int? start;

  /// whether show background for @somebody
  final bool? showAtBackground;

  final BuilderType? type;

  AtText(TextStyle textStyle, SpecialTextGestureTapCallback onTap,
      {this.showAtBackground = false, this.type, this.start})
      : super(flag, " ", textStyle, onTap: onTap);

  @override
  TextSpan finishText() {
    TextStyle? textStyle =
        this.textStyle!.copyWith(color: BaseColors.c2872fc, fontSize: 16.0);

    final String atText = toString();

    if (type == BuilderType.extendedText)
      return TextSpan(
          text: atText,
          style: textStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (onTap != null) onTap!(atText);
            });

    return showAtBackground!
        ? BackgroundTextSpan(
            background: Paint()..color = BaseColors.c2872fc.withOpacity(0.15),
            text: atText,
            actualText: atText,
            start: start!,
            deleteAll: false,
            style: textStyle,
            recognizer: type == BuilderType.extendedText
                ? (TapGestureRecognizer()
                  ..onTap = () {
                    if (onTap != null) onTap!(atText);
                  })
                : null)
        : SpecialTextSpan(
            text: atText,
            actualText: atText,
            start: start!,
            deleteAll: false,
            style: textStyle,
            recognizer: type == BuilderType.extendedText
                ? (TapGestureRecognizer()
                  ..onTap = () {
                    if (onTap != null) onTap!(atText);
                  })
                : null);
  }
}

class EmojiText extends SpecialText {
  static const String flag = "[";
  final int? start;

  EmojiText(TextStyle textStyle, {this.start})
      : super(EmojiText.flag, "]", textStyle);

  @override
  InlineSpan finishText() {
    // TODO: implement finishText
    var key = toString();
    if (EmojiUtil.instance.emojiMap.containsKey(key)) {
      //fontsize id define image height
      //size = 30.0/26.0 * fontSize
      final double size = 20.0;

      ///fontSize 26 and text height =30.0
      //final double fontSize = 26.0;

      return ImageSpan(AssetImage(EmojiUtil.instance.emojiMap[key]!),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start!,
          fit: BoxFit.fill,
          margin: EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class ChatBottomView extends StatefulWidget {
  final userID;
  final sendCallBack;

  ChatBottomView({this.userID, this.sendCallBack});

  @override
  _ChatBottomViewState createState() => _ChatBottomViewState();
}

class _ChatBottomViewState extends State<ChatBottomView> {
  TextEditingController messageController = TextEditingController(text: '');
  FocusNode _focusNode = FocusNode();

  String? inputTextValue = '';
  bool showImageView = false;
  bool showEmojiView = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          showImageView = false;
          showEmojiView = false;
          setState(() {});
        }
      });
      FocusScope.of(context).requestFocus(_focusNode);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        _bottomView(),
        Stack(children: [
          if (showImageView) _bottomImageView(),
          if (showEmojiView) _bottomEmojiView()
        ])
      ]);

  Widget _bottomView() => Container(
        color:
            BaseUIUtil().isThemeDark() ? BaseColors.c393939 : BaseColors.f5f5f5,
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Expanded(
                child: ExtendedTextField(
              decoration: InputDecoration(
                  isDense: true, filled: true, fillColor: Colors.white),
              focusNode: _focusNode,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: messageController,
              onChanged: (value) {
                inputTextValue = value;
                setState(() {});
              },
              specialTextSpanBuilder: MySpecialTextSpanBuilder(
                  showAtBackground: false, type: BuilderType.extendedTextField),
            )),
            BaseGaps().hGap10,
            InkWell(
              onTap: () {
                showImageView = false;
                showEmojiView = !showEmojiView;
                FocusScope.of(context).requestFocus(FocusNode());
                Future.delayed(Duration(milliseconds: 100), () {
                  setState(() {});
                });
              },
              child: Icon(Icons.keyboard_alt_outlined,
                  size: 30.h, color: BaseColors.a4a4a4),
            ),
            BaseGaps().hGap5,
            Container(
              child: Stack(children: <Widget>[
                if (!(inputTextValue == null || inputTextValue!.isEmpty))
                  BaseWidgetUtil.getButtonSized(
                      text: '发送',
                      textStyle: TextStyle(
                          fontSize: 14.sp,
                          color: BaseColors.ffffff,
                          fontWeight: BaseDimens.fw_m),
                      height: 30.h,
                      width: 40.w,
                      color: BaseColors.c34cc00,
                      onTap: () => _sendTextMessage()),
                if (inputTextValue == null || inputTextValue!.isEmpty)
                  InkWell(
                    onTap: () {
                      showImageView = !showImageView;
                      if (showImageView) {
                        showEmojiView = false;
                        FocusScope.of(context).requestFocus(FocusNode());
                      } else {
                        showEmojiView = true;
                      }

                      Future.delayed(Duration(milliseconds: 200), () {
                        setState(() {});
                      });
                    },
                    child: Icon(Icons.add_circle_outline,
                        size: 30.h, color: BaseColors.a4a4a4),
                  ),
              ]),
            )
          ],
        ),
      );

  _bottomEmojiView() => EmojiUtil.emoJiList(context, onTap: (expression, path) {
        inputTextValue = messageController.value.text;
        int? length = inputTextValue?.length;
        int? cursorIndex = messageController.selection.baseOffset;
        int? newOffset = length;
        //表情字符
        if (cursorIndex == -1 || length == cursorIndex) {
          inputTextValue = '$inputTextValue[$expression]';
          newOffset = inputTextValue?.length;
        } else {
          String startSubStr = inputTextValue?.substring(0, cursorIndex) ?? '';
          String endSubStr =
              inputTextValue?.substring(cursorIndex, length) ?? '';
          inputTextValue = startSubStr + '[$expression]' + endSubStr;
          newOffset = startSubStr.length + '[$expression]'.length;
        }

        messageController.value = TextEditingValue(text: inputTextValue ?? '');
        messageController.selection = TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: newOffset ?? 0));
        setState(() {});
      });

  _bottomImageView() => Container(
        color:
            BaseUIUtil().isThemeDark() ? BaseColors.c393939 : BaseColors.f5f5f5,
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            BaseWidgetUtil.getTextWithIconV("图片",
                icon: Icons.image,
                textStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
                iconColor:
                    BaseUIUtil().getTheme().textTheme.titleMedium!.color!,
                onTap: () async => _sendImage(false)),
            BaseWidgetUtil.getTextWithIconV("拍摄",
                icon: Icons.camera_alt_outlined,
                textStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
                iconColor:
                    BaseUIUtil().getTheme().textTheme.titleMedium!.color!,
                onTap: () async => _sendImage(true)),
          ],
        ),
      );

  void _sendImage(bool isCamera) async {
    XFile? file = await BaseImageUtil().gotoPickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (file != null) {
      CommonIMUtil()
          .sendImageMessage(receiver: widget.userID, imagePath: file.path)
          .then((value) {
        widget.sendCallBack();
      });
    }
  }

  _sendTextMessage() async {
    if (inputTextValue == null || inputTextValue!.isEmpty) {
      BaseWidgetUtil.showToast('发送内容不能为空');
      return;
    }
    CommonIMUtil()
        .sendC2CTextMessage(text: inputTextValue, userID: widget.userID)
        .then((message) {
      var s = message;
      BaseLogUtil().d(message.desc.toString());
    });
    setState(() {
      //清空对话框
      inputTextValue = '';
      messageController.value = TextEditingValue(text: inputTextValue ?? '');
      widget.sendCallBack();
    });
  }
}
