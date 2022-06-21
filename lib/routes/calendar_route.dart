import 'package:flutter/material.dart';
import 'header.dart';

class Calendar extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Center(child: Text("カレンダー") // <- (※3)
          ),
    );
  }
}