package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.util.Log
import android.widget.RemoteViews
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "widget_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "updateStreakWidget") {

                    val maxStreak = call.argument<Int>("maxStreak")
                    val todaySubmissions = call.argument<Int>("todaySubmissions")

                    Log.d("WIDGET_DEBUG", "STREAK RECEIVED: $maxStreak")

                    val prefs = getSharedPreferences("streak_widget_prefs", Context.MODE_PRIVATE)
                    prefs.edit()
                        .putInt("maxStreak", maxStreak ?: 0)
                        .putInt("todaySubmissions", todaySubmissions ?: 0)
                        .apply()

                    val manager = AppWidgetManager.getInstance(this)

                    val ids = manager.getAppWidgetIds(
                        ComponentName(this, StreakWidget::class.java)
                    )

                    val intent = Intent(this, StreakWidget::class.java)
                    intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)

                    sendBroadcast(intent)

                    result.success(null)
                }

                //heatmap logic
                if (call.method == "updateHeatmap"){
                    val json = call.argument<String>("heatmap")

                    val prefs = getSharedPreferences("heatmap_glance_prefs", Context.MODE_PRIVATE)
                    prefs.edit()
                        .putString("heatmap", json)
                        .apply()

                    val manager = AppWidgetManager.getInstance(this)

                    val ids = manager.getAppWidgetIds(
                        ComponentName(this, HeatMapWidgetGlance::class.java)
                    )

                    val intent = Intent(this, HeatMapWidgetGlance::class.java)
                    intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)

                    sendBroadcast(intent)
                    result.success(null)

                }
            }
    }
}