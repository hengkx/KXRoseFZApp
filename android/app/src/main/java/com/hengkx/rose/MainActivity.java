package com.hengkx.rose;

import android.content.Intent;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  String qqLoginUrl;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    Intent intent = getIntent();
    if (Intent.ACTION_VIEW.equals(intent.getAction()) && intent.getData() != null) {
      qqLoginUrl = intent.getData().toString();
    }

    new MethodChannel(getFlutterView(), "app.channel.qq.data").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.contentEquals("getQQLoginUrl")) {
          result.success(qqLoginUrl);
          qqLoginUrl = null;
        }
      }
    });
  }
}
