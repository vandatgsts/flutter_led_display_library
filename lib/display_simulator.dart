import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'display_painter.dart';
import 'to_pixels_converter.dart';

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
  late TextPainter textPainter;
  late Size size;
  late TextStyle textStyle;

  @override
  void initState() {
    textStyle =
        widget.textStyle.copyWith(fontSize: widget.textStyle.fontSize! / 4);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: textStyle),
      textDirection: TextDirection.ltr,
      textScaleFactor: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    size = textPainter.size;
    _obtainPixelsFromText(widget.text);

    return _getDisplay();
  }

  Widget _getDisplay() {
    if (pixels == null) {
      return Container();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            color: Colors.white,
          ),
          CustomPaint(
            size: Size(pixels!.length.toDouble(), pixels![0].length.toDouble()),
            painter: DisplayPainter(
                pixels: pixels!,
                sizeInput: size * 2,
                backgroundColor: widget.backgroundColor,
                type: widget.shapeType,
                gradient: [widget.textColor, widget.textColor]),
          ),
          Container(
            height: 30,
            width: 30,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  void _obtainPixelsFromText(String text) async {
    ToPixelsConversionResult result = await ToPixelsConverter.fromString(
      string: text,
      textStyle: textStyle,
      border: widget.border,
      canvasSize: size,
      textColor: widget.textColor,
    ).convert();

    if (imageBytes == null || pixels == null) {
      setState(() {
        imageBytes = result.imageBytes;
        pixels = result.pixels;
      });
    }
  }
}
