package com.example.leetcode_stats

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "widget_update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "refreshWidget") {

                    val intent = Intent(this, WidgetUpdateReceiver::class.java)
                    sendBroadcast(intent)

                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}