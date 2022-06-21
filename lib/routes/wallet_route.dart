import 'package:flutter/material.dart';
 
class Wallet extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ウォレット"), // <- (※2)
      ),
      body: Center(child: Text("ウォレット") // <- (※3)
          ),
    );
  }
}