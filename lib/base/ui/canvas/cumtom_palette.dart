import 'dart:math';

import 'package:flutter/material.dart';

class CustomPalette extends StatefulWidget {
  Color? color;
  double size;
  double thumbSize;
  ValueChanged<Color>? onColorChange;
  ValueChanged<Color>? onColorChangeEnd;

  CustomPalette(
      {Key? key,
      this.color,
      this.size = 300,
      this.thumbSize = 25,
      this.onColorChange,
      this.onColorChangeEnd})
      : super(key: key);

  @override
  _CustomPaletteState createState() => _CustomPaletteState();
}

class _CustomPaletteState extends State<CustomPalette> {
  Offset? topPosition;
  Offset? center;
  Offset? position;
  Offset? currentOffset;
  double? radians = 0;
  double? radius;
  double hue = 0;
  Color? color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    radius = widget.size / 2;
    color = Colors.white;
    topPosition = Offset(0, widget.size! / 2);
    center = Offset(widget.size / 2, widget.size / 2);
    position = Offset(widget.size / 2, widget.size / 2);
    currentOffset = Offset(widget.size / 2, widget.size / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.size + 40,
      height: widget.size + 40,
      child: Stack(
        children: [
          Container(
            width: widget.size + 40,
            height: widget.size + 40,
            alignment: Alignment.center,
            child: GestureDetector(
              onPanDown: onPanDown,
              onPanUpdate: onPanUpdate,
              onPanEnd: onPanEnd,
              child: Container(
                alignment: Alignment.center,
                width: widget.size,
                height: widget.size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: pi,
                      child: CustomPaint(
                        painter: CircularColorPainter(
                          color: color!,
                          center: center!,
                          radius: radius!,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: widget.size,
                          height: widget.size,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wb_sunny_sharp,
                                color: Color.fromRGBO(183, 202, 208, 1.0)),
                            Text(
                              'Warm',
                              style: TextStyle(
                                  color: Color.fromRGBO(183, 202, 208, 1.0)),
                            ),
                            Text(
                              'White',
                              style: TextStyle(
                                  color: Color.fromRGBO(183, 202, 208, 1.0)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.brightness_2_sharp,
                                color: Color.fromRGBO(183, 202, 208, 1.0)),
                            Text(
                              'Cool',
                              style: TextStyle(
                                  color: Color.fromRGBO(183, 202, 208, 1.0)),
                            ),
                            Text(
                              'White',
                              style: TextStyle(
                                  color: Color.fromRGBO(183, 202, 208, 1.0)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Thumb(
            // top: 0,
            // left: 0,
            top: currentOffset!.dy + 20,
            left: currentOffset!.dx + 20,
            thumbSize: widget.thumbSize,
            color: color!,
          ),
        ],
      ),
    );
  }

  ///获取象限
  static int getQuadrant(double x, double y, double size) {
    if (x >= size / 2) {
      return y >= size / 2 ? 3 : 4;
    }
    return y >= size / 2 ? 2 : 1;
  }

  onPanDown(DragDownDetails details) {
    change(details);
    widget.onColorChange!(color!);
  }

  onPanUpdate(DragUpdateDetails details) {
    change(details);
    widget.onColorChange!(color!);
  }

  onPanEnd(DragEndDetails details) {
    widget.onColorChangeEnd!(color!);
  }

  change(details) {
    setState(() {
      position = Offset(details.localPosition.dx, details.localPosition.dy);
    });
    double cosA;
    double x = (sqrt(pow((topPosition!.dx - center!.dx), 2) +
        pow((topPosition!.dy - center!.dy), 2)));
    double y = (sqrt(pow((position!.dx - center!.dx), 2) +
        pow((position!.dy - center!.dy), 2)));
    double z = (sqrt(pow((topPosition!.dx - position!.dx), 2) +
        pow((topPosition!.dy - position!.dy), 2)));
    cosA = (x * x + y * y - z * z) / (2 * x * y);
    int quadrant = getQuadrant(position!.dx, position!.dy, center!.dx * 2);
    radians = acos(cosA);
    if (quadrant == 1 || quadrant == 4) {
      radians = acos(cosA);
    } else if (quadrant == 2 || quadrant == 3) {
      radians = 2 * pi - acos(cosA);
    }
    hue = 360 * radians! / (2 * pi);
    // print('radians:${radians} hue:${hue}');
    color = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    if (y <= center!.dx) {
      currentOffset =
          Offset(details.localPosition.dx, details.localPosition.dy);
    } else {
      double dx = position!.dx - center!.dx;
      double dy = position!.dy - center!.dy;
      double distance = sqrt(dx * dx + dy * dy);
      double ratio = radius! / distance;
      currentOffset = Offset(dx * ratio + center!.dx, dy * ratio + center!.dy);
    }
    if (y <= center!.dx / 2) {
      if (position!.dx < widget.size / 2) {
        color = Color.fromRGBO(255, 225, 178, 1.0);
      } else {
        color = Color.fromRGBO(220, 244, 255, 1.0);
      }
    }
  }
}

class CircularColorPainter extends CustomPainter {
  Color color;
  double radius;
  Offset? center;
  List<Color>? colorList;

  CircularColorPainter(
      {this.color = Colors.black, this.center, this.radius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..color = Colors.black;
    Paint _paint2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..color = Colors.black;
    Paint _paint3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;
    Paint _paint4 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0
      ..color = Color.fromRGBO(color.red, color.green, color.blue, 0.3);
    colorList = [
      Color(0xFFFF0000),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
      Color(0xFF00FFFF),
      Color(0xFF0000FF),
      Color(0xFFFF00FF),
      Color(0xFFFF0000),
    ];
    Gradient gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: colorList!.map((e) => e).toList(),
    );
    _paint4..maskFilter = MaskFilter.blur(BlurStyle.outer, 30);
    canvas.drawArc(Rect.fromLTWH(0, 0, radius * 2, radius * 2), -pi / 2, pi * 2,
        false, _paint4);
    var rect = Rect.fromLTWH(0, 0, radius * 2, radius * 2);
    _paint.shader = gradient.createShader(rect);
    canvas.drawCircle(center!, radius, _paint);
    var rect2 = Rect.fromLTWH(radius / 2, radius / 2, radius, radius);
    _paint2.color = Color.fromRGBO(255, 225, 178, 1.0);
    canvas.drawArc(rect2, -pi / 2, pi, true, _paint2);
    _paint2.color = Color.fromRGBO(220, 244, 255, 1.0);
    canvas.drawArc(rect2, pi / 2, pi, true, _paint2);
    canvas.drawCircle(center!, radius / 2, _paint3);
    _paint3.color = Colors.grey;
    canvas.drawLine(Offset(radius, radius / 2),
        Offset(radius, radius + radius / 2), _paint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Thumb extends StatelessWidget {
  const Thumb({
    Key? key,
    @required double? top,
    @required double? thumbSize,
    @required double? left,
    @required Color? color,
  })  : _top = top,
        _Thumbsize = thumbSize,
        _left = left,
        _color = color,
        super(key: key);

  final double? _top;
  final double? _Thumbsize;
  final double? _left;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _top! - _Thumbsize! / 2,
      left: _left! - _Thumbsize! / 2,
      child: GestureDetector(
        child: Container(
          // width: 50.0,
          child: Icon(
            Icons.circle,
            color: _color == null ? Colors.white : _color,
            size: _Thumbsize,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(300),
            boxShadow: [
              BoxShadow(
                blurRadius: 0.1, //阴影范围
                spreadRadius: 0.001, //阴影浓度
                color: Colors.white, //阴影颜色
              ),
            ],
          ),
        ),
      ),
    );
  }
}
