import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TextToPictureConverter {
  static ui.Picture convert({
    required String text,
    required double canvasSize,
    required bool border,
    required Color color,
    required TextStyle textStyleInput,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        const Offset(0.0, 0.0),
        Offset(canvasSize, canvasSize),
      ),
    );

    if (border) {
      final stroke = Paint()
        ..color = color
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTWH(0.0, 0.0, canvasSize, canvasSize), stroke);
    }

    final textStyle = TextStyle(
      fontFamily: "Monospace",
      color: color,
      fontSize: 100,
    ).merge(textStyleInput);

    final textSpan = TextSpan(style: textStyle, text: text);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );

    final offset = Offset(
      (canvasSize - textPainter.width) * 0.5,
      (canvasSize - textPainter.height) * 0.5,
    );

    textPainter.paint(canvas, offset);

    return recorder.endRecording();
  }
}
