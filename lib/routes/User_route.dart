import 'package:flutter/material.dart';

class User extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登録情報"), // <- (※2)
      ),
      body: Center(child: Text("登録情報") // <- (※3)
          ),
    );
  }
}