import 'package:flutter/material.dart';

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

    final progress = totalSolved / totalQuestions;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 12,
            offset: const Offset(0,4),
          )
        ],
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth * 0.45;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size,
                width: size,
                child: Stack(
                  alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: size,
                        width: size,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      SizedBox(
                        height: size,
                        width: size,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          color: Colors.green,
                        )
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$totalSolved / $totalQuestions",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Solved",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              letterSpacing: 1.2,
                            ),
                          )
                        ],
                      )
                    ],
                ),
              ),
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
            backgroundColor: Colors.grey.shade700,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        )
      ],

    );
  }

}