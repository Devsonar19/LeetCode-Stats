package com.example.leetcode_stats

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.os.Bundle
import android.widget.RemoteViews
import kotlinx.coroutines.*

class LeetCodeHeatmapWidget : AppWidgetProvider() {

    companion object {
        const val PREFS = "FlutterSharedPreferences"
        const val PREF_USER_PREFIX = "flutter.widget_username"
    }

    private val jobs = mutableMapOf<Int, Job>()
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) {
            update(context, manager, id)
        }
    }

    override fun onAppWidgetOptionsChanged(context: Context, manager: AppWidgetManager, id: Int, opts: Bundle) {
        update(context, manager, id)
    }

    override fun onDeleted(context: Context, ids: IntArray) {
        for (id in ids) {
            jobs[id]?.cancel()
            jobs.remove(id)
        }
    }

    override fun onDisabled(context: Context) {
        scope.cancel()
    }

    private fun update(context: Context, manager: AppWidgetManager, id: Int) {
        jobs[id]?.cancel()

        showLoad(context, manager, id)

        val user = getUser(context)
        if (user.isNullOrBlank()) {
            showError(context, manager, id, "No user set")
            return
        }

        val opts = manager.getAppWidgetOptions(id)
        val wDp = opts.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH, 320)
        val hDp = opts.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 180)
        val den = context.resources.displayMetrics.density
        val wPx = (wDp * den).toInt()
        val hPx = (hDp * den).toInt()

        jobs[id] = scope.launch {
            try {
                val data = withContext(Dispatchers.IO) {
                    LeetCodeApi.fetchUserCalendar(user)
                }

                val bmp = withContext(Dispatchers.Default) {
                    HeatmapRenderer.render(
                        data = data,
                        widthPx = wPx.coerceAtLeast(200),
                        heightPx = hPx.coerceAtLeast(100),
                        density = den,
                        username = user
                    )
                }

                val views = RemoteViews(context.packageName, R.layout.widget_leetcode_heatmap)
                views.setImageViewBitmap(R.id.iv_heatmap, bmp)

                val intent = Intent(context, LeetCodeHeatmapWidget::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(id))
                }
                val pending = PendingIntent.getBroadcast(
                    context, id, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.iv_heatmap, pending)

                manager.updateAppWidget(id, views)

            } catch (e: CancellationException) {

            } catch (e: Exception) {
                showError(context, manager, id, e.message ?: "Error")
            }
        }
    }

    private fun showLoad(context: Context, manager: AppWidgetManager, id: Int) {
        val views = RemoteViews(context.packageName, R.layout.widget_leetcode_heatmap)
        val den = context.resources.displayMetrics.density
        val bmp = Bitmap.createBitmap((300 * den).toInt(), (150 * den).toInt(), Bitmap.Config.ARGB_8888)
        bmp.eraseColor(Color.parseColor("#0D1117"))

        val canvas = Canvas(bmp)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.parseColor("#8B949E")
            textSize = 12f * den
        }
        canvas.drawText("Loading…", 8f * den, 80f * den, paint)
        views.setImageViewBitmap(R.id.iv_heatmap, bmp)
        manager.updateAppWidget(id, views)
    }

    private fun showError(context: Context, manager: AppWidgetManager, id: Int, err: String) {
        val views = RemoteViews(context.packageName, R.layout.widget_leetcode_heatmap)
        val den = context.resources.displayMetrics.density
        val bmp = Bitmap.createBitmap((300 * den).toInt(), (150 * den).toInt(), Bitmap.Config.ARGB_8888)
        bmp.eraseColor(Color.parseColor("#0D1117"))

        val canvas = Canvas(bmp)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.parseColor("#F85149")
            textSize = 11f * den
        }
        canvas.drawText("⚠ ${err.take(60)}", 8f * den, 80f * den, paint)
        views.setImageViewBitmap(R.id.iv_heatmap, bmp)
        manager.updateAppWidget(id, views)
    }

    private fun getUser(context: Context): String? {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        return prefs.getString(PREF_USER_PREFIX, null)
    }

}