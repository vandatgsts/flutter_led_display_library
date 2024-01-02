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

  @override
  _DisplaySimulatorState createState() => _DisplaySimulatorState();
}

class _DisplaySimulatorState extends State<DisplaySimulator> {
  ByteData? imageBytes;
  List<List<Color>>? pixels;

  @override
  Widget build(BuildContext context) {
    _obtainPixelsFromText(widget.text);

    return Column(
      children: <Widget>[
        const SizedBox(
          height: 96,
        ),
        _getDebugPreview(),
        const SizedBox(
          height: 48,
        ),
        _getDisplay(),
        //_getDisplayWithWidgets()
      ],
    );
  }

  Widget _getDebugPreview() {
    if (imageBytes == null || widget.debug == false) {
      return Container();
    }

    return Image.memory(
      Uint8List.view(imageBytes!.buffer),
      gaplessPlayback: true,
      filterQuality: FilterQuality.none,
      width: canvasSize / widget.scale,
      height: canvasSize / widget.scale,
    );
  }

  Widget _getDisplay() {
    if (pixels == null) {
      return Container();
    }

    return CustomPaint(
        size: Size.square(MediaQuery.of(context).size.width),
        painter: DisplayPainter(
          pixels: pixels!,
          canvasSize: canvasSize / widget.scale,
          backgroundColor: widget.backgroundColor,
          type: widget.shapeType,
          gradient: [Colors.white,Colors.red]
        ));
  }

  void _obtainPixelsFromText(String text) async {
    ToPixelsConversionResult result = await ToPixelsConverter.fromString(
      string: text,
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
