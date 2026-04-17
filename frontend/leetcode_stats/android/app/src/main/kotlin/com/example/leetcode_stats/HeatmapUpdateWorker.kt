package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.util.Log
import androidx.work.*
import java.util.concurrent.TimeUnit

class HeatmapUpdateWorker(
    private val context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    companion object {
        private const val TAG       = "HeatmapWorker"
        private const val WORK_NAME = "leetcode_heatmap_periodic"

        const val KEY_USERNAME = "username"

        fun schedule(
            context: Context,
            username: String,
            intervalH: Long = 3L
        ) {
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .setRequiresBatteryNotLow(false)
                .build()

            val inputData = workDataOf(KEY_USERNAME to username)

            val request = PeriodicWorkRequestBuilder<HeatmapUpdateWorker>(
                repeatInterval = intervalH,
                repeatIntervalTimeUnit = TimeUnit.HOURS
            )
                .setConstraints(constraints)
                .setInputData(inputData)
                .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 5, TimeUnit.MINUTES)
                .build()

            WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                WORK_NAME,
                ExistingPeriodicWorkPolicy.KEEP,
                request
            )

            Log.d(TAG, "Scheduled periodic heatmap update every ${intervalH}h for '$username'")
        }

        fun cancel(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork(WORK_NAME)
            Log.d(TAG, "Periodic heatmap update cancelled")
        }

        fun runNow(context: Context, defaultUsername: String) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

            // Read the correct Flutter shared preference key
            val username = prefs.getString("flutter.username", null)
                ?: prefs.getString("flutter.flutter.username_0", defaultUsername)
                ?: defaultUsername

            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

            val request = OneTimeWorkRequestBuilder<HeatmapUpdateWorker>()
                .setConstraints(constraints)
                .setInputData(workDataOf(KEY_USERNAME to username))
                .setBackoffCriteria(BackoffPolicy.LINEAR, 1, TimeUnit.MINUTES)
                .build()

            WorkManager.getInstance(context)
                .enqueueUniqueWork(
                    "leetcode_heatmap_oneshot",
                    ExistingWorkPolicy.REPLACE,
                    request
                )

            Log.d(TAG, "One-shot fetch enqueued for '$username'")
        }
    }

    override suspend fun doWork(): Result {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        // Use the correct flutter key, or fallback to the worker param
        val username = prefs.getString("flutter.username", null)
            ?: prefs.getString("flutter.flutter.username_0", null)
            ?: inputData.getString(KEY_USERNAME)
            ?: return Result.retry()

        Log.d(TAG, "doWork() started for '$username'")

        return try {
            if (!LeetCodeHeatmapWidget.isNetworkAvailable(context)) {
                Log.w(TAG, "No network despite constraint — retrying")
                return Result.retry()
            }

            val data = LeetCodeApi.fetchUserCalendar(username)

            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, LeetCodeHeatmapWidget::class.java)
            )

            val density = context.resources.displayMetrics.density

            for (id in ids) {
                val options  = manager.getAppWidgetOptions(id)
                val widthPx  = (options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH,  320) * density).toInt()
                val heightPx = (options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 180) * density).toInt()

                val bitmap: Bitmap = HeatmapRenderer.render(
                    data     = data,
                    widthPx  = widthPx.coerceAtLeast(200),
                    heightPx = heightPx.coerceAtLeast(100),
                    density  = density,
                    username = username
                )

                LeetCodeHeatmapWidget.saveBitmapCache(context, id, bitmap)
            }

            val intent = Intent(context, LeetCodeHeatmapWidget::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            }
            context.sendBroadcast(intent)

            Log.d(TAG, "doWork() success — ${data.totalActiveDays} active days")
            Result.success()

        } catch (e: Exception) {
            Log.e(TAG, "doWork() failed: ${e.message}")
            if (runAttemptCount < 3) Result.retry() else Result.failure()
        }
    }
}