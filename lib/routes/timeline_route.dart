import 'package:flutter/material.dart';
 
class TimeLine extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("タイムライン"), // <- (※2)
      ),
      body: Center(child: Text("タイムライン") // <- (※3)
          ),
    );
  }
}