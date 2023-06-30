import 'package:flutter/material.dart';

import 'package:thermometerslider/thermometer/thermometer.dart';

// Example usage.
void main() async {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Thermometer'),
      ),
      body: const TAppSlider(),
    ),
  ));
}

class TAppSlider extends StatefulWidget {
  const TAppSlider({super.key});

  @override
  State<TAppSlider> createState() => _TAppSliderState();
}

class _TAppSliderState extends State<TAppSlider> {
  String text = "";

  void setText(double value) {
    setState(() {
      text = value.toInt().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: RotatedBox(
                quarterTurns: -1, child: ThermometerSlider(setText))),
        Flexible(child: TText(text)),
      ],
    );
  }
}

class TText extends StatelessWidget {
  final String data;

  const TText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}
