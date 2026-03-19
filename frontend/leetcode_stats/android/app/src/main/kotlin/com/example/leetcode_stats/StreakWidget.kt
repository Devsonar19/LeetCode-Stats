package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class StreakWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {

        val prefs = context.getSharedPreferences("streak_widget_prefs", Context.MODE_PRIVATE)

        val maxStreak = prefs.getInt("maxStreak", 0)
        val todaySubmissions = prefs.getInt("todaySubmissions", 0)

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.streak_widget_layout)

            views.setTextViewText(R.id.maxStreakText, "Streak: $maxStreak")
            views.setTextViewText(R.id.todayText, "Today: $todaySubmissions")

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}