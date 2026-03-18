package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "widget_update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "updateWidget") {
                    val intent = Intent(this, TestWidget::class.java)
                    intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE

                    val ids = AppWidgetManager.getInstance(this)
                        .getAppWidgetIds(ComponentName(this, TestWidget::class.java))

                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                    sendBroadcast(intent)

                    result.success(null)
                }
            }
    }
}