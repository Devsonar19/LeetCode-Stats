package com.example.leetcode_stats

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.LocalContext
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.*
import androidx.glance.text.Text
import androidx.glance.color.ColorProvider
import androidx.glance.unit.ColorProvider
import org.json.JSONObject

class HeatMapWidgetGlance : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = context.getSharedPreferences("heatmap_glance_prefs", Context.MODE_PRIVATE)
        val json = prefs.getString("heatmap", "{}")
        val map = JSONObject(json ?: "{}")

        provideContent {
            HeatmapContent(map)
        }
    }
}

@Composable
fun HeatmapContent(map: JSONObject) {
    val context = LocalContext.current

    val prefs = context.getSharedPreferences("streak_widget_prefs", Context.MODE_PRIVATE)
    val streak = prefs.getInt("maxStreak", 0)
    val today = prefs.getInt("todaySubmissions", 0)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(ColorProvider(R.color.widget_bg))
            .padding(12.dp)
    ) {
        Text(text = "🔥 $streak")
        Text(text = "Today: $today")

        Spacer(modifier = GlanceModifier.height(8.dp))

        HeatMapGrid(map)
    }
}

@Composable
fun HeatMapGrid(map: JSONObject) {

    val keys = mutableListOf<String>()
    val iterator = map.keys()

    while (iterator.hasNext()) {
        keys.add(iterator.next())
    }

    // ✅ CORRECT: sort by timestamp
    val sortedKeys = keys.sortedBy { it.toLong() }

    val days = sortedKeys.takeLast(84) // last ~12 weeks
    val weeks = days.chunked(7)

    Row {

        weeks.forEach { week ->

            Column(
                modifier = GlanceModifier.padding(end = 2.dp)
            ) {

                week.forEach { day ->

                    val value = if (map.has(day)) map.getInt(day) else 0

                    Box(
                        modifier = GlanceModifier
                            .size(16.dp)
                            .padding(1.dp)
                            .background(getColor(value))
                    ) {}
                }
            }
        }
    }
}

fun getColor(value: Int): ColorProvider {
    return ColorProvider(
        when {
            value == 0 -> R.color.heat_0
            value < 3  -> R.color.heat_1
            value < 6  -> R.color.heat_2
            value < 10 -> R.color.heat_3
            else       -> R.color.heat_4
        }
    )
}

class HeatMapReceiverGlance : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = HeatMapWidgetGlance()
}