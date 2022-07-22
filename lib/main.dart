import 'package:dinyary/routes/timeline_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
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