package com.example.leetcode_stats

import org.json.JSONObject
import java.util.Calendar

data class LeetCodeData(
    val streak: Int,
    val totalActiveDays: Int,
    val activeYears: List<Int>,
    val submissionCalendar: Map<Long, Int>
) {
    companion object {

        fun fromJson(json: JSONObject): LeetCodeData {
            val userCalendar = json
                .getJSONObject("data")
                .getJSONObject("matchedUser")
                .getJSONObject("userCalendar")

            val streak = userCalendar.optInt("streak", 0)
            val totalActiveDays = userCalendar.optInt("totalActiveDays", 0)

            val activeYearsJson = userCalendar.optJSONArray("activeYears")
            val activeYears = mutableListOf<Int>()
            if (activeYearsJson != null) {
                for (i in 0 until activeYearsJson.length()) {
                    activeYears.add(activeYearsJson.getInt(i))
                }
            }

            val calendarStr = userCalendar.optString("submissionCalendar", "{}")
            val submissionCalendar = parseSubmissionCalendar(calendarStr)

            return LeetCodeData(
                streak = streak,
                totalActiveDays = totalActiveDays,
                activeYears = activeYears,
                submissionCalendar = submissionCalendar
            )
        }

        private fun parseSubmissionCalendar(jsonStr: String): Map<Long, Int> {
            val result = mutableMapOf<Long, Int>()
            if (jsonStr.isEmpty() || jsonStr == "{}") return result

            try {
                val obj = JSONObject(jsonStr)
                val keys = obj.keys()
                val today = normalizeToMidnight(System.currentTimeMillis())

                while (keys.hasNext()) {
                    val key = keys.next()
                    val timestampSec = key.toLongOrNull() ?: continue
                    val timestampMs = timestampSec * 1000L

                    val normalizedDay = normalizeToMidnight(timestampMs)
                    if (normalizedDay > today) continue

                    val count = obj.optInt(key, 0)
                    if (count > 0) {
                        result[normalizedDay] = count
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            return result
        }

        fun normalizeToMidnight(epochMs: Long): Long {
            val cal = Calendar.getInstance()
            cal.timeInMillis = epochMs
            cal.set(Calendar.HOUR_OF_DAY, 0)
            cal.set(Calendar.MINUTE, 0)
            cal.set(Calendar.SECOND, 0)
            cal.set(Calendar.MILLISECOND, 0)
            return cal.timeInMillis
        }
    }
}
