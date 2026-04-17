package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class WidgetUpdateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(
            ComponentName(context, LeetCodeHeatmapWidget::class.java)
        )

        val updateIntent = Intent(context, LeetCodeHeatmapWidget::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        }

        context.sendBroadcast(updateIntent)
    }
}