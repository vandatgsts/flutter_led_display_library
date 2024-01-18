import 'package:flutter/material.dart';
import 'package:flutter_led_display/display_simulator.dart';

import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Home(
          text: "A",
          textColor: Colors.red,
          backgroundColor: Colors.yellow,
          scale: 1,
          shapeType: ShapeType.rectangle,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
