import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';


class Map extends StatelessWidget {
  // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      bottomNavigationBar: Footer(
        pageid: 1),
      body: Center(child: Text("地図") // <- (※3)
          ),
    );
  }
}
