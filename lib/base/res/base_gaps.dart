import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseGaps {
  BaseGaps._internal();

  factory BaseGaps() => _instance;

  static late final BaseGaps _instance = BaseGaps._internal();

  static const Widget empty = SizedBox.shrink();

  Widget vGap10D = SizedBox(width: 10);

  //
  Widget hGap3 = SizedBox(width: 3.w);
  Widget hGap5 = SizedBox(width: 5.w);
  Widget hGap10 = SizedBox(width: 10.w);
  Widget hGap12 = SizedBox(width: 12.w);
  Widget hGap15 = SizedBox(width: 15.w);
  Widget hGap20 = SizedBox(width: 20.w);
  Widget hGap25 = SizedBox(width: 25.w);
  Widget hGap30 = SizedBox(width: 30.w);
  Widget hGap35 = SizedBox(width: 35.w);
  Widget hGap40 = SizedBox(width: 40.w);

  //
  Widget vGap2 = SizedBox(height: 2.h);
  Widget vGap3 = SizedBox(height: 3.h);
  Widget vGap4 = SizedBox(height: 4.h);
  Widget vGap5 = SizedBox(height: 5.h);
  Widget vGap8 = SizedBox(height: 8.h);
  Widget vGap10 = SizedBox(height: 10.h);
  Widget vGap15 = SizedBox(height: 15.h);
  Widget vGap20 = SizedBox(height: 20.h);
  Widget vGap25 = SizedBox(height: 25.h);
  Widget vGap30 = SizedBox(height: 30.h);
  Widget vGap40 = SizedBox(height: 40.h);
  Widget vGap50 = SizedBox(height: 50.h);
}
