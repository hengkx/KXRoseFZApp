import 'package:flutter/material.dart';

import './pages/home.dart';
import './pages/login.dart';
import './pages/select_flower.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '开心玫瑰辅助V',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => HomePage(),
        '/selectFlower': (_) => SelectFlowerPage(),
        '/login': (_) => LoginPage(),
      },
      initialRoute: '/',
    );
  }
}
