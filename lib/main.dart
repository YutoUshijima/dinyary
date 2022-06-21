import 'package:flutter/material.dart';
import 'routes/header.dart'; // <- header.dart を インポート
import 'root.dart'; // <- footer.dart をインポート

void main() {
 runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
      theme: ThemeData(
              primaryColor: Colors.blueGrey[900],
      ),
      home: RootWidget(),
    );
  }
}