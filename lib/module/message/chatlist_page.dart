import 'package:djqs/base/frame/base_pagestate.dart';
import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/ui/base_widget.dart';
import 'package:djqs/module/message/vm/chatlist_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends BasePageState<ChatListPage, ChatListVM> {
  @override
  Widget build(BuildContext context) => buildViewModel<ChatListVM>(
      appBar: BaseWidgetUtil.getAppbar(context, '消息'),
      create: (context) => ChatListVM(context),
      viewBuild: (context, vm) => _body());

  Widget _body() => (vm.conversationList?.length ?? 0) == 0
      ? emptyView(text: '暂无消息')
      : ListView.builder(
          shrinkWrap: true,
          itemCount: vm.conversationList!.length,
          itemBuilder: (context, index) {
            V2TimConversation? entity = vm.conversationList![index];
            return BaseWidgetUtil.getHorizontalListItem(
                index,
                NormalListItem(
                    primary: entity?.showName ?? '',
                    prefixChild: BaseWidgetUtil.getButtonCircleWithBorder(
                        url: entity?.faceUrl, size: 35.h),
                    primaryStyle:
                        BaseUIUtil().getTheme().primaryTextTheme.displayMedium,
                    minor: '[消息]',
                    minorStyle:
                        BaseUIUtil().getTheme().primaryTextTheme.bodySmall,
                    suffixChild: (entity?.unreadCount ?? 0) == 0
                        ? null
                        : BaseWidgetUtil.getContainerSized(
                            width: 20.r,
                            height: 20.r,
                            text: entity!.unreadCount!.toString(),
                            textStyle: TextStyle(
                                color: BaseColors.ffffff, fontSize: 12.sp),
                            color:
                                BaseUIUtil().getTheme().primaryIconTheme.color,
                            circular: 10.r),
                    rightType: ItemType.WIDGET),
                itemVPadding: 8.h,
                itemHPadding: 15.w,
                onItemClick: () => vm.btn_onItemClick(entity),
                showDivider:
                    (index == vm.conversationList!.length - 1 ? false : true),
                divider: Divider());
          });
}
