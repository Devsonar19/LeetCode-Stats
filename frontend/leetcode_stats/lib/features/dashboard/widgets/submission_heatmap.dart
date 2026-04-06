import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leetcode_heatmap/leetcode_heatmap.dart';
import 'package:leetcode_stats/core/utils/streak_calculator.dart';

class SubmissionHeatmap extends StatelessWidget {
  final String username;
  final String submissionCalender;
  const SubmissionHeatmap({super.key, required this.username, required this.submissionCalender});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> calendar = jsonDecode(submissionCalender);
    final streakData =  calculateStreak(calendar);

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.20),
            blurRadius: 12,
            offset: const Offset(0,4),
          )
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.20)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Activity",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 16
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.teal.shade300,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Submissions",
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    Text(
                      "${streakData.totalSubmissions}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.teal.shade300,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    "Max Streak",
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    Text(
                      "${streakData.maxStreak}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),



            ],
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LeetCodeHeatmap(
              errorWidgetBuilder: (error){
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.lock_outline, size: 30, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("User has hidden submission activity"),
                    ],
                  ),
                );
              },
              username: username,
              cellSize: 14,
              cellSpacing: 2,
              showStats: false,
              showLegend: true,
              autoScrollToEnd: true,
              showBorder: true,
              showDayLabels: true,
              showMonthLabels: true,
              weekSpacing: 0,
              padding: const EdgeInsets.all(5),
            ),
          ),
        ],
      ),
    );
  }
}
