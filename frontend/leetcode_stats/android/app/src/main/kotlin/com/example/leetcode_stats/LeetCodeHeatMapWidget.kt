package com.example.leetcode_stats

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.RemoteViews
import com.example.leetcode_stats.LeetCodeHeatmapWidget.Companion.DEFAULT_USERNAME
import kotlinx.coroutines.*
import java.io.ByteArrayOutputStream

class LeetCodeHeatmapWidget : AppWidgetProvider() {

    companion object {
        private const val TAG = "LeetCodeWidget"

        const val DEFAULT_USERNAME    = "your_leetcode_usernamecxhbqwxqwbiwbqwjqwiu"
        const val PREFS_NAME          = "LeetCodeWidgetPrefs"


        private const val PREF_CACHE_PREFIX = "bitmap_cache_"

        private var networkCallback: ConnectivityManager.NetworkCallback? = null

        fun onNetworkRestored(context: Context) {
            Log.d(TAG, "Network restored — refreshing all widget instances")
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, LeetCodeHeatmapWidget::class.java)
            )

            val intent = Intent(context, LeetCodeHeatmapWidget::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            }
            context.sendBroadcast(intent)
        }


        fun isNetworkAvailable(context: Context): Boolean {
            val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE)
                    as? ConnectivityManager ?: return false
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val net  = cm.activeNetwork ?: return false
                val caps = cm.getNetworkCapabilities(net) ?: return false
                caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
                        caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
            } else {
                @Suppress("DEPRECATION")
                cm.activeNetworkInfo?.isConnected == true
            }
        }

        fun registerNetworkCallback(context: Context) {
            if (networkCallback != null) return
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) return

            val cm = context.applicationContext
                .getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
                ?: return

            val request = NetworkRequest.Builder()
                .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                .build()

            val cb = object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    onNetworkRestored(context.applicationContext)
                }
            }
            cm.registerNetworkCallback(request, cb)
            networkCallback = cb
            Log.d(TAG, "NetworkCallback registered")
        }

        fun saveBitmapCache(context: Context, widgetId: Int, bmp: Bitmap) {
            try {
                val baos = ByteArrayOutputStream()
                bmp.compress(Bitmap.CompressFormat.PNG, 90, baos)
                val bytes = baos.toByteArray()
                // android:value can't hold raw bytes; base64-encode
                val b64 = android.util.Base64.encodeToString(bytes, android.util.Base64.DEFAULT)
                context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                    .edit()
                    .putString("$PREF_CACHE_PREFIX$widgetId", b64)
                    .apply()
            } catch (e: Exception) {
                Log.w(TAG, "Failed to cache bitmap", e)
            }
        }

        fun loadBitmapCache(context: Context, widgetId: Int): Bitmap? {
            return try {
                val b64 = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                    .getString("$PREF_CACHE_PREFIX$widgetId", null) ?: return null
                val bytes = android.util.Base64.decode(b64, android.util.Base64.DEFAULT)
                BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            } catch (e: Exception) {
                null
            }
        }
    }

    private val jobs  = mutableMapOf<Int, Job>()
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)


    override fun onEnabled(context: Context) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val username = prefs.getString("flutter.username", DEFAULT_USERNAME)
            ?: DEFAULT_USERNAME
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        registerNetworkCallback(context.applicationContext)

        for (id in appWidgetIds) {
            updateWidget(context, appWidgetManager, id)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        updateWidget(context, appWidgetManager, appWidgetId)
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            jobs[id]?.cancel()
            jobs.remove(id)
        }
    }

    override fun onDisabled(context: Context) {
        scope.cancel()
        HeatmapUpdateWorker.cancel(context)
        networkCallback?.let { cb ->
            try {
                val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE)
                        as? ConnectivityManager
                cm?.unregisterNetworkCallback(cb)
            } catch (_: Exception) {}
            networkCallback = null
            Log.d(TAG, "NetworkCallback unregistered")
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        jobs[appWidgetId]?.cancel()

        val username = getUsername(context)
        val options  = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val density  = context.resources.displayMetrics.density
        val widthPx  = (options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH,  320) * density).toInt()
        val heightPx = (options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 180) * density).toInt()

        if (!isNetworkAvailable(context)) {
            Log.d(TAG, "Widget $appWidgetId: no network — showing cached/offline state")
            val cached = loadBitmapCache(context, appWidgetId)
            if (cached != null) {
                pushBitmap(context, appWidgetManager, appWidgetId, cached)
            } else {
                showStatusState(context, appWidgetManager, appWidgetId,
                    "No network — tap to retry", "#8B949E")
            }
            return
        }

        showStatusState(context, appWidgetManager, appWidgetId, "Loading…", "#8B949E")

        jobs[appWidgetId] = scope.launch {
            try {
                val data = withContext(Dispatchers.IO) {
                    LeetCodeApi.fetchUserCalendar(username)
                }

                val bitmap = withContext(Dispatchers.Default) {
                    HeatmapRenderer.render(
                        data     = data,
                        widthPx  = widthPx.coerceAtLeast(200),
                        heightPx = heightPx.coerceAtLeast(100),
                        density  = density,
                        username = username
                    )
                }

                saveBitmapCache(context, appWidgetId, bitmap)
                pushBitmap(context, appWidgetManager, appWidgetId, bitmap)

                Log.d(TAG, "Widget $appWidgetId updated — ${data.totalActiveDays} days, streak ${data.streak}")

            } catch (e: CancellationException) {
                Log.d(TAG, "Widget $appWidgetId update cancelled")
            } catch (e: Exception) {
                Log.e(TAG, "Widget $appWidgetId fetch failed", e)

                val cached = loadBitmapCache(context, appWidgetId)
                if (cached != null) {
                    pushBitmap(context, appWidgetManager, appWidgetId, cached)
                    Log.d(TAG, "Showing stale cached bitmap after error")
                } else {
                    val msg = when {
                        e.message?.contains("Unable to resolve host") == true -> "No network — tap to retry"
                        e.message?.contains("timeout", ignoreCase = true)    == true -> "Timed out — tap to retry"
                        e.message?.contains("not found", ignoreCase = true)  == true -> "User not found"
                        else -> "Error — tap to retry"
                    }
                    showStatusState(context, appWidgetManager, appWidgetId, msg, "#F85149")
                }
            }
        }
    }


    private fun pushBitmap(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        bitmap: Bitmap
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_leetcode_heatmap)
        views.setImageViewBitmap(R.id.iv_heatmap, bitmap)
        views.setOnClickPendingIntent(R.id.iv_heatmap, buildRefreshIntent(context, appWidgetId))
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun showStatusState(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        message: String,
        hexColor: String
    ) {
        val density = context.resources.displayMetrics.density
        val bmp = Bitmap.createBitmap(
            (300 * density).toInt(), (150 * density).toInt(), Bitmap.Config.ARGB_8888
        )
        bmp.eraseColor(android.graphics.Color.parseColor("#0D1117"))

        val canvas = android.graphics.Canvas(bmp)
        val paint  = android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG).apply {
            color    = android.graphics.Color.parseColor(hexColor)
            textSize = 11f * density
            typeface = android.graphics.Typeface.create(
                android.graphics.Typeface.MONOSPACE, android.graphics.Typeface.NORMAL)
        }
        canvas.drawText(message, 14f * density, 80f * density, paint)

        paint.textSize = 9f * density
        paint.color    = android.graphics.Color.parseColor("#8B949E")
        canvas.drawText("Tap to refresh", 14f * density, 96f * density, paint)

        val views = RemoteViews(context.packageName, R.layout.widget_leetcode_heatmap)
        views.setImageViewBitmap(R.id.iv_heatmap, bmp)
        views.setOnClickPendingIntent(R.id.iv_heatmap, buildRefreshIntent(context, appWidgetId))
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun buildRefreshIntent(context: Context, appWidgetId: Int): android.app.PendingIntent {
        val intent = Intent(context, RefreshReceiver::class.java).apply {
            action = RefreshReceiver.ACTION_REFRESH
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(appWidgetId))
        }
        return android.app.PendingIntent.getBroadcast(
            context,
            appWidgetId,
            intent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or
                    android.app.PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun getUsername(context: Context): String {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        // Standardize pulling the username using the 'flutter.' prefix
        return prefs.getString("flutter.username", null)
            ?: DEFAULT_USERNAME
    }
}

class NetworkChangeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ConnectivityManager.CONNECTIVITY_ACTION,
            Intent.ACTION_BOOT_COMPLETED -> {
                if (LeetCodeHeatmapWidget.isNetworkAvailable(context)) {
                    LeetCodeHeatmapWidget.onNetworkRestored(context)
                }
            }
        }
    }
}

class RefreshReceiver : BroadcastReceiver() {
    companion object {
        const val ACTION_REFRESH = "com.example.leetcodewidget.ACTION_REFRESH"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != ACTION_REFRESH) return

        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val username = prefs.getString("flutter.username", DEFAULT_USERNAME)
            ?: DEFAULT_USERNAME

        HeatmapUpdateWorker.runNow(context, username)
    }
}