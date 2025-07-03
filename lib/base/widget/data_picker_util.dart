import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:djqs/base/util/util_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef DateClickCallback = void Function(
    dynamic selectDateStr, dynamic selectDate,
    {DateTime dateTime, String formatDate});

enum DateType {
  YMD, // y, m, d
  YM, // y ,m
  YMD_HM, // y, m, d, hh, mm
  YMD_AP_HM, // y, m, d, ap, hh, mm
  Y,
}

class BaseDatePickerUtil {
  static void showStringPicker<T>(
    BuildContext context, {
    @required List<T>? data,
    String? title,
    int? normalIndex,
    PickerDataAdapter? adapter,
    @required Function(int selectIndex, Object selectStr)? clickCallBack,
  }) =>
      openModalPicker(context,
          adapter:
              adapter ?? PickerDataAdapter(pickerData: data, isArray: false),
          clickCallBack: (Picker picker, List<int> selecteds) {
        clickCallBack?.call(selecteds[0], data![selecteds[0]]!);
      }, selecteds: [normalIndex ?? 0], title: title);

  static void showArrayPicker<T>(
    BuildContext context, {
    @required List<T>? data,
    String? title,
    List<int>? normalIndex,
    PickerDataAdapter? adapter,
    @required
    Function(List<int> selecteds, List<dynamic> strData)? clickCallBack,
  }) =>
      openModalPicker(context,
          adapter:
              adapter ?? PickerDataAdapter(pickerData: data, isArray: true),
          clickCallBack: (Picker picker, List<int> selecteds) {
        clickCallBack?.call(selecteds, picker.getSelectedValues());
      }, selecteds: normalIndex, title: title);

  static void showDatePicker(BuildContext context,
      {DateType? dateType = DateType.YM,
      String? title,
      DateTime? maxValue,
      DateTime? minValue,
      DateTime? value,
      DateTimePickerAdapter? adapter,
      @required DateClickCallback? clickCallback}) {
    int timeType;
    if (dateType == DateType.YM)
      timeType = PickerDateTimeType.kYM;
    else if (dateType == DateType.Y)
      timeType = PickerDateTimeType.kY;
    else if (dateType == DateType.YMD_HM)
      timeType = PickerDateTimeType.kYMDHM;
    else if (dateType == DateType.YMD_AP_HM)
      timeType = PickerDateTimeType.kYMD_AP_HM;
    else
      timeType = PickerDateTimeType.kYMD;

    openModalPicker(context,
        adapter: adapter ??
            DateTimePickerAdapter(
              type: timeType,
              isNumberMonth: true,
              yearSuffix: "年",
              monthSuffix: "月",
              daySuffix: "日",
              strAMPM: const ["上午", "下午"],
              maxValue: maxValue,
              minValue: minValue,
              value: value ?? DateTime.now(),
            ),
        title: title, clickCallBack: (Picker picker, List<int> selecteds) {
      var time = (picker.adapter as DateTimePickerAdapter).value;
      var timeStr;
      if (dateType == DateType.YM)
        timeStr = time!.year.toString() + "年" + time.month.toString() + "月";
      else if (dateType == DateType.Y)
        timeStr = time!.year.toString();
      else if (dateType == DateType.YMD_HM)
        timeStr = time!.year.toString() +
            "年" +
            time.month.toString() +
            "月" +
            time.day.toString() +
            "日" +
            time.hour.toString() +
            "时" +
            time.minute.toString() +
            "分";
      else if (dateType == DateType.YMD_AP_HM)
        timeStr = time!.year.toString() +
            "年" +
            time.month.toString() +
            "月" +
            time.day.toString() +
            "日" +
            "上午" +
            time.hour.toString() +
            "时" +
            time.minute.toString() +
            "分";
      else
        timeStr = time!.year.toString() +
            "-" +
            time.month.toString() +
            "-" +
            time.day.toString();

      clickCallback?.call(timeStr, picker.adapter.text,
          dateTime: time,
          formatDate: BaseDateUtil.formatDateTime(time.toString(),
              format: BaseDateType.NORMAL));
    });
  }

  static void openModalPicker(
    BuildContext context, {
    @required PickerAdapter? adapter,
    String? title,
    List<int>? selecteds,
    @required PickerConfirmCallback? clickCallBack,
  }) =>
      Picker(
              adapter: adapter!,
              selecteds: selecteds,
              title: Text(title ?? "选择日期",
                  style:
                      BaseUIUtil().getTheme().primaryTextTheme.displayMedium),
              backgroundColor:
                  BaseUIUtil().getTheme().bottomSheetTheme.backgroundColor,
              headerColor:
                  BaseUIUtil().getTheme().bottomSheetTheme.backgroundColor,
              textStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
              selectedTextStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
              cancelTextStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
              confirmTextStyle: BaseUIUtil().getTheme().textTheme.titleMedium,
              cancelText: '取消',
              confirmText: '确定',
              textAlign: TextAlign.right,
              itemExtent: 40,
              height: 150.h,
              onConfirm: clickCallBack)
          .showModal(context);
}
