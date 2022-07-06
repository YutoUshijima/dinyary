import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';

class Calendar extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      bottomNavigationBar: Footer(
        pageid: 2),
      body: Center(child: Text("カレンダー") // <- (※3)
          ),
    );
  }
}