part of thermometerslider;

class ThermometerThumbShape extends RoundSliderThumbShape {
  final _indicatorShape = const RectangularSliderValueIndicatorShape();

  const ThermometerThumbShape();

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      sliderTheme: sliderTheme,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      textDirection: textDirection,
    );

    final style = TextSpan(
      text: (value * 10).toInt().toString(),
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'SliderFont',
      ),
    );

    final painter = RotatedTextPainter(text: style);
    painter.layout();

    _indicatorShape.paint(
      context,
      center,
      activationAnimation: const AlwaysStoppedAnimation(1),
      enableAnimation: enableAnimation,
      labelPainter: painter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
    );
  }
}

class RotatedTextPainter extends TextPainter {
  @override
  final TextSpan text;

  RotatedTextPainter({required this.text})
      : super(
          text: text,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

  @override
  void paint(Canvas canvas, Offset offset) {
    layout();
    final textWidth = width;
    final textHeight = height;

    canvas.save();
    canvas.translate(offset.dx + textWidth / 2, offset.dy + textHeight / 2);
    canvas.rotate(math.pi / 2); // Rotating 90 degrees counter-clockwise

    super.paint(canvas, Offset(-textWidth / 2, -textHeight / 2));
    canvas.restore();
  }
}
