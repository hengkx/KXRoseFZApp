import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rose_fz/pages/exchange.dart';
import 'package:rose_fz/pages/log.dart';
import 'package:rose_fz/pages/home.dart';
import 'package:rose_fz/pages/one_key_login.dart';
import 'package:rose_fz/pages/settings/plant.dart';
import 'package:rose_fz/pages/settings/speed_fertilizer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
    ));
    return MaterialApp(
      title: '开心小镇',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => HomePage(),
        '/login': (_) => LoginPage(),
        '/settings/speed': (_) => SpeedFertilizerSetting(),
        '/settings/plant': (_) => PlantSetting(),
        '/log': (_) => LogPage(),
        '/exchange': (_) => ExchangePage(),
      },
      initialRoute: '/',
    );
  }
}
