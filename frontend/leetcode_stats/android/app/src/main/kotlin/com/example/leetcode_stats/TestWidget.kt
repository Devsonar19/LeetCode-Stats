package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews


class TestWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        val maxStreak = prefs.getLong("flutter.max_streak", 0L).toInt()
        val todaySubs = prefs.getLong("flutter.today_submissions", 0L).toInt()

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            views.setTextViewText(R.id.streakText, "Streak: $maxStreak")
            views.setTextViewText(R.id.submissionText, "Today: $todaySubs")

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}