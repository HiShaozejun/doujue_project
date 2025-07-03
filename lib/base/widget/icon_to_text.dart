import 'package:djqs/base/res/base_colors.dart';
import 'package:flutter/material.dart';

/// 把IconData转换为文字，使其可以使用文字样式
class IconToText extends StatelessWidget {
  final IconData? icon;
  final TextStyle? style;
  final double? size;
  final Color? color;

  const IconToText(
    this.icon, {
    Key? key,
    this.style,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        String.fromCharCode(icon!.codePoint),
        style: style ??
            TextStyle(
              fontFamily: 'MaterialIcons',
              fontSize: size ?? 30,
              inherit: true,
              color: color ?? BaseColors.ffffff,
            ),
      );
}
