import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_led_display/to_pixels_converter.dart';

class TextToPictureConverter {
  static ui.Picture convert({
    required String text,
    required Size canvasSize,
    required bool border,
    required Color color,
    required TextStyle textStyleInput,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder, Rect.fromLTWH(0, 0, canvasSize.width*scale, canvasSize.height*scale));



    final textStyle = TextStyle(
      color: color,
      fontSize: 10,
    ).merge(textStyleInput);

    final textSpan = TextSpan(style: textStyle, text: text);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: canvasSize.width,
      maxWidth: canvasSize.width,
    );


    const offset = Offset(0, 0);

    textPainter.paint(canvas, offset);
    print(textPainter.text);
    print(textPainter.size);
    return recorder.endRecording();
  }
}
