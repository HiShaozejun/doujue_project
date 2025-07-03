import 'dart:math';

import 'package:flutter/material.dart';

enum BubbleArrowDirection { top, bottom, right, left, topLeft }

class BubbleWidget extends StatefulWidget {
// 尖角位置
  final position;

  // 尖角高度
  var arrHeight;

  // 尖角角度
  var arrAngle;

  // 圆角半径
  var radius;

  // 宽度
  final width;

  // 高度
  var height;

  // 边距
  double length;

  // 颜色
  Color? color;

  // 边框颜色
  Color? borderColor;

  // 边框宽度
  final strokeWidth;

  // 填充样式
  final style;

  // 子 Widget
  final Widget? child;

  // 子 Widget 与起泡间距
  var innerPaddingV;
  var innerPaddingH;

  BubbleWidget(
      {Key? key,
      this.width = 300.0,
      this.height = 90.0,
      this.color,
      this.position,
      this.length = 1,
      this.arrHeight = 12.0,
      this.arrAngle = 60.0,
      this.radius = 10.0,
      this.strokeWidth = 4.0,
      this.style = PaintingStyle.fill,
      this.borderColor,
      this.child,
      this.innerPaddingV = 10.0,
      this.innerPaddingH = 10.0})
      : super(key: key);

  @override
  _BubbleWidgetState createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  @override
  Widget build(BuildContext context) {
    ///获取子控件的高度
    return Container(
      child: CustomPaint(
        painter: BubbleCanvas(
            context,
            widget.color,
            widget.position,
            widget.arrHeight,
            widget.arrAngle,
            widget.radius,
            widget.strokeWidth,
            widget.style,
            widget.length),
        child: _paddingWidget(),
      ),
    );
  }

  Widget _paddingWidget() {
    return Padding(
        padding: EdgeInsets.only(
            top: (widget.position == BubbleArrowDirection.top)
                ? widget.arrHeight + widget.innerPaddingV
                : widget.innerPaddingV,
            right: (widget.position == BubbleArrowDirection.right)
                ? widget.arrHeight + widget.innerPaddingH
                : widget.innerPaddingH,
            bottom: (widget.position == BubbleArrowDirection.bottom)
                ? widget.arrHeight + widget.innerPaddingV
                : widget.innerPaddingV,
            left: (widget.position == BubbleArrowDirection.left)
                ? widget.arrHeight + widget.innerPaddingH
                : widget.innerPaddingH),
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 270.0,
                ),
                child: widget.child)));
  }
}

class BubbleCanvas extends CustomPainter {
  BuildContext context;
  final position;
  final arrHeight;
  final arrAngle;
  final radius;
  var width;
  var height;
  final length;
  final color;
  final strokeWidth;
  final style;

  BubbleCanvas(this.context, this.color, this.position, this.arrHeight,
      this.arrAngle, this.radius, this.strokeWidth, this.style, this.length);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    Path path = Path();
    path.arcTo(
        Rect.fromCircle(
            center: Offset(
                (position == BubbleArrowDirection.left)
                    ? radius + arrHeight
                    : radius,
                (position == BubbleArrowDirection.top)
                    ? radius + arrHeight
                    : radius),
            radius: radius),
        pi,
        pi * 0.5,
        false);
    if (position == BubbleArrowDirection.top) {
      path.lineTo(length + radius, arrHeight);
      path.lineTo(
          length + radius + arrHeight * tan(_angle(arrAngle * 0.5)), 0.0);
      path.lineTo(length + radius + arrHeight * tan(_angle(arrAngle * 0.5)) * 2,
          arrHeight);
    }
    path.lineTo(
        (position == BubbleArrowDirection.right)
            ? width - radius - arrHeight
            : width - radius,
        (position == BubbleArrowDirection.top) ? arrHeight : 0.0);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(
                (position == BubbleArrowDirection.right)
                    ? width - radius - arrHeight
                    : width - radius,
                (position == BubbleArrowDirection.top)
                    ? radius + arrHeight
                    : radius),
            radius: radius),
        -pi * 0.5,
        pi * 0.5,
        false);
    if (position == BubbleArrowDirection.right) {
      path.lineTo(width - arrHeight, length + radius);
      path.lineTo(
          width, length + radius + arrHeight * tan(_angle(arrAngle * 0.5)));
      path.lineTo(width - arrHeight,
          length + radius + arrHeight * tan(_angle(arrAngle * 0.5)) * 2);
    }
    path.lineTo(
        (position == BubbleArrowDirection.right) ? width - arrHeight : width,
        (position == BubbleArrowDirection.bottom)
            ? height - radius - arrHeight
            : height - radius);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(
                (position == BubbleArrowDirection.right)
                    ? width - radius - arrHeight
                    : width - radius,
                (position == BubbleArrowDirection.bottom)
                    ? height - radius - arrHeight
                    : height - radius),
            radius: radius),
        pi * 0,
        pi * 0.5,
        false);
    if (position == BubbleArrowDirection.bottom) {
      path.lineTo(width - radius - length, height - arrHeight);
      path.lineTo(
          width - radius - length - arrHeight * tan(_angle(arrAngle * 0.5)),
          height);
      path.lineTo(
          width - radius - length - arrHeight * tan(_angle(arrAngle * 0.5)) * 2,
          height - arrHeight);
    }
    path.lineTo(
        (position == BubbleArrowDirection.left) ? radius + arrHeight : radius,
        (position == BubbleArrowDirection.bottom)
            ? height - arrHeight
            : height);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(
                (position == BubbleArrowDirection.left)
                    ? radius + arrHeight
                    : radius,
                (position == BubbleArrowDirection.bottom)
                    ? height - radius - arrHeight
                    : height - radius),
            radius: radius),
        pi * 0.5,
        pi * 0.5,
        false);
    if (position == BubbleArrowDirection.left) {
      path.lineTo(arrHeight, length + radius + arrHeight);
      path.lineTo(0.0, length + arrHeight);
      path.lineTo(arrHeight, radius);
    }
    path.lineTo((position == BubbleArrowDirection.left) ? arrHeight : 0.0,
        (position == BubbleArrowDirection.top) ? radius + arrHeight : radius);
    path.close();
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = style
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

double _angle(angle) {
  return angle * pi / 180;
}
