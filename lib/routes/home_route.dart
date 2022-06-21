import 'package:flutter/material.dart';
import 'header.dart';

class Home extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Center(child: Text("ホーム") // <- (※3)
          ),
    );
  }
}