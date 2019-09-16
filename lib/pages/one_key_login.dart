import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final String url;

  LoginPage({Key key, this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState(url);
}

class _LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  String redirectUrl =
      "https%3A//meigui.qq.com/other/loginproxy.https.html%3Ftype%3D0";
  String url;
  BannerAd myBanner;
  static const EventChannel eventChannel =
      EventChannel('rose.hengkx.com/login');

  _LoginState(this.url);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
        keywords: <String>['玫瑰小镇', '休闲', '网页游戏', '种花'],
        childDirected: false,
        testDevices: <String>[
          '6E12CFF42AD75DB204F205C78113B0D2'
        ], // Android emulators are considered test devices
      );
      myBanner = BannerAd(
        adUnitId: 'ca-app-pub-6326384735097338/9084039564',
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
      );
      myBanner
        // typically this happens well before the ad is shown
        ..load()
        ..show(
          // Positions the banner ad 60 pixels from the bottom of the screen
          anchorOffset: 0,
          // Positions the banner ad 10 pixels from the center of the screen to the right
          horizontalCenterOffset: 0,
          // Banner Position
          anchorType: AnchorType.bottom,
        );
    }
    if (Platform.isIOS) {
      eventChannel.receiveBroadcastStream().listen(_onEvent);
    }
    /**
     * 监听页面加载url
     */
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url == "https://meigui.qq.com/other/loginproxy.https.html?type=0") {
        flutterWebviewPlugin
            .getCookies()
            .then((Map<String, String> _cookies) async {
          String cookies = '';
          _cookies.forEach((String key, String value) {
            cookies += key + '=' + value + ';';
          });

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('cookies', cookies);

          Navigator.pop(context);
        });
      }
      if (url.startsWith('wtloginmqq://ptlogin/qlogin')) {
        launchUrl(url);
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    if (Platform.isAndroid) {
      myBanner.dispose();
    }
  }

  void _onEvent(Object event) {
    url =
        "https://ssl.ptlogin2.qq.com/jump?u1=${redirectUrl}${event.toString().replaceAll('kxrose://(null)', '')}";
    print(url);
    flutterWebviewPlugin.reloadUrl(url);
  }

  void launchUrl(String url) async {
    url = url.replaceAll('googlechrome', 'kxrose');
    url = "$url&schemacallback=kxrose%3A%2F%2F";
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url ??
          "https://ui.ptlogin2.qq.com/cgi-bin/login?pt_hide_ad=1&style=9&appid=7000201&pt_no_auth=1&pt_wxtest=1&daid=5&s_url=${redirectUrl}",
      appBar: AppBar(
        title: Text("QQ登录"),
        backgroundColor: Colors.grey,
      ),
      scrollBar: false,
      withZoom: false,
    );
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }
}
