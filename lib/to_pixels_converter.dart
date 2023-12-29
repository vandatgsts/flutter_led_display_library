import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_led_display/text_to_picture_converter.dart';
import 'package:image/image.dart' as imagePackage;

class ToPixelsConverter {
  ToPixelsConverter.fromString({
    required this.string,
    required this.canvasSize,
    this.border = false,
  }) : canvas = null;

  ToPixelsConverter.fromCanvas({
    required this.canvas,
    required this.canvasSize,
  }) : string = null, border = false;

  String? string; // Marked as nullable
  Canvas? canvas; // Marked as nullable
  bool border;
  final double canvasSize;

  Future<ToPixelsConversionResult> convert() async {
    if (string == null && canvas == null) {
      throw Exception('No input provided for conversion');
    }

    // Ensure the text to picture converter is appropriately handling null values
    final ui.Picture picture = (string != null)
        ? TextToPictureConverter.convert(
        text: string!, canvasSize: canvasSize, border: border)
        : throw Exception('Canvas conversion not supported yet');

    final ByteData imageBytes = await _pictureToBytes(picture);
    final List<List<Color>> pixels = _bytesToPixelArray(imageBytes);

    return ToPixelsConversionResult(
      imageBytes: imageBytes,
      pixels: pixels,
    );
  }

  Future<ByteData> _pictureToBytes(ui.Picture picture) async {
    final ui.Image img = await picture.toImage(
        canvasSize.toInt(), canvasSize.toInt()
    );
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) throw Exception("Failed to convert image to bytes");
    return data;
  }

  List<List<Color>> _bytesToPixelArray(ByteData imageBytes) {
    imagePackage.Image? decodedImage = imagePackage.decodeImage(imageBytes.buffer.asUint8List());
    if (decodedImage == null) {
      throw Exception('Failed to decode image');
    }

    List<List<Color>> pixelArray = List.generate(
      canvasSize.toInt(),
          (_) => List.filled(canvasSize.toInt(), Colors.transparent),
    );

    for (int i = 0; i < canvasSize.toInt(); i++) {
      for (int j = 0; j < canvasSize.toInt(); j++) {
        int pixel = decodedImage.getPixelSafe(i, j) as int;
        int hex = _convertColorSpace(pixel);
        pixelArray[i][j] = Color(hex);
      }
    }

    return pixelArray;
  }

  int _convertColorSpace(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}

class ToPixelsConversionResult {
  ToPixelsConversionResult({
    required this.imageBytes,
    required this.pixels,
  });

  final ByteData imageBytes;
  final List<List<Color>> pixels;
}
