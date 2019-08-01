import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    /**
     * 监听web页加载状态
     */
    flutterWebviewPlugin.onStateChanged
        .listen((WebViewStateChanged webViewState) async {
      switch (webViewState.type) {
        case WebViewState.finishLoad:
          flutterWebviewPlugin.evalJavascript(
              "document.getElementById('switcher_plogin').click();document.getElementById('bottom_web').style.display='none';document.getElementById('qlogin_entry').style.display='none';document.getElementById('web_login').style.top=0;document.getElementById('web_login').style.marginTop=0;");
          break;
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:
          break;
        case WebViewState.abortLoad:
          break;
      }
    });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url:
          "https://xui.ptlogin2.qq.com/cgi-bin/xlogin?appid=7000201&s_url=https%3A//meigui.qq.com/other/loginproxy.https.html%3Ftype%3D0&qlogin_param=u1%3Dhttps%253A//meigui.qq.com/other/loginproxy.https.html%253Ftype%253D0&style=40&target=self",
      userAgent:
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36",
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
