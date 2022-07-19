import 'package:dinyary/routes/timeline_route.dart';
import 'package:flutter/material.dart';
import 'routes/header.dart'; // <- header.dart を インポート
import 'routes/root.dart'; //

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
      // 最初の画面をタイムラインに固定
      home: TimeLine(),
    );
  }
}