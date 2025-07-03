import 'package:djqs/base/ui/base_widget.dart';
import 'package:flutter/material.dart';

class DebounceGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration interval;

  const DebounceGestureDetector({
    Key? key,
    required this.child,
    required this.onTap,
    this.interval = const Duration(milliseconds: 1000), // 默认1秒防抖
  }) : super(key: key);

  @override
  _DebounceGestureDetectorState createState() => _DebounceGestureDetectorState();
}

class _DebounceGestureDetectorState extends State<DebounceGestureDetector> {
  DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > widget.interval) {
      _lastTapTime = now;
      widget.onTap();
    } else {
      BaseWidgetUtil.showToast('点击太频繁，请稍后再试~');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: widget.child,
    );
  }
}
