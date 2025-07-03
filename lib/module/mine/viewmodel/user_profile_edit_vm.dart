import 'package:djqs/base/frame/base_notifier.dart';
import 'package:djqs/base/util/util_image.dart';
import 'package:djqs/base/util/util_object.dart';
import 'package:djqs/module/mine/entity/user_profile_entity.dart';
import 'package:djqs/module/mine/util/mine_service.dart';
import 'package:flutter/material.dart';

class UserProfileEditVM extends BaseNotifier {
  late final _service = MineService();
  late final textController = TextEditingController();

  UserProfileEntity? profileEntity;

  UserProfileEditVM(super.context);

  @override
  void init() => refreshData();

  void refreshData() async {
    profileEntity = await _service.getUserProfile();
    textController.text = profileEntity?.nickname ?? '';
    notifyListeners();
  }

  void btn_onAvatar() => BaseImageUtil().showImagePickerDialog(baseContext!,
          callback: (String? url) {
        _dealWithAvatar(url);
      });

  void btn_onSave() async {
    if (ObjectUtil.isEmptyStr(textController.text)) {
      toast('昵称不能为空');
      return;
    }
    profileEntity?.nickname = textController.text;
    bool? result = await _service.updateUserProfile(profileEntity!);
    if (result == true) {
      toast('修改成功');
      pagePop();
    } else
      toast('修改失败');
  }

  void _dealWithAvatar(String? url) {
    if (ObjectUtil.isEmptyStr(url)) {
      toast('头像更新失败');
      return;
    }

    //profileEntity?.avatar = AppUtil().avatarToJson(url!);
    notifyListeners();
  }

  @override
  void onCleared() {}
}
