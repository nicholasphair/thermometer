part of thermometerslider;


/// NB (nphair): Tried to stay close to the steps on the color wheel.
/// https://uxplanet.org/colour-psychology-to-empower-and-inspire-you-3424dae70f2
class ThermometerSliderTrackShape extends SliderTrackShape {
  // TODO (nphair): Parameterize these.
  final double borderThickness = 1.5;
  final Color borderColor = const Color(0xFF232D4B);
  final Color inactiveFillColor = Colors.white;
  final Color activeFillColor = Colors.red;
  final activeFillColorSteps = [
    const Color(0xff015ebb),
    const Color(0xff4bb2e7),
    const Color(0xff78e7e7),
    const Color(0xff009900),
    const Color(0xff66cb01),
    const Color(0xffffff01),
    const Color(0xfffecb00),
    const Color(0xfffe9900),
    const Color(0xffff6600),
    const Color(0xfffe0000),
  ];
  final Color measurementLineColor = const Color(0xFF232D4B);
  final int thermometerSections = 10;

  int maxFillSection = 0;

  ThermometerSliderTrackShape(int maxFillSection) {
    this.maxFillSection = maxFillSection;
  }

  /// The box the slider itself will be placed in by the framework.
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = true,
  }) {
    assert(sliderTheme.overlayShape != null);
    assert(sliderTheme.trackHeight != null);

    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;

    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight = trackLeft + parentBox.size.width - overlayWidth;
    final double trackBottom = trackTop + trackHeight;

    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    var bbox = Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);

    // NB (nphair): There is a more direct way to achieve this rectangle but
    // this will work for now.
    var thermometerBaseRadius = bbox.height / 16;
    return Rect.fromPoints(
        bbox.topLeft.translate(thermometerBaseRadius * 2, 0), bbox.bottomRight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = true,
    required TextDirection textDirection,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    // Border Constants.
    const borderStrokeWidth = 2.0;
    final borderStyle = BorderSide(color: borderColor, width: borderThickness);
    final baseBorderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderStrokeWidth + 1
      ..style = PaintingStyle.stroke;

    // This is the rectangle the slider will be placed on. Our painting must
    // extend below it for the thermometer base.
    final Rect preferredRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    var thermometerBaseRadius = preferredRect.height / 16;

    var paintableRect = Rect.fromPoints(
        preferredRect.topLeft.translate(thermometerBaseRadius * -2, 0),
        preferredRect.bottomRight);

    var trackWidth = paintableRect.width;
    var trackCenterLeft = paintableRect.centerLeft;

    // Thermometer reference points and dimensions.
    var thermometerStemHeight = thermometerBaseRadius / 1.5;
    var thermometerBaseCenter =
        trackCenterLeft.translate(thermometerBaseRadius, 0);
    var thermometerStemOrigin = thermometerBaseCenter.translate(
        thermometerBaseRadius, thermometerStemHeight / -2);
    var thermometerTickWidth =
        (trackWidth - thermometerBaseRadius * 2) / thermometerSections;

    context.canvas.drawCircle(
        thermometerBaseCenter, thermometerBaseRadius, baseBorderPaint);

    // All sections. Start at -1 to overlap the base and the stem for a seamless transition.
    for (var secIndex = -1; secIndex < thermometerSections; secIndex++) {
      var sectionOriginX =
          thermometerStemOrigin.dx + (secIndex * thermometerTickWidth);
      var sectionOriginY = thermometerStemOrigin.dy;

      // The section and its border.
      var section = Rect.fromLTWH(sectionOriginX, sectionOriginY,
          thermometerTickWidth + borderStrokeWidth, thermometerStemHeight);
      // Pull up negative values so the base matches the first section.
      var colorIndex = max(0, secIndex);
      context.canvas.drawRect(section, fillPaintForSection(colorIndex));

      paintBorder(context.canvas, section,
          top: borderStyle, bottom: borderStyle);
    }

    // Final Section.
    var sectionOriginX =
        thermometerStemOrigin.dx + (thermometerSections * thermometerTickWidth);
    var sectionOriginY = thermometerStemOrigin.dy;

    // The section and its border.
    var section = Rect.fromLTWH(sectionOriginX, sectionOriginY,
        thermometerTickWidth, thermometerStemHeight);
    paintBorder(context.canvas, section, left: borderStyle);

    // Fill in the base last to coverup the overlapping section's border.
    context.canvas.drawCircle(
        thermometerBaseCenter, thermometerBaseRadius, fillPaintForSection(0));
  }

  /// Return the paint color for the section. 
  Paint fillPaintForSection(int section) {
    if (section >= maxFillSection) {
      return Paint()..color = inactiveFillColor;
    }

    return Paint()..color = activeFillColorSteps[section];
  }
}
