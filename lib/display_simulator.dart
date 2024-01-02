import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'display_painter.dart';
import 'to_pixels_converter.dart';

const canvasSize = 200.0;

enum ShapeType {
  rectangle,
  circle,
  star,
  heart,
}

class DisplaySimulator extends StatefulWidget {
  const DisplaySimulator({
    super.key,
    required this.text,
    this.border = false,
    this.debug = false,
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
    this.scale = 1,
    this.shapeType = ShapeType.rectangle,
  });

  final String text;
  final bool border;
  final bool debug;
  final Color backgroundColor;
  final Color textColor;
  final double scale;
  final ShapeType shapeType;
  final TextStyle textStyle;

  @override
  _DisplaySimulatorState createState() => _DisplaySimulatorState();
}

class _DisplaySimulatorState extends State<DisplaySimulator> {
  ByteData? imageBytes;
  List<List<Color>>? pixels;

  @override
  Widget build(BuildContext context) {
    _obtainPixelsFromText(widget.text);

    return _getDisplay();
  }


  Widget _getDisplay() {
    if (pixels == null) {
      return Container();
    }

    return CustomPaint(
        size: Size.infinite,
        painter: DisplayPainter(
            pixels: pixels!,
            backgroundColor: widget.backgroundColor,
            type: widget.shapeType,
            gradient: [Colors.white, Colors.red]));
  }

  void _obtainPixelsFromText(String text) async {
    ToPixelsConversionResult result = await ToPixelsConverter.fromString(
      string: text,
      textStyle: widget.textStyle,
      border: widget.border,
      canvasSize: canvasSize / widget.scale,
      textColor: widget.textColor,
    ).convert();

    setState(() {
      imageBytes = result.imageBytes;
      pixels = result.pixels;
    });
  }
}
