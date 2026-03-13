import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:leetcode_heatmap/leetcode_heatmap.dart';

class SubmissionHeatmap extends StatelessWidget {
  final String username;
  final String submissionCalender;
  const SubmissionHeatmap({super.key, required this.username, required this.submissionCalender});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> calendar = jsonDecode(submissionCalender);

    // calculating total submission
    int totalSubmissions = 0;
    calendar.forEach((key, value){
      totalSubmissions += value as int;
    });

    int maxStreak = 0;
    int currentStreak = 0;
    final sortedDates = calendar.keys.toList()..sort();

    // calculating max streak
    for(var date in sortedDates){
      if(calendar[date] > 0){
        currentStreak++;
        if(currentStreak > maxStreak){
          maxStreak = currentStreak;
        }else{
          currentStreak = 0;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0,4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$totalSubmissions Total Submissions",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "Max Streak: $maxStreak",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 200,
            width: double.infinity,
            child: SingleChildScrollView(
              child: LeetCodeHeatmap(
                username: username,
                cellSize: 14,
                cellSpacing: 2,
                showStats: false,
                showLegend: true,
                autoScrollToEnd: true,
                weekSpacing: 0,
                showBorder: true,
                showDayLabels: true,
              ),
            ),
          ),


        ],
      ),
    );

  }
}
