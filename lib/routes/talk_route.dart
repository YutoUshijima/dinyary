import 'package:flutter/material.dart';
 
class Talk extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("トーク"), // <- (※2)
      ),
      body: Center(child: Text("トーク") // <- (※3)
          ),
    );
  }
}