package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.widget.RemoteViews
import android.util.Log
import androidx.core.content.FileProvider
import java.io.File


class TestWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("heatmap_widget_prefs", Context.MODE_PRIVATE)
        val path = prefs.getString("imagePath", null)

        Log.d("WIDGET_DEBUG", "PATH: $path")

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            if (path != null) {
                val file = File(path)

                Log.d("WIDGET_DEBUG", "FILE EXISTS: ${file.exists()}")

                if (file.exists()) {

                    val options = BitmapFactory.Options()
                    options.inSampleSize = 2

                    val bitmap = BitmapFactory.decodeFile(path, options)

                    if (bitmap != null) {
                        Log.d("WIDGET_DEBUG", "BITMAP LOADED SUCCESS")

                        views.setImageViewBitmap(R.id.heatmapImage, bitmap)
                    } else {
                        Log.d("WIDGET_DEBUG", "BITMAP FAILED ❌")
                    }
                }
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}