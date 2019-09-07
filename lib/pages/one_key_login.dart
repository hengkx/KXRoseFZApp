import 'package:flutter/material.dart';
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
  String url;
  _LoginState(this.url);

  @override
  void initState() {
    super.initState();
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

  void launchUrl(String url) async {
    url = url.replaceAll('googlechrome', 'kxrose');
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
          "https://ui.ptlogin2.qq.com/cgi-bin/login?pt_hide_ad=1&style=9&appid=7000201&pt_no_auth=1&pt_wxtest=1&daid=5&s_url=https%3A//meigui.qq.com/other/loginproxy.https.html%3Ftype%3D0",
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
