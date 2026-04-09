package com.example.leetcode_stats

import android.graphics.*
import java.util.Calendar

object HeatmapRenderer {

    private val BG            = Color.parseColor("#0D1117")
    private val COLOR_EMPTY   = Color.parseColor("#161B22")
    private val COLOR_L1      = Color.parseColor("#0E4429")
    private val COLOR_L2      = Color.parseColor("#006D32")
    private val COLOR_L3      = Color.parseColor("#26A641")
    private val COLOR_L4      = Color.parseColor("#39D353")
    private val COLOR_FUTURE  = Color.parseColor("#0D1117")
    private val COLOR_ACCENT  = Color.parseColor("#39D353")
    private val COLOR_TEXT    = Color.parseColor("#C9D1D9")
    private val COLOR_SUBTEXT = Color.parseColor("#8B949E")
    private val COLOR_DIVIDER = Color.parseColor("#21262D")

    private val PALETTE = intArrayOf(COLOR_EMPTY, COLOR_L1, COLOR_L2, COLOR_L3, COLOR_L4)

    private const val OUTER_PAD   = 12f
    private const val SECTION_GAP = 6f
    private const val HEADER_H    = 18f
    private const val MONTH_H     = 14f
    private const val FOOTER_H    = 14f
    private const val CELL_SIZE   = 11f
    private const val CELL_GAP    = 2.5f


    fun render(
        data: LeetCodeData,
        widthPx: Int,
        heightPx: Int,
        density: Float,
        year: Int = Calendar.getInstance().get(Calendar.YEAR),
        username: String
    ): Bitmap {
        val d = density

        val pad      = OUTER_PAD   * d
        val secGap   = SECTION_GAP * d
        val headerH  = HEADER_H    * d
        val monthH   = MONTH_H     * d
        val footerH  = FOOTER_H    * d
        val cell     = CELL_SIZE   * d
        val cellGap  = CELL_GAP    * d

        val left   = pad
        val right  = widthPx  - pad
        val top    = pad
        val innerW = right - left

        val startMs = getYearStart(year)
        val endMs   = getYearEnd(year)
        val weeks   = generateWeeks(startMs, endMs)
        val todayMs = LeetCodeData.normalizeToMidnight(System.currentTimeMillis())

        val scaledStep = (innerW / weeks.size).coerceAtMost(cell + cellGap)
        val scaledCell = (scaledStep - cellGap).coerceAtLeast(4f)
        val cornerR    = (scaledCell * 0.22f).coerceAtMost(3f * d)

        val headerBaseY = top + headerH * 0.80f
        val divY = top + headerH + secGap * 0.5f
        val monthBaseY = divY + secGap * 0.7f + monthH * 0.80f
        val gridTop = monthBaseY + cellGap * 2f

        val gridBottomY = gridTop + 7 * (scaledCell + cellGap)
        val exactHeight = (gridBottomY + pad).toInt()
        val bmp = Bitmap.createBitmap(widthPx, exactHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)


        val cellPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        val headerPaint = makePaint(COLOR_TEXT,    12f, d, bold = true)
        val accentPaint = makePaint(COLOR_ACCENT,  11f, d, bold = true)
        val monthPaint  = makePaint(COLOR_SUBTEXT,  8f, d, mono = true)

        val appTitle = "LeetCode Stats"
        canvas.drawText(appTitle, left, headerBaseY, headerPaint)

        val streakLabel = "Max Streak: ${data.streak}"
        val streakW     = accentPaint.measureText(streakLabel)
        canvas.drawText(streakLabel, right - streakW, headerBaseY, accentPaint)


        var lastMonth  = -1

        for ((wIdx, week) in weeks.withIndex()) {
            val cal   = Calendar.getInstance().apply { timeInMillis = week.first() }
            val month = cal.get(Calendar.MONTH)
            if (month != lastMonth) {
                val x = left + wIdx * scaledStep
                if (x + monthPaint.measureText(MONTH_NAMES[month]) < right)
                    canvas.drawText(MONTH_NAMES[month], x, monthBaseY, monthPaint)
                lastMonth = month
            }
        }


        for ((wIdx, week) in weeks.withIndex()) {
            for ((dIdx, dayMs) in week.withIndex()) {
                val x = left + wIdx * scaledStep
                val y = gridTop + dIdx * (scaledCell + cellGap)

                val isFuture      = dayMs > todayMs
                val dayCal        = Calendar.getInstance().apply { timeInMillis = dayMs }
                val isOutsideYear = dayCal.get(Calendar.YEAR) != year
                val count         = if (isFuture || isOutsideYear) -1
                else data.submissionCalendar[dayMs] ?: 0

                cellPaint.color = getCellColor(count, isFuture, isOutsideYear)
                canvas.drawRoundRect(
                    RectF(x, y, x + scaledCell, y + scaledCell),
                    cornerR, cornerR, cellPaint
                )
            }
        }
        return bmp
    }


    private fun makePaint(
        color: Int, spSize: Float, density: Float,
        bold: Boolean = false, mono: Boolean = false
    ) = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        this.color    = color
        this.textSize = spSize * density
        this.typeface = when {
            mono && bold -> Typeface.create(Typeface.MONOSPACE, Typeface.BOLD)
            mono         -> Typeface.MONOSPACE
            bold         -> Typeface.create("sans-serif-medium", Typeface.NORMAL)
            else         -> Typeface.DEFAULT
        }
        if (bold && !mono) isFakeBoldText = true
    }

    private fun getCellColor(count: Int, isFuture: Boolean, isOutsideYear: Boolean): Int {
        if (isFuture || isOutsideYear || count < 0) return COLOR_FUTURE
        if (count == 0) return COLOR_EMPTY
        val idx = ((count / 3.0).toInt() + 1).coerceIn(1, PALETTE.size - 1)
        return PALETTE[idx]
    }

    private fun generateWeeks(startMs: Long, endMs: Long): List<List<Long>> {
        val weeks = mutableListOf<List<Long>>()
        val cal = Calendar.getInstance().apply {
            timeInMillis = startMs
            add(Calendar.DAY_OF_YEAR, -(get(Calendar.DAY_OF_WEEK) - 1))
            set(Calendar.HOUR_OF_DAY, 0); set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0);      set(Calendar.MILLISECOND, 0)
        }
        while (cal.timeInMillis <= endMs) {
            val week = mutableListOf<Long>()
            for (d in 0..6) {
                week.add(cal.timeInMillis)
                cal.add(Calendar.DAY_OF_YEAR, 1)
                if (cal.timeInMillis > endMs) break
            }
            weeks.add(week)
            if (cal.timeInMillis > endMs) break
        }
        return weeks
    }

    private fun getYearStart(year: Int): Long =
        Calendar.getInstance().apply {
            set(year, Calendar.JANUARY, 1, 0, 0, 0); set(Calendar.MILLISECOND, 0)
        }.timeInMillis

    private fun getYearEnd(year: Int): Long {
        val now = Calendar.getInstance().get(Calendar.YEAR)
        return if (year == now) LeetCodeData.normalizeToMidnight(System.currentTimeMillis())
        else Calendar.getInstance().apply {
            set(year, Calendar.DECEMBER, 31, 0, 0, 0); set(Calendar.MILLISECOND, 0)
        }.timeInMillis
    }

    private val MONTH_NAMES = arrayOf(
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
    )
}