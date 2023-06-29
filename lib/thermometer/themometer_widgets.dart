import 'package:flutter/material.dart';
import 'package:thermometer/thermometer/slider/thermometer_slider.dart';

class ThermometerSlider extends StatefulWidget {
  // Callback to notify parent of value change.
  final Function(double) onValueChanged;

  const ThermometerSlider(this.onValueChanged, {super.key});

  @override
  State<ThermometerSlider> createState() => _ThermometerSliderState();
}

class _ThermometerSliderState extends State<ThermometerSlider> {
  double _temp = 0.0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: MediaQuery.of(context).size.height,
          trackShape: ThermometerSliderTrackShape(_temp.toInt()),
          showValueIndicator: ShowValueIndicator.never,
          valueIndicatorColor: Colors.blue,
          thumbShape: const ThermometerThumbShape(),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
        ),
        child: Slider(
            label: _temp.toString(),
            thumbColor: Colors.transparent,
            value: _temp,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (value) => setState(() {
                  _temp = value;
                  widget.onValueChanged(value);
                })));
  }
}
