import 'dart:math';

import 'package:flutter/cupertino.dart';

class RotateIcon extends StatefulWidget {
  final Widget? child;
  final bool? isDoAnim;
  final RotateWidgetController? rotateWidgetController;

  RotateIcon({Key? key, this.child, this.isDoAnim, this.rotateWidgetController})
      : super(key: key);

  @override
  _RotateIconState createState() => _RotateIconState();
}

class _RotateIconState extends State<RotateIcon> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation rotateAnimation;
  double animationAngle = 0.0;

  @override
  void initState() {
    widget.rotateWidgetController?.addListener(() {
      Future.delayed(Duration(milliseconds: 200), () {
        if (widget.isDoAnim!) {
          if (rotateAnimation.value == pi) {
            controller.reverse();
          } else {
            controller.forward();
          }
        } else {
          if (rotateAnimation.value == pi) {
            controller.reverse();
          }
        }
      });
    });
    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    rotateAnimation = Tween<double>(begin: 0.0, end: pi).animate(controller)
      ..addListener(() {
        setState(() {
          animationAngle = rotateAnimation.value;
        });
      });
    ;

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: animationAngle,
        child: widget.child,
      );

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class RotateWidgetController extends ChangeNotifier {
  void show() {
    notifyListeners();
  }
}
