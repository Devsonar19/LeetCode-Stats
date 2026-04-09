package com.example.leetcode_stats

import org.json.JSONObject
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

object LeetCodeApi {

    private const val BASE_URL = "https://leetcode.com/graphql"
    private const val TIMEOUT_MS = 15_000

    private val QUERY = """
        query userProfileCalendar(${'$'}username: String!, ${'$'}year: Int) {
          matchedUser(username: ${'$'}username) {
            userCalendar(year: ${'$'}year) {
              activeYears
              streak
              totalActiveDays
              submissionCalendar
            }
          }
        }
    """.trimIndent()

    @Throws(Exception::class)
    fun fetchUserCalendar(username: String, year: Int? = null): LeetCodeData {
        val variables = JSONObject().apply {
            put("username", username)
            if (year != null) put("year", year) else put("year", JSONObject.NULL)
        }
        val requestBody = JSONObject().apply {
            put("query", QUERY)
            put("variables", variables)
        }.toString()

        val connection = (URL(BASE_URL).openConnection() as HttpURLConnection).apply {
            requestMethod = "POST"
            setRequestProperty("Content-Type", "application/json")
            setRequestProperty("Accept", "application/json")
            setRequestProperty("User-Agent", "Mozilla/5.0")
            setRequestProperty("Referer", "https://leetcode.com")
            doOutput = true
            connectTimeout = TIMEOUT_MS
            readTimeout = TIMEOUT_MS
        }

        OutputStreamWriter(connection.outputStream, "UTF-8").use { writer ->
            writer.write(requestBody)
            writer.flush()
        }

        val statusCode = connection.responseCode
        if (statusCode != 200) {
            throw Exception("HTTP $statusCode from LeetCode API")
        }

        val responseText = connection.inputStream.bufferedReader(Charsets.UTF_8).readText()
        connection.disconnect()

        val json = JSONObject(responseText)

        if (json.has("errors")) {
            throw Exception("GraphQL error: ${json.getJSONArray("errors")}")
        }

        val matchedUser = json
            .getJSONObject("data")
            .optJSONObject("matchedUser")
            ?: throw Exception("User '$username' not found")

        val wrappedJson = JSONObject().apply {
            put("data", JSONObject().apply {
                put("matchedUser", matchedUser)
            })
        }

        return LeetCodeData.fromJson(wrappedJson)
    }
}
