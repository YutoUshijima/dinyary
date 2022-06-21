import 'package:flutter/material.dart';
import 'header.dart';

class User extends StatelessWidget {
  // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Center(child: Text("登録情報") // <- (※3)
          ),
    );
  }
}
