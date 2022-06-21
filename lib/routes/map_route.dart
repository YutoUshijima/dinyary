import 'package:flutter/material.dart';
import 'header.dart';

class Map extends StatelessWidget {
  // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Center(child: Text("地図") // <- (※3)
          ),
    );
  }
}
