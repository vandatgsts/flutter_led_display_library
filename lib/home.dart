import 'package:flutter/material.dart';
import 'display_simulator.dart';

class Home extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double scale;
  final ShapeType shapeType;

  const Home({
    required this.text,
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.scale,
    required this.shapeType,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = "A";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  child: DisplaySimulator(
                    text: "Nguyen Van Dat Vui Vui",
                    border: false,
                    debug: false,
                    textColor: widget.textColor,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 100,
                    ),
                    backgroundColor: Colors.yellow,
                    shapeType: ShapeType.star,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            )));
  }
}
