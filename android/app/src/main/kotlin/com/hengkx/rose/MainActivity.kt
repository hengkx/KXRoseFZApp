package com.hengkx.rose

import android.content.Intent

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    internal var qqLoginUrl: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        val intent = intent
        if (Intent.ACTION_VIEW == intent.action && intent.data != null) {
            qqLoginUrl = intent.data!!.toString()
        }

        MethodChannel(flutterView, "rose.hengkx.com/qq").setMethodCallHandler { methodCall, result ->
            if (methodCall.method.contentEquals("getQQLoginUrl")) {
                result.success(qqLoginUrl)
                qqLoginUrl = null
            }
        }
    }
}
