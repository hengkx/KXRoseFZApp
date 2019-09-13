import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './pages/home.dart';
import './pages/one_key_login.dart';
import './pages/settings/speed_fertilizer.dart';
import 'pages/settings/plant.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // status bar color
    ));
    return MaterialApp(
      title: '开心玫瑰辅助V',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => HomePage(),
        '/login': (_) => LoginPage(),
        '/settings/speed': (_) => SpeedFertilizerSetting(),
        '/settings/plant': (_) => PlantSetting(),
      },
      initialRoute: '/',
    );
  }
}
