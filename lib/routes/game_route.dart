import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';


class Game extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      bottomNavigationBar: Footer(
        pageid: 4),
      body: Center(child: Text("ゲーム") // <- (※3)
          ),
    );
  }
}