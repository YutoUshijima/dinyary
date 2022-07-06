import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';

class Analysis extends StatelessWidget {
  // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      bottomNavigationBar: Footer(
        pageid: 3),
      body: Center(child: Text("解析") // <- (※3)
          ),
    );
  }
}
