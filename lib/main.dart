import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rose_fz/pages/exchange.dart';
import 'package:rose_fz/pages/log.dart';
import 'package:rose_fz/pages/home.dart';
import 'package:rose_fz/pages/one_key_login.dart';
import 'package:rose_fz/pages/settings/plant.dart';
import 'package:rose_fz/pages/settings/speed_fertilizer.dart';
import 'package:rose_fz/pages/settings/talent_pk.dart';
import 'package:rose_fz/store/index.dart';
import 'package:rose_fz/store/models/user_model.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Store.of(context);
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
        '/settings/pk': (_) => TalentPKSetting(),
        '/log': (_) => LogPage(),
        '/exchange': (_) => ExchangePage(),
      },
      initialRoute: '/',
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Store.init(child: MainApp()),
    );
  }
}

void main() => runApp(MyApp());
