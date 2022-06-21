import 'package:flutter/material.dart';
import 'header.dart';
 
class TimeLine extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Center(child: Text("タイムライン") // <- (※3)
          ),
    );
  }
}