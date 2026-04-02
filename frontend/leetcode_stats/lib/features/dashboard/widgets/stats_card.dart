import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const StatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {

    final totalSolved = stats["totalSolved"];
    final totalQuestions = stats["totalQuestions"];

    final easySolved = stats["easySolved"];
    final totalEasy = stats["totalEasy"];

    final mediumSolved = stats["mediumSolved"];
    final totalMedium = stats["totalMedium"];

    final hardSolved = stats["hardSolved"];
    final totalHard = stats["totalHard"];

    final rank = stats["ranking"];
    final topPercentage = stats["topPercentage"];


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
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
        ),

        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total Problems Solved",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 13
                  ),
                ),
                const SizedBox(height: 10,),

                _statsShow(context, totalSolved, totalQuestions, rank, topPercentage),

                const SizedBox(height: 20,),

                _progressRow(
                  "Easy",
                  easySolved,
                  totalEasy,
                  Colors.teal,
                  context
                ),
                const SizedBox(height: 10,),
                _progressRow(
                  "Medium",
                  mediumSolved,
                  totalMedium,
                  Colors.amber,
                  context
                ),
                const SizedBox(height: 10,),
                _progressRow(
                  "Hard",
                  hardSolved,
                  totalHard,
                  Colors.red,
                  context
                ),

              ],
            );
          },
        ),
      ),
    );
  }

  Widget _progressRow(
      String title,
      int solved,
      int total,
      Color color,
      BuildContext context,
  ) {
    final progress = solved / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$solved / $total",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        const SizedBox(height: 5),

        ClipRect(
          child: LinearProgressIndicator(
            value: progress,
            color: color,
            minHeight: 10,
            backgroundColor: Colors.grey.shade500,
            valueColor: AlwaysStoppedAnimation(color),
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ],

    );
  }

  Widget _statsShow(
      BuildContext context,
      int solved,
      int total,
      int rank,
      num? topPercentage
      ){
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "$solved",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 60
                ),
              ),
              Text(
                "/ $total",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Global Ranking",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    )
                  ),
                  Text(
                    "$rank",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  )
                ]
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.teal.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.10),
                      blurRadius: 50,
                      offset: const Offset(0,0),
                    )
                  ]
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),

                child: Text(
                  "Top ${topPercentage?.toStringAsFixed(2) ?? "Error"}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ],
      );
  }
}