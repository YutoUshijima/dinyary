import 'package:flutter/material.dart';
 
class Game extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ゲーム"), // <- (※2)
      ),
      body: Center(child: Text("ゲーム") // <- (※3)
          ),
    );
  }
}