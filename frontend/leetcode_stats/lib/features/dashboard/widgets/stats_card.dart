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

      child: LayoutBuilder(
        builder: (context, constraints) {

          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return _mobileLayout(
              totalSolved,
              totalQuestions,
              easySolved,
              totalEasy,
              mediumSolved,
              totalMedium,
              hardSolved,
              totalHard,
              rank,
            );
          }

          return _desktopLayout(
            totalSolved,
            totalQuestions,
            easySolved,
            totalEasy,
            mediumSolved,
            totalMedium,
            hardSolved,
            totalHard,
            rank,
          );
        },
      ),
    );
  }

  Widget _mobileLayout(
      totalSolved,
      totalQuestions,
      easySolved,
      totalEasy,
      mediumSolved,
      totalMedium,
      hardSolved,
      totalHard,
      rank,
      ) {

    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statBox("Total Solved", "$totalSolved / $totalQuestions"),
            _statBox("Rank", "$rank"),
          ],
        ),

        const SizedBox(height:16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _difficultyBox("Easy", "$easySolved / $totalEasy", Colors.teal),
            _difficultyBox("Medium", "$mediumSolved / $totalMedium", Colors.amber),
            _difficultyBox("Hard", "$hardSolved / $totalHard", Colors.red),
          ],
        )
      ],
    );
  }

  Widget _desktopLayout(
      totalSolved,
      totalQuestions,
      easySolved,
      totalEasy,
      mediumSolved,
      totalMedium,
      hardSolved,
      totalHard,
      rank,
      ) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        _statBox("Total Solved", "$totalSolved / $totalQuestions"),
        _statBox("Rank", "$rank"),

        _difficultyBox("Easy", "$easySolved / $totalEasy", Colors.teal),
        _difficultyBox("Medium", "$mediumSolved / $totalMedium", Colors.amber),
        _difficultyBox("Hard", "$hardSolved / $totalHard", Colors.red),
      ],
    );
  }

  Widget _statBox(String title, String value) {

    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize:16)),
        const SizedBox(height:6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal:18, vertical:10),
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
                fontSize:18,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        )
      ],
    );
  }

  Widget _difficultyBox(String title, String value, Color color) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal:16, vertical:10),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}