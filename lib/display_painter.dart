import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_led_display/display_simulator.dart';

class DisplayPainter extends CustomPainter {
  DisplayPainter({
    required this.pixels,
    required this.backgroundColor,
    this.gradient,
    required this.type,
  });

  List<List<Color>> pixels;
  Color backgroundColor;
  List<Color>? gradient;
  ShapeType type;

  @override
  void paint(Canvas canvas, Size size) {

    // Paint rectPaint = Paint()..color = backgroundColor;
    Paint shapePaint = Paint();

    double baseSpacingFactor = 0.4; // 10% of the shape size

    for (int i = 0; i < pixels.length; i++) {
      for (int j = 0; j < pixels[i].length; j++) {
        // ... [Existing color and opacity checks]

        var cellSize =
            min(size.width / pixels.length, size.height / pixels[i].length);
        var spacing = cellSize * baseSpacingFactor;
        var shapeSize =
            cellSize - spacing; // Adjust shape size based on spacing
        // shapeSize *= valueSpace;
        var center = Offset(
          (i + 0.5) * cellSize,
          (j + 0.5) * cellSize,
        );

        shapePaint.color = pixels[i][j];
        shapePaint.strokeWidth=2;
        // Now draw the shapes with adjusted sizes and spacing
        switch (type) {
          case ShapeType.rectangle: // Square
            canvas.drawRect(
              Rect.fromCenter(
                  center: center, width: shapeSize, height: shapeSize),
              shapePaint,
            );
            break;
          case ShapeType.circle: // Circle
            canvas.drawCircle(center, shapeSize / 2, shapePaint);
            break;
          case ShapeType.star: // Star
            drawStar(
                canvas, center, shapeSize / 3, shapeSize / 4.5, 5, shapePaint);
            break;
          case ShapeType.heart: // Heart
            drawHeart(canvas, center, shapeSize, shapePaint);
            break;
          default:
            break;
        }
      }
    }
  }

  void drawStar(Canvas canvas, Offset center, double outerRadius,
      double innerRadius, int points, Paint paint) {
    Path path = Path();
    double angle = -pi / 2;
    double deltaAngle = pi / points;
    for (int i = 0; i < points * 2; i++) {
      double radius = i.isEven ? outerRadius : innerRadius;
      // Calculate the x and y coordinates for the point
      double x = center.dx + cos(angle) * radius;
      double y = center.dy + sin(angle) * radius;

      // If it's the first point, move to it without drawing a line
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Connect the current point with the previous one
        path.lineTo(x, y);
      }
      angle += deltaAngle;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    Path path = Path();
    double width = size;
    double height = size * 2;
    width = height; // Height is larger to ensure the heart is not too wide.

    // Start from the top center of the heart
    path.moveTo(center.dx, center.dy - height / 4);

    // Top left curve
    path.cubicTo(
      center.dx - width / 2, center.dy - height / 2, // control point 1
      center.dx - width / 2, center.dy, // control point 2
      center.dx, center.dy + height / 4, // end point
    );

    // Top right curve
    path.cubicTo(
      center.dx + width / 2, center.dy, // control point 1
      center.dx + width / 2, center.dy - height / 2, // control point 2
      center.dx, center.dy - height / 4, // end point
    );

    // Bottom point
    path.lineTo(center.dx, center.dy + height / 2);

    // Finish drawing the heart by closing the path
    path.close();

    // Draw the heart shape onto the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
