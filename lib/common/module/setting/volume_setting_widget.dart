import 'package:djqs/base/res/base_colors.dart';
import 'package:djqs/base/res/base_gaps.dart';
import 'package:djqs/base/ui/base_ui_util.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeSettingWidget extends StatefulWidget {
  TextStyle? titleTextStyle;

  VolumeSettingWidget({this.titleTextStyle});

  @override
  _VolumeSettingWidgetState createState() => _VolumeSettingWidgetState();
}

class _VolumeSettingWidgetState extends State<VolumeSettingWidget> {
  double soundVolume = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    var value = await VolumeController.instance.getVolume();
    setState(() {
      soundVolume = value;
    });
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        BaseGaps().vGap10,
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('铃声提醒音量',
              style: widget.titleTextStyle ??
                  BaseUIUtil().getTheme().primaryTextTheme.titleSmall),
          Text('音量过小可能会影响接单',
              style: TextStyle(
                  fontSize: BaseUIUtil()
                      .getTheme()
                      .primaryTextTheme
                      .titleSmall!
                      .fontSize,
                  color: BaseColors.f29b2d))
        ]),
        BaseGaps().vGap10,
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            // trackShape: CustomTrackShape(),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
              value: soundVolume,
              activeColor: BaseColors.f29b2d,
              inactiveColor: BaseColors.ffdbde,
              thumbColor: BaseColors.ffffff,
              min: 0.0,
              max: 1.0,
              divisions: 100,
              onChanged: btn_onChange),
        )
      ]);

  void btn_onChange(double value) async {
    await VolumeController.instance.setVolume(value);
    setState(() {
      soundVolume = value;
    });
  }
}

class CustomTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      Offset? secondaryOffset,
      bool? isEnabled,
      bool? isDiscrete,
      required TextDirection textDirection}) {
    // TODO: implement paint
  }
}
