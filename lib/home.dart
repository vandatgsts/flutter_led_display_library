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
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                DisplaySimulator(
                  text: widget.text,
                  border: false,
                  debug: false,
                  textColor: widget.textColor,
                  backgroundColor: widget.backgroundColor,
                  shapeType: widget.shapeType,
                ),
                const SizedBox(height: 48),
              ],
            )));
  }

  Container _getTextField() {
    BorderSide borderSide = const BorderSide(color: Colors.blue, width: 4);
    InputDecoration inputDecoration = InputDecoration(
      border: UnderlineInputBorder(borderSide: borderSide),
      disabledBorder: UnderlineInputBorder(borderSide: borderSide),
      enabledBorder: UnderlineInputBorder(borderSide: borderSide),
      focusedBorder: UnderlineInputBorder(borderSide: borderSide),
    );

    return Container(
        width: 200,
        child: TextField(
          maxLines: null,
          enableSuggestions: false,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.yellow, fontSize: 32, fontFamily: "Monospace"),
          decoration: inputDecoration,
          onChanged: (val) {
            setState(() {
              text = val;
            });
          },
          //controller: _controller,
        ));
  }
}
