import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_dimens.dart';
import 'package:flutter/material.dart';

class BaseThemes {
  static ThemeData lightTD = ThemeData(
    primaryColor: BaseColors.ffffff,
    scaffoldBackgroundColor: BaseColors.ffffff,
    shadowColor: BaseColors.trans,
    focusColor: BaseColors.trans,
    highlightColor: BaseColors.trans,
    splashColor: BaseColors.trans,
    hoverColor: BaseColors.trans,
    indicatorColor: BaseColors.e70012,
    dividerColor: BaseColors.dad8d8,
    appBarTheme: AppBarTheme(
        surfaceTintColor: BaseColors.ffffff,
        iconTheme: IconThemeData(color: BaseColors.c161616),
        backgroundColor: BaseColors.ffffff,
        titleTextStyle: TextStyle(color: BaseColors.c161616)),
    dividerTheme:
        DividerThemeData(color: BaseColors.dad8d8, thickness: 1, space: 1),
    primaryTextTheme: TextTheme(
        displayLarge: TextStyle(
            color: BaseColors.c161616,
            fontSize: 17,
            fontWeight: BaseDimens.fw_l_x),
        displayMedium: TextStyle(
            color: BaseColors.c161616,
            fontSize: 15,
            fontWeight: BaseDimens.fw_l),
        displaySmall: TextStyle(color: BaseColors.c161616, fontSize: 13),
        titleLarge: TextStyle(color: BaseColors.c4f4f4f, fontSize: 17),
        titleMedium: TextStyle(color: BaseColors.c4f4f4f, fontSize: 15),
        titleSmall: TextStyle(color: BaseColors.c4f4f4f, fontSize: 13),
        bodyMedium: TextStyle(color: BaseColors.c828282, fontSize: 15),
        bodySmall: TextStyle(color: BaseColors.c828282, fontSize: 13),
        labelLarge: TextStyle(color: BaseColors.a4a4a4, fontSize: 17),
        labelMedium: TextStyle(color: BaseColors.a4a4a4, fontSize: 15),
        labelSmall: TextStyle(color: BaseColors.a4a4a4, fontSize: 13)),
    textTheme: TextTheme(
        titleMedium: TextStyle(color: BaseColors.c4f4f4f, fontSize: 15),
        bodySmall: TextStyle(color: BaseColors.c828282, fontSize: 13),
        bodyMedium: TextStyle(color: BaseColors.c828282, fontSize: 15)),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintStyle: TextStyle(color: BaseColors.c828282, fontSize: 16),
      prefixStyle: TextStyle(color: BaseColors.c4f4f4f, fontSize: 16),
      labelStyle: TextStyle(color: BaseColors.c4f4f4f, fontSize: 16),
      fillColor: BaseColors.ebebeb,
      filled: false,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: BaseColors.ebebeb),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: BaseColors.ebebeb),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: BaseColors.c828282,
        selectionHandleColor: BaseColors.c828282),
    bottomAppBarTheme: BottomAppBarTheme(color: BaseColors.c161616),
    iconTheme: IconThemeData(color: BaseColors.c161616),
    primaryIconTheme: IconThemeData(color: BaseColors.e70012),
    buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(primary: BaseColors.f5f5f5),
        buttonColor: BaseColors.f5f5f5),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: BaseColors.c4f4f4f,
      dividerColor: BaseColors.c4f4f4f,
      dividerHeight: 0,
      labelColor: BaseColors.c4f4f4f,
      unselectedLabelColor: BaseColors.c828282,
      unselectedLabelStyle:
          TextStyle(fontSize: 15, fontWeight: BaseDimens.fw_l),
      labelStyle: TextStyle(fontSize: 15, fontWeight: BaseDimens.fw_l),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      //splashFactory: NoSplashlashFactory, //it's not worked
    ),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: BaseColors.f5f5f5,
        surfaceTintColor: BaseColors.f5f5f5),
    switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return BaseColors.c66dca0;
          return BaseColors.dad8d8;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return BaseColors.b2eed2;
          return BaseColors.ebebeb;
        }),
        trackOutlineColor: MaterialStateProperty.all(BaseColors.dad8d8),
        trackOutlineWidth: MaterialStateProperty.all(3)),
    dialogBackgroundColor: BaseColors.ffffff,
    dialogTheme: DialogTheme(
        backgroundColor: BaseColors.ffffff,
        surfaceTintColor: BaseColors.ffffff,
        shadowColor: BaseColors.ebebeb,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        titleTextStyle: TextStyle(
            color: BaseColors.c161616,
            fontSize: 17,
            fontWeight: BaseDimens.fw_l),
        contentTextStyle: TextStyle(
            color: BaseColors.c4f4f4f,
            fontSize: 15,
            fontWeight: BaseDimens.fw_m),
        iconColor: BaseColors.c828282,
        alignment: Alignment.center,
        actionsPadding: EdgeInsets.symmetric(horizontal: 10)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            side: BorderSide.none,
            backgroundColor: BaseColors.trans,
            // surfaceTintColor: BaseColors.c4f4f4f,side: BorderSide(width: 1, color: BaseColors.ebebeb)
            foregroundColor: BaseColors.c4f4f4f)),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: BaseColors.c00a0e7, refreshBackgroundColor: BaseColors.ebebeb),
    cardTheme: CardTheme(
        surfaceTintColor: BaseColors.f5f5f5,
        color: BaseColors.f5f5f5,
        elevation: 5.0,
        margin: EdgeInsets.all(10)),
    useMaterial3: false,
    //
    // primaryColorLight: BaseColors.f5f5f5,
    // primaryColorDark: BaseColors.ffffff,
    // canvasColor: BaseColors.ffffff,
    // secondaryHeaderColor: Colors.green,
    // unselectedWidgetColor: Colors.yellow,
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(),
    // fontFamily: "Avenir"
  );

  static ThemeData darkTD = ThemeData(
    primaryColor: BaseColors.c161616,
    scaffoldBackgroundColor: BaseColors.c161616,
    indicatorColor: BaseColors.ffffff,
    shadowColor: BaseColors.trans,
    splashColor: BaseColors.trans,
    highlightColor: BaseColors.trans,
    focusColor: BaseColors.trans,
    hoverColor: BaseColors.trans,
    dividerColor: BaseColors.c4f4f4f,
    appBarTheme: AppBarTheme(
        surfaceTintColor: BaseColors.c161616,
        iconTheme: IconThemeData(color: BaseColors.ffffff),
        backgroundColor: BaseColors.c161616,
        titleTextStyle: TextStyle(color: BaseColors.ffffff)),
    dividerTheme:
        DividerThemeData(color: BaseColors.c4f4f4f, thickness: 1, space: 1),
    primaryTextTheme: TextTheme(
        displayLarge: TextStyle(
            color: BaseColors.ffffff,
            fontSize: 20,
            fontWeight: BaseDimens.fw_l_x),
        displayMedium: TextStyle(
            color: BaseColors.ffffff,
            fontSize: 15,
            fontWeight: BaseDimens.fw_l),
        displaySmall: TextStyle(color: BaseColors.ffffff, fontSize: 13),
        titleLarge: TextStyle(color: BaseColors.ffffff, fontSize: 17),
        titleMedium: TextStyle(color: BaseColors.c606069, fontSize: 15),
        titleSmall: TextStyle(color: BaseColors.ffffff, fontSize: 13),
        bodyMedium: TextStyle(color: BaseColors.ffffff, fontSize: 15),
        bodySmall: TextStyle(color: BaseColors.bfbfbf, fontSize: 13),
        labelLarge: TextStyle(color: BaseColors.ffffff, fontSize: 17),
        labelMedium: TextStyle(color: BaseColors.ffffff, fontSize: 15),
        labelSmall: TextStyle(color: BaseColors.ffffff, fontSize: 13)),
    textTheme: TextTheme(
        titleMedium: TextStyle(color: BaseColors.ffffff, fontSize: 15),
        bodyMedium: TextStyle(color: BaseColors.c606069, fontSize: 15),
        bodySmall: TextStyle(color: BaseColors.ffffff, fontSize: 13)),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: TextStyle(color: BaseColors.ffffff, fontSize: 16),
        prefixStyle: TextStyle(color: BaseColors.ffffff, fontSize: 16),
        labelStyle: TextStyle(color: BaseColors.ffffff, fontSize: 16),
        fillColor: BaseColors.ffffff,
        filled: false,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: BaseColors.ffffff)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: BaseColors.ffffff))),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: BaseColors.ffffff,
        selectionHandleColor: BaseColors.ffffff),
    bottomAppBarTheme: BottomAppBarTheme(color: BaseColors.c4f4f4f),
    iconTheme: IconThemeData(color: BaseColors.ffffff),
    primaryIconTheme: IconThemeData(color: BaseColors.fc3e5a),
    buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.dark(primary: BaseColors.c393939),
        buttonColor: BaseColors.c393939),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: BaseColors.ffe159,
      dividerColor: BaseColors.c393939,
      dividerHeight: 0,
      labelColor: BaseColors.ffffff,
      unselectedLabelColor: BaseColors.c828282,
      unselectedLabelStyle:
          TextStyle(fontSize: 15, fontWeight: BaseDimens.fw_l),
      labelStyle: TextStyle(fontSize: 15, fontWeight: BaseDimens.fw_l),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      //splashFactory: NoSplashlashFactory, //it's not worked
    ),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: BaseColors.c262626,
        surfaceTintColor: BaseColors.c262626),
    switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return BaseColors.c7cdba3;
          return BaseColors.dad8d8;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return BaseColors.c518465;
          return BaseColors.c606069;
        }),
        trackOutlineColor: MaterialStateProperty.all(BaseColors.c747474),
        trackOutlineWidth: MaterialStateProperty.all(3)),
    dialogBackgroundColor: BaseColors.c262626,
    dialogTheme: DialogTheme(
        backgroundColor: BaseColors.c262626,
        surfaceTintColor: BaseColors.c262626,
        shadowColor: BaseColors.c393939,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        titleTextStyle: TextStyle(
            color: BaseColors.ffffff,
            fontSize: 17,
            fontWeight: BaseDimens.fw_l),
        contentTextStyle: TextStyle(
            color: BaseColors.ffffff,
            fontSize: 15,
            fontWeight: BaseDimens.fw_m),
        iconColor: BaseColors.c828282,
        alignment: Alignment.center,
        actionsPadding: EdgeInsets.symmetric(horizontal: 10)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            side: BorderSide.none,
            backgroundColor: BaseColors.trans,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: 15, color: BaseColors.e70012),
            foregroundColor: BaseColors.ffffff)),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: BaseColors.ffffff, refreshBackgroundColor: BaseColors.ffffff),
    cardTheme: CardTheme(
        surfaceTintColor: BaseColors.c393939,
        color: BaseColors.c393939,
        elevation: 5.0,
        margin: EdgeInsets.all(10)),
  );
}
